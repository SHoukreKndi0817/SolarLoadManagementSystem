<?php

namespace App\Http\Controllers\SLMT;

use Illuminate\Http\Request;
use App\Models\BroadcastDevice;
use App\Http\Controllers\Controller;
use Illuminate\Validation\ValidationException;

class SendActionController extends Controller
{
    public function SendAction(Request $request)
    {
        try {
            // التحقق من صحة البيانات المدخلة
            $validatedData = $request->validate([
                'ip_addrees' => 'required|ip|exists:broadcast_devices,ip_addrees',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], 422, [], JSON_PRETTY_PRINT);
        }

        try {
            // البحث عن جهاز البث باستخدام عنوان الـ IP
            $broadcastDevice = BroadcastDevice::where('ip_addrees', $validatedData['ip_addrees'])->first();

            // التحقق من وجود جهاز البث
            if (!$broadcastDevice) {
                return response()->json(["msg" => "Broadcast device not found"], 404, [], JSON_PRETTY_PRINT);
            }

            // جلب جميع المقابس المرتبطة بجهاز البث
            $sockets = $broadcastDevice->Socket()->select('serial_number', 'status')->get();

            // التحقق من وجود مقابس مرتبطة
            if ($sockets->isEmpty()) {
                return response()->json(["msg" => "No sockets found for this broadcast device"], 404, [], JSON_PRETTY_PRINT);
            }

            // إعادة البيانات مع رسالة النجاح
            return response()->json([
                "msg" => "Success",
                "sockets" => $sockets
            ], 200, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }
}
