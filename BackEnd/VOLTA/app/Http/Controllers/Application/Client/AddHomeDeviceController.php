<?php

namespace App\Http\Controllers\Application\Client;

use App\Models\Socket;
use App\Models\HomeDevice;
use Illuminate\Http\Request;
use App\Models\BroadcastDevice;
use App\Models\SolarSystemInfo;
use App\Http\Controllers\Controller;
use Illuminate\Validation\ValidationException;

class AddHomeDeviceController extends Controller
{


    //-------------------------------------------------------------------------------------
    //-----------Show All Socket That Belong to this Solar System -------------------------
    public function AllSocket(Request $request)
    {
        try {
            // تحقق من صحة البيانات
            $validatedData = $request->validate([
                'client_id' => 'required|exists:clients,client_id',
                'solar_sys_info_id' => 'required|exists:solar_system_infos,solar_sys_info_id',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], $e->status, [], JSON_PRETTY_PRINT);
        }

        try {
            // التحقق من أن solar_sys_info_id تابع لـ client_id
            $solarSystemInfo = SolarSystemInfo::where('solar_sys_info_id', $request->solar_sys_info_id)
                ->where('client_id', $request->client_id)
                ->first();

            if (!$solarSystemInfo) {
                return response()->json([
                    "msg" => "The specified solar system does not belong to the client.",
                ], 403, [], JSON_PRETTY_PRINT);
            }

            // جلب جميع المقابس المرتبطة بالـ solar_sys_info_id
            $sockets = Socket::where('broadcast_device_id', $solarSystemInfo->broadcast_device_id)->get();

            return response()->json([
                "msg" => "Successfully",
                "Socket" => $sockets,
            ], 200, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }
    //-----------------------------------------------------------------------------------------------------------------------------------
    //Admin Add new Home Device Data----------------------------------------------------------------------------
    public function AddHomeDeviceData(Request $request)
    {
        try {
            // قواعد التحقق من البيانات
            $validatedData = $request->validate([
                'client_id' => 'required|exists:clients,client_id', // تأكد من وجود الزبون
                'socket_id' => 'required|exists:sockets,socket_id', // تأكد من وجود المقبس
                'device_name' => 'required|string|max:255',
                'device_type' => 'required|string|max:255',
                'device_operation_type' => 'required|string|max:255',
                'operation_max_voltage' => 'required|numeric',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], $e->status, [], JSON_PRETTY_PRINT);
        }

        try {

            $sockets = HomeDevice::where('socket_id', $validatedData['socket_id'])->first();
            if ($sockets) {

                return response()->json([
                    "msg" => "The specified sockets is used to " . $sockets->device_name,
                ], 403, [], JSON_PRETTY_PRINT);
            }
            $HomeDeviceData = $request->except('client_id');
            // إنشاء جهاز المنزل
            $HomeDevice = HomeDevice::create($HomeDeviceData);

            return response()->json([
                "msg" => "Home device created successfully",
                "Home Device Data" => $HomeDevice
            ], 201, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }

    //-------------------------------------------------------------------------------------------------
    //Get data device home -----------------------------------------------------
    public function GetHomeDevicesAddedByClient(Request $request)
    {
        try {
            // التحقق من صحة البيانات المدخلة
            $validatedData = $request->validate([
                'client_id' => 'required|exists:clients,client_id',
                'solar_sys_info_id' => 'required|exists:solar_system_infos,solar_sys_info_id',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], 422, [], JSON_PRETTY_PRINT);
        }

        try {
            // الحصول على النظام الشمسي الخاص بالعميل-----------
            $solarSystem = SolarSystemInfo::where('client_id', $validatedData['client_id'])
                ->where('solar_sys_info_id', $validatedData['solar_sys_info_id'])
                ->first();

            if (!$solarSystem) {
                return response()->json(["msg" => "Solar system not found for the specified client."], 404, [], JSON_PRETTY_PRINT);
            }

            // الحصول على أجهزة البث المرتبطة بالنظام الشمسي---------------------
            $broadcastDevices = BroadcastDevice::where('broadcast_device_id', $solarSystem->broadcast_device_id)->get();

            if ($broadcastDevices->isEmpty()) {
                return response()->json(["msg" => "No broadcast devices found for the specified solar system."], 404, [], JSON_PRETTY_PRINT);
            }

            // الحصول على المقابس المرتبطة بكل جهاز بث----------------------
            $socketIds = Socket::whereIn('broadcast_device_id', $broadcastDevices->pluck('broadcast_device_id'))->pluck('socket_id');

            if ($socketIds->isEmpty()) {
                return response()->json(["msg" => "No sockets found for the specified broadcast devices."], 404, [], JSON_PRETTY_PRINT);
            }

            // الحصول على الأجهزة المنزلية المرتبطة بالمقابس
            $homeDevices = HomeDevice::with('Socket')->whereIn('socket_id', $socketIds)->select('home_device_id', 'device_name', 'socket_id')->get();

            if ($homeDevices->isEmpty()) {
                return response()->json(["msg" => "No home devices found for the specified sockets."], 404, [], JSON_PRETTY_PRINT);
            }
            // تنسيق البيانات بحيث تشمل فقط اسم الجهاز، رقم المقبس، اسم المقبس وحالة المقبس-----------------------------------
            $homeDevicesWithSocketInfo = $homeDevices->map(function ($homeDevice) {
                return [
                    'home_device_id' => $homeDevice->home_device_id,
                    'device_name' => $homeDevice->device_name,
                    'socket_id' => $homeDevice->socket_id,
                    'socket_name' => $homeDevice->Socket ? $homeDevice->Socket->socket_name : 'Unknown', // اسم المقبس
                    'socket_status' => $homeDevice->Socket ? $homeDevice->Socket->status : 'Unknown', // حالة المقبس
                ];
            });
            // إرجاع الأجهزة المنزلية--------------------------------------------------------------
            return response()->json([
                "msg" => "Home devices retrieved successfully",
                "Home Devices" => $homeDevicesWithSocketInfo,

            ], 200, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }



    //-----------------------------------------------------------------------------------------------------------
    //-----------------------------Show Home Device Info ---------------------------------
    public function ShowHomeDeviceInfo(Request $request)
    {
        try {
            $validatedData = $request->validate([
                'home_device_id' => 'required|exists:home_devices,home_device_id',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], 422, [], JSON_PRETTY_PRINT);
        }

        try {
            $HomeDevice = HomeDevice::with('Socket')->where('home_device_id', $validatedData['home_device_id'])->first();
            return response()->json(
                [
                    'msg' => 'Succesfly',
                    'Home Device Information' => $HomeDevice,

                ],
                200,
                [],
                JSON_PRETTY_PRINT
            );
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }
}
