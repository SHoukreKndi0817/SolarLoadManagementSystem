<?php

namespace App\Http\Controllers\DashBoard;

use App\Models\Socket;
use Illuminate\Http\Request;
use App\Models\BroadcastDevice;
use App\Http\Controllers\Controller;
use Illuminate\Validation\ValidationException;

class BroadcastDeviceController extends Controller
{
    //------------------------------------------------------
    //Add Broadcast Device Data with Socket------------------------------
    public function AddBroadcastDeviceData(Request $request)
    {


        try {
            // التحقق من صحة البيانات
            $validatedData = $request->validate([
                'model' => 'required|string|max:255',
                'version' => 'required|string|max:255',
                'number_of_wired_port' => 'required|integer|min:0',
                'number_of_wireless_port' => 'required|integer|min:0',
                'mac_address' => ['required', 'string', 'unique:broadcast_devices', 'regex:/^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$/'],
                'sockets' => 'required|array',
                'sockets.*.socket_model' => 'required|string|max:255',
                'sockets.*.socket_version' => 'required|string|max:255',
                'sockets.*.socket_name' => 'required|string|max:255',
                'sockets.*.socket_connection_type' => 'required|string|max:255',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], $e->status, [], JSON_PRETTY_PRINT);
        }

        try {
            // إنشاء جهاز البث
            $broadcastDeviceData = $request->only(['model', 'version', 'number_of_wired_port', 'number_of_wireless_port', 'mac_address']);
            $broadcastDeviceData['status'] = 'inactive';
            $broadcastDevice = BroadcastDevice::create($broadcastDeviceData);

            // إنشاء المقابس المرتبطة
            $socketsData = $request->input('sockets');
            foreach ($socketsData as $socket) {
                Socket::create([
                    'broadcast_device_id' => $broadcastDevice->broadcast_device_id,
                    'socket_model' => $socket['socket_model'],
                    'socket_version' => $socket['socket_version'],
                    'socket_name' => $socket['socket_name'],
                    'socket_connection_type' => $socket['socket_connection_type'],
                    'status' =>  true,
                ]);
            }
            //get the socket data-------------------------
            $broadcastDevice->load('Socket');
            //-------------------------------
            return response()->json([
                "msg" => "Broadcast device and sockets added successfully",
                "Broadcast Device Data" => $broadcastDevice,
            ], 201, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }
}
