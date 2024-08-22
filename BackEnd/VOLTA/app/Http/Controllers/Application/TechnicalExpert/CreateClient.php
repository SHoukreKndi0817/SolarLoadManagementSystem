<?php

namespace App\Http\Controllers\Application\TechnicalExpert;

use App\Models\Client;
use Illuminate\Support\Str;
use Illuminate\Http\Request;
use App\Models\BroadcastDevice;
use App\Models\SolarSystemInfo;
use App\Models\TechnicalExpert;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Validator;
use Illuminate\Validation\ValidationException;

class CreateClient extends Controller
{
    //-----------------------------------------------------Client-----------------
    //Create Client Account-------------------------------------------------
    public function AddClientAccount(Request $request)
    {

        try {
            // قواعد التحقق من البيانات
            $validatedData = $request->validate([
                'name' => 'required|string|max:255',
                'phone_number' => ['required', 'string', 'min:10', 'max:16', 'regex:/^0\d{8,14}$/', 'unique:clients'],
                'home_address' => 'required|string|max:255',
                'user_name' => 'required|string|max:255|unique:clients',
                'password' => 'required|string|min:6',
                'technical_expert_id' => 'required|exists:technical_experts,technical_expert_id',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], $e->status, [], JSON_PRETTY_PRINT);
        }
        try {
            $ClientData = $request->all();
            $ClientData['password'] = Hash::make($ClientData['password']);

            //generate connection_code and check is unique-----------
            do {
                $connection_code = strtoupper(Str::random(6));
            } while (Client::where('connection_code', $connection_code)->exists());
            $ClientData['connection_code'] = $connection_code;
            //--------------------------------------------------
            $Client = Client::create($ClientData);
            return response()->json([
                "msg" => "Client created successfully",
                "Client Data" => $Client
            ], 201, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }

    //-----------------------------------------------------------------------
    //Show All client The Technical Expert created account -------------------------

    public function ShowAllClientYouAdd(Request $request)
    {

        try {
            $validatedData = $request->validate([
                'technical_expert_id' => 'required|exists:technical_experts,technical_expert_id'
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], 422, [], JSON_PRETTY_PRINT);
        }
        try {
            //Show all client the technical created it -----------------------
            $AllClient = Client::where('technical_expert_id', $request->technical_expert_id)->get();
            if ($AllClient->isNotEmpty()) {
                return response()->json([
                    'msg' => 'Successfully',
                    'All Client your Added' => $AllClient
                ], 200, [], JSON_PRETTY_PRINT);
            } else return response()->json([
                'msg' => 'You have not added any client yet',
            ], 404, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }
    //----------------------------------------------------------------------------------------------
    //Show Client Data----------------------------------------------------------------------
    public function ShowClientData(Request $request)
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
            $Client = Client::findOrFail($request->input('client_id'));
            return response()->json([
                'msg' => 'Successfully find',
                'Client data' => $Client
            ], 200, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }

    //-------------------------------------------------------------------
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
            return response()->json([
                'msg' => 'Successfully ',
                'Solar System  data' => $AllSolarSystem
            ], 200, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }

    //--------------------------------------------------------------
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
            $broadcastDevice = BroadcastDevice::findOrFail($broadcastDeviceId);

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
}
