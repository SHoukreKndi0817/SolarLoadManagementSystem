<?php

namespace App\Http\Controllers\SLMT;

use App\Models\Socket;
use App\Models\Battery;
use App\Models\Inverter;
use App\Models\HomeDevice;
use Illuminate\Http\Request;
use App\Models\BroadcastData;
use App\Models\SolarSystemInfo;
use App\Http\Controllers\Controller;
use Illuminate\Validation\ValidationException;

class SendActionToSocketController extends Controller
{
    public function CheckPowerToSendAction(Request $request)
    {
        try {
            // التحقق من صحة البيانات المدخلة
            $validatedData = $request->validate([
                'solar_sys_info_id' => 'required|exists:solar_system_infos,solar_sys_info_id',
                'home_device_id' => 'required|exists:home_devices,home_device_id',
                'operation' => 'required|in:on,off',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], 422, [], JSON_PRETTY_PRINT);
        }

        try {
            // جلب بيانات الجهاز المراد تشغيله
            $device = HomeDevice::with('Socket')->find($validatedData['home_device_id']);
            $devicePower = $device->operation_max_watt; // استهلاك الجهاز من جدول HomeDevice
            $serialNumberForSocket = $device->Socket->serial_number;

            // إيقاف تشغيل الجهاز
            if ($validatedData['operation'] === 'off') {
                // تحديث حالة المقبس
                $socket = Socket::where('serial_number', $serialNumberForSocket)->first();
                if ($socket) {
                    $socket->status = 0; // إيقاف المقبس
                    $socket->save(); // حفظ التغيير في قاعدة البيانات
                }
                return response()->json(["msg" => "Device turned off successfully"], 200, [], JSON_PRETTY_PRINT);
            } else {
                // جلب بيانات المنظومة الشمسية
                $solarSystem = SolarSystemInfo::find($validatedData['solar_sys_info_id']);

                // جلب بيانات الإنفرتر
                $inverter = Inverter::find($solarSystem->inverters_id);
                $inverterMaxPower = $inverter->invert_mode_rated_power; // قدرة الإنفرتر القصوى

                // جلب بيانات البث الحالية (Broadcast Data)
                $broadcastData = BroadcastData::where('broadcast_device_id', $solarSystem->broadcast_device_id)->latest()->first();

                // جلب بيانات البطارية
                $battery = Battery::find($solarSystem->battery_id);

                // حساب الطاقة المتاحة من البطارية (بالواط)
                $batteryVoltage = $broadcastData->battery_voltage;
                $batteryCapacity = $solarSystem->battery_conection_type; // 12V, 24V, 32V
                $batteryFullWatts = $battery->maximum_watt_battery; // قدرة البطارية على توليد طاقة

                // التحقق مما إذا كان جهد البطارية أكبر من جهد البطارية في حال الشحن الكامل
                if ($batteryVoltage > $battery->absorb_stage_volts) {
                    $batteryVoltage = $battery->absorb_stage_volts; // 12.9 فولت
                }
                $batteryAvailablePower = ($batteryFullWatts * ($batteryVoltage / $battery->absorb_stage_volts)) * ($batteryCapacity / 12);

                // حساب الطاقة المتاحة من الألواح الشمسية
                $solarPowerGeneration = $broadcastData['solar_power_generation(w)'];

                // الطاقة المستهلكة حاليًا من الأجهزة
                $currentPowerConsumption = $broadcastData["power_consumption(w)"];

                // *** هنا نتحقق من السحب الكلي مقارنة مع قدرة الإنفرتر ***
                $totalPowerAfterDevice = $currentPowerConsumption + $devicePower;

                //-----------------------------------------------------------------------------


                // التحقق من حالة الكهرباء الوطنية (electric)
                if ($broadcastData->electric == '1') {
                    // الكهرباء الوطنية متاحة
                    if ($totalPowerAfterDevice < $inverterMaxPower) {
                        // النظام قادر على تشغيل الجهاز باستخدام الكهرباء الوطنية دون تجاوز قدرة الإنفرتر
                        $socket = Socket::where('serial_number', $serialNumberForSocket)->first();
                        if ($socket) {
                            $socket->status = 1; // تشغيل المقبس
                            $socket->save(); // حفظ التغيير في قاعدة البيانات
                        }
                        return response()->json(["msg" => "Device turned on successfully using grid power"], 200, [], JSON_PRETTY_PRINT);
                    } else {
                        return response()->json(["msg" => "Insufficient grid power to turn on the device (inverter limit exceeded)"], 400, [], JSON_PRETTY_PRINT);
                    }
                }

                // التحقق من حالة الطاقة الشمسية
                elseif ($solarPowerGeneration > 0) {
                    $remainingSolarPower = $solarPowerGeneration - $currentPowerConsumption;

                    if ($remainingSolarPower >= $devicePower && $totalPowerAfterDevice <= $inverterMaxPower) {
                        // النظام قادر على تشغيل الجهاز باستخدام الطاقة الشمسية فقط دون تجاوز قدرة الإنفرتر
                        $socket = Socket::where('serial_number', $serialNumberForSocket)->first();
                        if ($socket) {
                            $socket->status = 1; // تشغيل المقبس
                            $socket->save(); // حفظ التغيير في قاعدة البيانات
                        }
                        return response()->json(["msg" => "Device turned on successfully using solar power"], 200, [], JSON_PRETTY_PRINT);
                    } else {
                        // الطاقة الشمسية غير كافية، نتحقق من الطاقة المتاحة من البطارية
                        $totalAvailablePower = ($batteryAvailablePower + $solarPowerGeneration) - $currentPowerConsumption;

                        // تحقق من أن جهد البطارية ليس أقل من 11.0 فولت قبل استخدام البطارية
                        if ($batteryVoltage < 11.0) {
                            return response()->json(["msg" => "Battery voltage too low to use battery power"], 400, [], JSON_PRETTY_PRINT);
                        }

                        if ($totalAvailablePower >= $devicePower && $totalPowerAfterDevice <= $inverterMaxPower) {
                            // النظام قادر على تشغيل الجهاز باستخدام الطاقة الشمسية والبطارية معًا دون تجاوز قدرة الإنفرتر
                            $socket = Socket::where('serial_number', $serialNumberForSocket)->first();
                            if ($socket) {
                                $socket->status = 1; // تشغيل المقبس
                                $socket->save(); // حفظ التغيير في قاعدة البيانات
                            }
                            return response()->json(["msg" => "Device turned on successfully using solar and battery power"], 200, [], JSON_PRETTY_PRINT);
                        } else {
                            return response()->json(["msg" => "Insufficient solar and battery power to turn on the device (inverter limit exceeded)"], 400, [], JSON_PRETTY_PRINT);
                        }
                    }
                }

                // في حال عدم وجود كهرباء وطنية أو طاقة شمسية
                else if ($broadcastData->electric == '0' && $solarPowerGeneration == 0) {
                    // تحقق من أن جهد البطارية ليس أقل من 11.0 فولت قبل استخدام البطارية
                    if ($batteryVoltage < 11.0) {
                        return response()->json(["msg" => "Battery voltage too low to use battery power"], 400, [], JSON_PRETTY_PRINT);
                    }

                    $remainingBatteryPower = $batteryAvailablePower - $currentPowerConsumption;

                    if ($remainingBatteryPower >= $devicePower && $totalPowerAfterDevice <= $inverterMaxPower) {
                        // النظام قادر على تشغيل الجهاز باستخدام البطارية فقط دون تجاوز قدرة الإنفرتر
                        $socket = Socket::where('serial_number', $serialNumberForSocket)->first();
                        if ($socket) {
                            $socket->status = 1; // تشغيل المقبس
                            $socket->save(); // حفظ التغيير في قاعدة البيانات
                        }
                        return response()->json(["msg" => "Device turned on successfully using battery power"], 200, [], JSON_PRETTY_PRINT);
                    } else {
                        return response()->json(["msg" => "Insufficient battery power to turn on the device"], 400, [], JSON_PRETTY_PRINT);
                    }
                }
            }
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }
}
