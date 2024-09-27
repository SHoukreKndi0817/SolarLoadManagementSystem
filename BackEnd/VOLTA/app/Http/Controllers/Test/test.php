<?php

namespace App\Http\Controllers\Test;

use App\Models\Socket;
use App\Models\HomeDevice;
use Illuminate\Http\Request;
use App\Models\BroadcastData;
use App\Http\Controllers\Controller;
use App\Models\BroadcastDevice;
use Illuminate\Validation\ValidationException;

class test extends Controller
{

    public function TestAlarmDown(Request $request)
    {
        try {
            // التحقق من صحة البيانات المدخلة
            $validatedData = $request->validate([
                'volt' => 'required',
                'operation' => 'required|in:on,off',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], 422, [], JSON_PRETTY_PRINT);
        }

        // جلب جهاز البث المطلوب
        $broadcastDeviceId = 11; // تعديل حسب الحاجة، إذا كان `home_device_id` هو فعلاً broadcast_device_id
        $device = BroadcastDevice::with('Socket')->find($broadcastDeviceId);

        if (!$device) {
            return response()->json(["msg" => "Broadcast device not found"], 404, [], JSON_PRETTY_PRINT);
        }

        // جلب جميع المقابس المرتبطة بجهاز البث
        $sockets = $device->Socket; // الوصول إلى علاقة المقابس

        foreach ($sockets as $socket) {
            if ($validatedData['operation'] === 'on') {
                if ($socket->socket_name === 'alarm') {
                    // تشغيل مقبس الـ alarm
                    $socket->status = 1;
                } else {
                    // إيقاف باقي المقابس
                    $socket->status = 0;
                }
                $socket->save(); // حفظ التغييرات
            } else {
                if ($socket->socket_name === 'alarm') {
                    // إيقاف مقبس الـ alarm
                    $socket->status = 0;
                    $socket->save(); // حفظ التغييرات
                }
            }
        }

        // تحديث الفولتية في جدول BroadcastData
        $broadcastData = BroadcastData::where('broadcast_device_id', $broadcastDeviceId)->latest()->first();

        if ($broadcastData) {
            $broadcastData->battery_voltage = $validatedData['volt']; // تحديث قيمة الفولتية
            $broadcastData->save(); // حفظ التغيير
        } else {
            return response()->json(["msg" => "Broadcast data not found"], 404, [], JSON_PRETTY_PRINT);
        }

        return response()->json(["msg" => "Sockets and voltage updated successfully"], 200, [], JSON_PRETTY_PRINT);
    }
    //--------------------------------------------------------------------------
    public function TestAlarmUp(Request $request)
    {
        try {
            // التحقق من صحة البيانات المدخلة
            $validatedData = $request->validate([
                'volt' => 'required',
                'operation' => 'required|in:on,off',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], 422, [], JSON_PRETTY_PRINT);
        }

        // جلب جهاز البث المطلوب
        $broadcastDeviceId = 11; // تعديل حسب الحاجة، إذا كان `home_device_id` هو فعلاً broadcast_device_id
        $device = BroadcastDevice::with('Socket')->find($broadcastDeviceId);

        if (!$device) {
            return response()->json(["msg" => "Broadcast device not found"], 404, [], JSON_PRETTY_PRINT);
        }

        // جلب جميع المقابس المرتبطة بجهاز البث
        $sockets = $device->Socket; // الوصول إلى علاقة المقابس

        foreach ($sockets as $socket) {
            if ($validatedData['operation'] === 'on') {
                if ($socket->socket_name === 'alarm') {
                    // تشغيل مقبس الـ alarm
                    $socket->status = 1;
                } else {
                    // إيقاف باقي المقابس
                    $socket->status = 0;
                }
                $socket->save(); // حفظ التغييرات
            } else {
                if ($socket->socket_name === 'alarm') {
                    // إيقاف مقبس الـ alarm
                    $socket->status = 0;
                    $socket->save(); // حفظ التغييرات
                }
            }
        }

        // تحديث الفولتية في جدول BroadcastData
        $broadcastData = BroadcastData::where('broadcast_device_id', $broadcastDeviceId)->latest()->first();

        if ($broadcastData) {
            $broadcastData->battery_voltage = $validatedData['volt']; // تحديث قيمة الفولتية
            $broadcastData->save(); // حفظ التغيير
        } else {
            return response()->json(["msg" => "Broadcast data not found"], 404, [], JSON_PRETTY_PRINT);
        }

        return response()->json(["msg" => "Sockets and voltage updated successfully"], 200, [], JSON_PRETTY_PRINT);
    }

    //----------------------------------------------------------------------------------------
    public function Turnon(Request $request)
    {
        try {
            // التحقق من صحة البيانات المدخلة
            $validatedData = $request->validate([
                'volt' => 'required',
                'operation' => 'required|in:on,off',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], 422, [], JSON_PRETTY_PRINT);
        }
        // جلب الجهاز المطلوب مع بيانات المقبس
        $broadcastDeviceId = 11; // تعديل حسب الحاجة، إذا كان `home_device_id` هو فعلاً broadcast_device_id
        $device = BroadcastDevice::with('Socket')->find($broadcastDeviceId);

        if (!$device) {
            return response()->json(["msg" => "Device not found"], 404, [], JSON_PRETTY_PRINT);
        }

        // جلب جميع المقابس المرتبطة بالجهاز
        $sockets = $device->Socket; // الوصول إلى علاقة المقابس

        foreach ($sockets as $socket) {
            if ($validatedData['operation'] === 'on') {
                if ($socket->socket_name === 'fridge') {
                    // تشغيل مقبس الـ alarm
                    $socket->status = 1;
                }
                $socket->save(); // حفظ التغييرات
            } else {
                if ($socket->socket_name === 'fridge') {
                    // تشغيل مقبس الـ alarm
                    $socket->status = 0;
                }
                $socket->save(); // حفظ التغييرات
            }
        }
        // تحديث الفولتية في جدول BroadcastData
        $broadcastData = BroadcastData::where('broadcast_device_id', $broadcastDeviceId)->latest()->first();

        if ($broadcastData) {
            $broadcastData->battery_voltage = $validatedData['volt']; // تحديث قيمة الفولتية
            $broadcastData->save(); // حفظ التغيير
        } else {
            return response()->json(["msg" => "Broadcast data not found"], 404, [], JSON_PRETTY_PRINT);
        }

        return response()->json(["msg" => "Sockets updated successfully"], 200, [], JSON_PRETTY_PRINT);
    }


    //--------------------------------------------------------------------------
    public function Voltn(Request $request)
    {
        try {
            // التحقق من صحة البيانات المدخلة
            $validatedData = $request->validate([
                'volt' => 'required',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], 422, [], JSON_PRETTY_PRINT);
        }

        // جلب جهاز البث المطلوب
        $broadcastDeviceId = 11; // تعديل حسب الحاجة، إذا كان `home_device_id` هو فعلاً broadcast_device_id
        $device = BroadcastDevice::find($broadcastDeviceId);

        if (!$device) {
            return response()->json(["msg" => "Broadcast device not found"], 404, [], JSON_PRETTY_PRINT);
        }
        // تحديث الفولتية في جدول BroadcastData
        $broadcastData = BroadcastData::where('broadcast_device_id', $broadcastDeviceId)->latest()->first();
        if ($broadcastData) {
            $broadcastData->battery_voltage = $validatedData['volt']; // تحديث قيمة الفولتية
            $broadcastData->save(); // حفظ التغيير
        } else {
            return response()->json(["msg" => "Broadcast data not found"], 404, [], JSON_PRETTY_PRINT);
        }

        return response()->json(["msg" => "Sockets and voltage updated successfully"], 200, [], JSON_PRETTY_PRINT);
    }
}
