<?php

namespace App\Http\Controllers\SLMT;

use Illuminate\Http\Request;
use App\Models\BroadcastData;
use App\Models\BroadcastDevice;
use App\Http\Controllers\Controller;
use Illuminate\Validation\ValidationException;

class BroadcastSLMTController extends Controller
{   // تابع لاستقبال بيانات البث من الجهاز باستخدام ip_addreess
    public function addBroadcastData(Request $request)
    {
        try {
            // التحقق من صحة البيانات المستلمة
            $validatedData = $request->validate([
                'battery_voltage' => 'required|numeric',
                'solar_power_generation' => 'required|numeric',
                'power_consumption' => 'required|numeric',
                'battery_percentage' => 'required|numeric|between:0,100',
                'electric' => 'required|in:1,0',
                'ip_addrees' => 'required|ip|exists:broadcast_devices,ip_addrees'
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], 422, [], JSON_PRETTY_PRINT);
        }

        try {
            // البحث عن الجهاز باستخدام ip_addreess
            $broadcastDevice = BroadcastDevice::where('ip_addrees', $request->ip_addrees)->first();
            if (!$broadcastDevice) {
                return response()->json(
                    ["msg" => "Broadcast device with this IP address not found"],
                    422,
                    [],
                    JSON_PRETTY_PRINT
                );
            }

            // تحديث أو إنشاء سجل في BroadcastData بناءً على broadcast_device_id
            $broadcastData = BroadcastData::updateOrCreate(
                ['broadcast_device_id' => $broadcastDevice->broadcast_device_id], // الشرط
                [
                    'battery_voltage' => $validatedData['battery_voltage'],
                    'solar_power_generation' => $validatedData['solar_power_generation'],
                    'power_consumption' => $validatedData['power_consumption'],
                    'battery_percentage' => $validatedData['battery_percentage'],
                    'electric' => $validatedData['electric'],
                    'status' => true
                ]
            );

            return response()->json([
                "msg" => "Successfully",
            ], 200, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }
}
