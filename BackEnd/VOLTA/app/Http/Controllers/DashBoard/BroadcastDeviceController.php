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


    public function ShowAllDeviceBroadcast()
    {
        try {
            $BroadcastDevice = BroadcastDevice::with('Socket')->get();
            if ($BroadcastDevice->isNotEmpty()) {
                return response()->json([
                    'msg' => 'Successfully ',
                    'All Broadcast Device' => $BroadcastDevice
                ], 200, [], JSON_PRETTY_PRINT);
            } else return response()->json([
                'msg' => 'Not Found Admin  ',
            ], 404, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }


    //-----------------------------------------------------------
    public function ShowDeviceBroadcast(Request $request)
    {
        try {
            // قواعد التحقق من البيانات
            $validatedData = $request->validate([

                'broadcast_device_id' => 'required|exists:broadcast_devices,broadcast_device_id',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], $e->status, [], JSON_PRETTY_PRINT);
        }
        try {
            $BroadcastDeviceData = BroadcastDevice::with('Socket')->findOrFail($request->input('broadcast_device_id'));
            return response()->json([
                'msg' => 'Successfully find',
                'BroadcastDevice Data' => $BroadcastDeviceData
            ], 200, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }


    // Edit Broadcast Device Data with Sockets------------------------------
    public function EditBroadcastDeviceData(Request $request)
    {
        try {
            // التحقق من صحة البيانات
            $validatedData = $request->validate([
                'broadcast_device_id' => 'required|exists:broadcast_devices,broadcast_device_id',
                'model' => 'sometimes|required|string|max:255',
                'version' => 'sometimes|required|string|max:255',
                'number_of_wired_port' => 'sometimes|required|integer|min:0',
                'number_of_wireless_port' => 'sometimes|required|integer|min:0',
                'mac_address' => ['sometimes', 'required', 'string', 'unique:broadcast_devices,mac_address,'
                    . $request->broadcast_device_id . ',broadcast_device_id', 'regex:/^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$/'],
                'sockets' => 'sometimes|required|array',
                'sockets.*.socket_id' => 'required|exists:sockets,socket_id',
                'sockets.*.socket_model' => 'sometimes|required|string|max:255',
                'sockets.*.socket_version' => 'sometimes|required|string|max:255',
                'sockets.*.socket_name' => 'sometimes|required|string|max:255',
                'sockets.*.socket_connection_type' => 'sometimes|required|string|max:255',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], $e->status, [], JSON_PRETTY_PRINT);
        }

        try {
            // الحصول على جهاز البث القديم
            $broadcastDevice = BroadcastDevice::findOrFail($request->input('broadcast_device_id'));

            // تحديث بيانات جهاز البث
            $broadcastDeviceData = $request->only(['model', 'version', 'number_of_wired_port', 'number_of_wireless_port', 'mac_address']);
            $broadcastDevice->update($broadcastDeviceData);

            // تحديث بيانات المقابس المرتبطة
            if ($request->has('sockets')) {
                foreach ($request->input('sockets') as $socketData) {
                    $socket = Socket::findOrFail($socketData['socket_id']);
                    $socketUpdateData = [
                        'socket_model' => $socketData['socket_model'] ?? $socket->socket_model,
                        'socket_version' => $socketData['socket_version'] ?? $socket->socket_version,
                        'socket_name' => $socketData['socket_name'] ?? $socket->socket_name,
                        'socket_connection_type' => $socketData['socket_connection_type'] ?? $socket->socket_connection_type,
                    ];
                    $socket->update($socketUpdateData);
                }
            }

            // تحميل البيانات المرتبطة
            $broadcastDevice->load('Socket');

            return response()->json([
                "msg" => "Broadcast device and sockets updated successfully",
                "Broadcast Device Data" => $broadcastDevice,
            ], 200, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }


    // Change the status of the Broadcast Device
    public function ChangeBroadcastDeviceStatus(Request $request)
    {
        try {
            $validatedData = $request->validate([
                'broadcast_device_id' => 'required|exists:broadcast_devices,broadcast_device_id'
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], 422, [], JSON_PRETTY_PRINT);
        }

        try {
            $broadcastDevice = BroadcastDevice::findOrFail($request->input('broadcast_device_id'));

            // Toggle the status
            $newStatus = $broadcastDevice->status === 'active' ? 'inactive' : 'active';
            $broadcastDevice->update(['status' => $newStatus]);

            return response()->json([
                'msg' => 'Broadcast Device status has been updated successfully',
                'new_status' => $newStatus,
            ], 200, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }

    // Change the status of the Socket
    public function ChangeSocketStatus(Request $request)
    {
        try {
            $validatedData = $request->validate([
                'socket_id' => 'required|exists:sockets,socket_id'
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], 422, [], JSON_PRETTY_PRINT);
        }

        try {
            $socket = Socket::findOrFail($request->input('socket_id'));

            // Toggle the status
            $newStatus = $socket->status == true ? false : true;
            $socket->update(['status' => $newStatus]);

            return response()->json([
                'msg' => 'Socket status has been updated successfully',
                'new_status' => $newStatus,
            ], 200, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }


    // Delete Broadcast Device with its associated Sockets
    public function DeleteBroadcastDevice(Request $request)
    {
        try {
            // التحقق من صحة البيانات
            $validatedData = $request->validate([
                'broadcast_device_id' => 'required|exists:broadcast_devices,broadcast_device_id'
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], 422, [], JSON_PRETTY_PRINT);
        }

        try {

            $broadcastDevice = BroadcastDevice::findOrFail($request->input('broadcast_device_id'));
            //Delet the associated Sockets
            Socket::where('broadcast_device_id', $broadcastDevice->broadcast_device_id)->delete();

            $broadcastDevice->delete();

            return response()->json([
                'msg' => 'Broadcast Device and its associated Sockets have been deleted successfully',
            ], 200, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => 'Failed to delete Broadcast Device'], 500, [], JSON_PRETTY_PRINT);
        }
    }


    //Send data for generate QR code----------------------------
    public function GenerateQRCodeData(Request $request)
    {
        try {
            // التحقق من صحة البيانات
            $validatedData = $request->validate([
                'broadcast_device_id' => 'required|exists:broadcast_devices,broadcast_device_id'
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], 422, [], JSON_PRETTY_PRINT);
        }

        try {
            // الحصول على بيانات جهاز البث
            $broadcastDevice = BroadcastDevice::findOrFail($request->input('broadcast_device_id'));

            // إعداد السلسلة النصية التي سيتم استخدامها لتوليد رمز QR
            $qrData = [
                'Unique ID' => $broadcastDevice->broadcast_device_id,
                'Model' => $broadcastDevice->model,
                'Version' => $broadcastDevice->version,
                'Number of Wired Ports' => $broadcastDevice->number_of_wired_port,
                'Number of Wireless Ports' => $broadcastDevice->number_of_wireless_port,
            ];
            $qrJSON = json_encode($qrData);

            return response()->json([
                'msg' => 'QR Data generated successfully',
                'QR Data' => $qrJSON
            ], 200, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => 'Failed to generate QR Data'], 500, [], JSON_PRETTY_PRINT);
        }
    }
}