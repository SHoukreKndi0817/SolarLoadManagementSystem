<?php

namespace App\Http\Controllers\Application\TechnicalExpert;

use App\Models\Client;
use Illuminate\Http\Request;
use App\Models\BroadcastDevice;
use App\Models\SolarSystemInfo;
use App\Http\Controllers\Controller;
use Illuminate\Validation\ValidationException;

class SolarSysytemInfoController extends Controller
{
    //-----------------------------------------------------------------------------
    //Add Solar System Data For Client-----------------------------
    public function AddSolarSystemInfo(Request $request)
    {
        try {
            // التحقق من صحة البيانات
            $validatedData = $request->validate([
                'technical_expert_id' => 'required|exists:technical_experts,technical_expert_id',
                'name' => 'required|string|max:255',
                'client_id' => 'required|exists:clients,client_id',
                'inverters_id' => 'required|exists:inverters,inverters_id',
                'number_of_battery' => 'nullable|integer|min:0',
                'battery_id' => 'nullable|exists:batteries,battery_id|required_with:number_of_battery',
                'number_of_panel' => 'nullable|integer|min:0',
                'panel_id' => 'nullable|exists:panels,panel_id|required_with:number_of_panel',
                'number_of_panel_group' => 'nullable|integer|min:0|required_with:number_of_panel',
                'panel_conection_typeone' => 'nullable|string|max:255|in:serial,branch|required_with:number_of_panel',
                'panel_conection_typetwo' => 'nullable|string|max:255|in:serial,branch|required_with:number_of_panel',
                'phase_type' => 'required|string|max:255|in:one,three',
                'qr_code_data' => 'required|string' // التأكد من أن بيانات QR موجودة
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], 422, [], JSON_PRETTY_PRINT);
        }

        try {
            // QR Code Processing------------------
            $qrData = json_decode($request->input('qr_code_data'), true);

            if (!isset($qrData['Unique ID'])) {
                return response()->json(["msg" => "Invalid QR code data"], 422, [], JSON_PRETTY_PRINT);
            }
            $broadcastDeviceId = $qrData['Unique ID'];
            //-------------------------------------
            // Verify that broadcast_device_id exists in the database.---------
            $broadcastDevice = BroadcastDevice::find($broadcastDeviceId);

            if (!$broadcastDevice) {
                return response()->json(["msg" => "Invalid QR code data: Broadcast device not found"], 404, [], JSON_PRETTY_PRINT);
            }
            //-------------------------------------
            // Verify that broadcast_device_id is not associated with another solar system--------------
            if (SolarSystemInfo::where('broadcast_device_id', $broadcastDeviceId)->exists()) {
                return response()->json(["msg" => "This broadcast device is already associated with another solar system"], 422, [], JSON_PRETTY_PRINT);
            }
            //-------------------------------------
            // Verify that Name is not already exists for this client--------------------
            if (SolarSystemInfo::where('client_id', $validatedData['client_id'])->where('name', $validatedData['name'])->exists()) {
                return response()->json(["msg" => "A solar system with the same name already exists for this client"], 422, [], JSON_PRETTY_PRINT);
            }
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }

        //---------------------------------------------------
        // Create a new record in SolarSystemInfo --------------------------

        try {
            $solarSystemInfo = SolarSystemInfo::create([
                'client_id' => $validatedData['client_id'],
                'name' => $validatedData['name'],
                'technical_expert_id' => $validatedData['technical_expert_id'],
                'inverters_id' => $validatedData['inverters_id'],
                'battery_id' => $validatedData['battery_id'] ?? null,
                'number_of_battery' => $validatedData['number_of_battery'] ?? 0,
                'panel_id' => $validatedData['panel_id'] ?? null,
                'number_of_panel' => $validatedData['number_of_panel'] ?? 0,
                'number_of_panel_group' => $validatedData['number_of_panel_group'] ?? "0",
                'panel_conection_typeone' => $validatedData['panel_conection_typeone'] ?? "null",
                'panel_conection_typetwo' => $validatedData['panel_conection_typetwo'] ?? "null",
                'phase_type' => $validatedData['phase_type'],
                'broadcast_device_id' => $broadcastDevice->broadcast_device_id
            ]);

            //Load Related Relationships------------------------------------
            $solarSystemInfo = SolarSystemInfo::with(['Client', 'Inverter', 'Battery', 'Panel', 'BroadcastDevice'])
                ->find($solarSystemInfo->solar_sys_info_id);
            //---------------------------------------

            return response()->json([
                "msg" => "Solar system information added successfully",
                "Solar System Info" => $solarSystemInfo,
            ], 201, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }

    //-------------------------------------------------------------------------
    //Show the Solar system info that associated with client ------------------------
    public function SolarSystemAssociatedWithClient(Request $request)
    {
        try {
            // قواعد التحقق من البيانات
            $validatedData = $request->validate([

                'client_id' => 'required|exists:clients,client_id',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], $e->status, [], JSON_PRETTY_PRINT);
        }

        try {
            $AllSolarSystem = SolarSystemInfo::where('client_id', $validatedData['client_id'])->get();
            // التحقق مما إذا كانت القائمة فارغة
            if ($AllSolarSystem->isEmpty()) {
                return response()->json([
                    'msg' => 'No solar systems associated with this client.',
                ], 404, [], JSON_PRETTY_PRINT);
            }
            return response()->json([
                'msg' => 'Successfully ',
                'Solar System  data' => $AllSolarSystem
            ], 200, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }
    //-------------------------------------------------------------------------------
    //update the solar system information for client ---------------------
    public function UpdateSolarSystemInfo(Request $request)
    {
        try {
            // التحقق من صحة البيانات، استخدام sometimes لجعل الحقول اختيارية
            $validatedData = $request->validate([
                'solar_sys_info_id' => 'required|exists:solar_system_infos,solar_sys_info_id',
                'name' => 'sometimes|required|string|max:255',
                'inverters_id' => 'sometimes|required|exists:inverters,inverters_id',
                'number_of_battery' => 'sometimes|nullable|integer|min:0',
                'battery_id' => 'sometimes|nullable|exists:batteries,battery_id|required_with:number_of_battery',
                'number_of_panel' => 'sometimes|nullable|integer|min:0',
                'panel_id' => 'sometimes|nullable|exists:panels,panel_id|required_with:number_of_panel',
                'number_of_panel_group' => 'sometimes|nullable|integer|min:0|required_with:number_of_panel',
                'panel_conection_typeone' => 'sometimes|nullable|string|max:255|in:serial,branch|required_with:number_of_panel',
                'panel_conection_typetwo' => 'sometimes|nullable|string|max:255|in:serial,branch|required_with:number_of_panel',
                'phase_type' => 'sometimes|required|string|max:255|in:one,three',
                'qr_code_data' => 'sometimes|required|string' // التأكد من أن بيانات QR موجودة إذا تم إرسالها
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], 422, [], JSON_PRETTY_PRINT);
        }

        try {

            $solarSystemInfo = SolarSystemInfo::find($request->input('solar_sys_info_id'));

            $client_id = $solarSystemInfo->client_id;

            // معالجة QR Code فقط إذا تم إرساله
            if ($request->has('qr_code_data')) {
                $qrData = json_decode($request->input('qr_code_data'), true);

                if (!isset($qrData['Unique ID'])) {
                    return response()->json(["msg" => "Invalid QR code data"], 422, [], JSON_PRETTY_PRINT);
                }
                $broadcastDeviceId = $qrData['Unique ID'];
                $broadcastDevice = BroadcastDevice::find($broadcastDeviceId);

                if (!$broadcastDevice) {
                    return response()->json(["msg" => "Invalid QR code data: Broadcast device not found"], 404, [], JSON_PRETTY_PRINT);
                }

                // التحقق من أن الجهاز غير مرتبط بمنظومة شمسية أخرى (إلا إذا كانت المنظومة الحالية)
                if (SolarSystemInfo::where('broadcast_device_id', $broadcastDeviceId)->where('solar_sys_info_id', '!=', $request->input('solar_sys_info_id'))->exists()) {
                    return response()->json(["msg" => "This broadcast device is already associated with another solar system"], 422, [], JSON_PRETTY_PRINT);
                }
                $solarSystemInfo->broadcast_device_id = $broadcastDeviceId;
            }

            // التحقق من الاسم إذا تم إرساله
            if ($request->has('name')) {
                if (SolarSystemInfo::where('client_id', $client_id)->where('name', $validatedData['name'])->where('solar_sys_info_id', '!=', $request->input('solar_sys_info_id'))->exists()) {
                    return response()->json(["msg" => "A solar system with the same name already exists for this client"], 422, [], JSON_PRETTY_PRINT);
                }
                $solarSystemInfo->name = $validatedData['name'];
            }

            $solarSystemInfo->update(array_filter($validatedData, function ($value) {
                return !is_null($value);
            }));

            // تحميل العلاقات المرتبطة وإعادة السجل المحدّث
            $solarSystemInfo = SolarSystemInfo::with(['Client', 'Inverter', 'Battery', 'Panel', 'BroadcastDevice'])
                ->find($solarSystemInfo->solar_sys_info_id);

            return response()->json([
                "msg" => "Solar system information updated successfully",
                "Solar System Info" => $solarSystemInfo,
            ], 200, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }
}
