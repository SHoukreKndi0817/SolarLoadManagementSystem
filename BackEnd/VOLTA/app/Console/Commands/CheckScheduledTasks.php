<?php

namespace App\Console\Commands;

use App\Models\Tasks;
use App\Models\HomeDevice;
use App\Models\Battery;
use App\Models\Inverter;
use App\Models\BroadcastData;
use Illuminate\Console\Command;
use Carbon\Carbon;
use App\Events\ClientNotiEvent;

class CheckScheduledTasks extends Command
{
    // اسم الكوماند المستخدمة لتشغيل الجدولة
    protected $signature = 'tasks:check';

    // وصف الكوماند
    protected $description = 'Check and execute scheduled tasks for home devices based on power availability';

    public function handle()
    {
        // جلب المهام المجدولة بناءً على الوقت الحالي
        $currentTime = Carbon::now();

        // جلب المهام التي تحتاج إلى التنفيذ
        $tasks = Tasks::where('status', 'pending')
            ->where('start_time', '<=', $currentTime)
            ->where('end_time', '>=', $currentTime)
            ->get();

        foreach ($tasks as $task) {
            try {
                // جلب بيانات الجهاز المراد تشغيله
                $device = HomeDevice::with('Socket')->find($task->home_device_id);
                $devicePower = $device->operation_max_watt;
                $serialNumberForSocket = $device->Socket->serial_number;

                // جلب بيانات النظام الشمسي المرتبط بالجهاز
                $broadcastDevice = $device->Socket->BroadcastDevice;
                $solarSystem = $broadcastDevice->SolarSystemInfo;
                $solar_sys_info_id = $solarSystem->solar_sys_info_id;

                // جلب بيانات الإنفرتر
                $inverter = Inverter::find($solarSystem->inverters_id);
                $inverterMaxPower = $inverter->invert_mode_rated_power;

                // جلب بيانات البث الحالية (Broadcast Data)
                $broadcastData = BroadcastData::where('broadcast_device_id', $broadcastDevice->broadcast_device_id)
                    ->latest()
                    ->first();

                // جلب بيانات البطارية
                $battery = Battery::find($solarSystem->battery_id);

                // حساب الطاقة المتاحة من البطارية (بالواط)
                $batteryVoltage = $broadcastData->battery_voltage;
                $batteryCapacity = $solarSystem->battery_conection_type;
                $batteryFullWatts = $battery->maximum_watt_battery;

                // التحقق مما إذا كان جهد البطارية أكبر من جهد الشحن الكامل
                if ($batteryVoltage > $battery->absorb_stage_volts) {
                    $batteryVoltage = $battery->absorb_stage_volts;
                }
                $batteryAvailablePower = ($batteryFullWatts * ($batteryVoltage / $battery->absorb_stage_volts)) * ($batteryCapacity / 12);

                // حساب الطاقة المتاحة من الألواح الشمسية
                $solarPowerGeneration = $broadcastData->solar_power_generation;

                // الطاقة المستهلكة حاليًا
                $currentPowerConsumption = $broadcastData->power_consumption;

                // التحقق من عدم تشغيل اكثر من حمل الانفرتر
                $totalPowerAfterDevice = $currentPowerConsumption + $devicePower;

                if ($broadcastData->electric == 'on') {
                    if ($totalPowerAfterDevice <= $inverterMaxPower) {
                        // إرسال رسالة أن الجهاز تم تشغيله باستخدام الكهرباء الوطنية
                        $this->sendNotification("Device {$device->device_name} turned on using grid power.", $task->client_id);
                        $task->update(['status' => 'completed']);
                    } else {
                        $this->sendNotification("Insufficient grid power to turn on the device (inverter limit exceeded).", $task->client_id);
                    }
                } elseif ($solarPowerGeneration > 0) {
                    // التحقق من الطاقة الشمسية
                    $remainingSolarPower = $solarPowerGeneration - $currentPowerConsumption;

                    if ($remainingSolarPower >= $devicePower && $totalPowerAfterDevice <= $inverterMaxPower) {
                        // إرسال رسالة أن الجهاز تم تشغيله باستخدام الطاقة الشمسية
                        $this->sendNotification("Device {$device->device_name} turned on using solar power.", $task->client_id);
                        $task->update(['status' => 'completed']);
                    } else {
                        // التحقق من استخدام البطارية بجانب الطاقة الشمسية
                        $totalAvailablePower = ($batteryAvailablePower + $solarPowerGeneration) - $currentPowerConsumption;

                        if ($totalAvailablePower >= $devicePower && $totalPowerAfterDevice <= $inverterMaxPower) {
                            $this->sendNotification("Device {$device->device_name} turned on using solar and battery power.", $task->client_id);
                            $task->update(['status' => 'completed']);
                        } else {
                            $this->sendNotification("Insufficient solar and battery power to turn on the device.", $task->client_id);
                        }
                    }
                } elseif ($broadcastData->electric == 'off' && $solarPowerGeneration == 0) {
                    // في حالة الاعتماد على البطارية فقط
                    $remainingBatteryPower = $batteryAvailablePower - $currentPowerConsumption;

                    if ($remainingBatteryPower >= $devicePower && $totalPowerAfterDevice <= $inverterMaxPower) {
                        $this->sendNotification("Device {$device->device_name} turned on using battery power.", $task->client_id);
                        $task->update(['status' => 'completed']);
                    } else {
                        $this->sendNotification("Insufficient battery power to turn on the device.", $task->client_id);
                    }
                }
            } catch (\Exception $e) {
                $this->sendNotification("Error executing task: " . $e->getMessage(), $task->client_id);
            }
        }
    }

    // دالة لإرسال الإشعارات باستخدام Pusher
    public function sendNotification($message, $clientId)
    {
        $data = [
            'message' => $message,
            'time' => now(),
        ];

        // إطلاق الحدث
        event(new ClientNotiEvent($data, $clientId));

        $this->info("Notification sent to client {$clientId}: {$message}");
    }
}
