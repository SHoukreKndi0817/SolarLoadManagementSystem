<?php

namespace App\Http\Controllers\Application\Client;

use App\Models\Socket;
use App\Models\HomeDevice;
use Illuminate\Http\Request;
use App\Models\SolarSystemInfo;
use App\Http\Controllers\Controller;
use Illuminate\Validation\ValidationException;

class AddHomeDeviceController extends Controller
{

    //-----------------------------------------------------------
    //Admin Add new Home Device Data-------------------
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
}
