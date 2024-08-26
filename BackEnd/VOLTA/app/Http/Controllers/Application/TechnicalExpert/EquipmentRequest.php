<?php

namespace App\Http\Controllers\Application\TechnicalExpert;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Models\RequestEquipment;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class EquipmentRequest extends Controller
{
    public function SendEquipmentRequest(Request $request)
    {

        try {
            // قواعد التحقق من البيانات
            $validatedData = $request->validate([
                'technical_expert_id' => 'required|exists:technical_experts,technical_expert_id',
                'name' => 'required|string',
                'number_of_broadcast_device' => 'required|integer',
                'number_of_port' => 'required|integer',
                'number_of_socket' => 'required|integer',
                'panel_id' => 'exists:panels,panel_id',
                'number_of_panel' => 'integer|required_with:panel_id',
                'battery_id' => 'exists:batteries,battery_id',
                'number_of_battery' => 'integer|required_with:battery_id',
                'inverters_id' => 'exists:inverters,inverters_id',
                'number_of_inverter' => 'integer|required_with:inverters:id',
                'additional_equipment' => 'required|string',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], $e->status, [], JSON_PRETTY_PRINT);
        }
        try {
            $EquipmentData = $request->all();
            $EquipmentData['status'] = 'pending'; //approved ,rejected 
            $EquipmentData['commet'] = 'Processing';
            $Equipment = RequestEquipment::create($EquipmentData);
            $Equipment->load('Inverter', 'Battery', 'Panel');
            return response()->json([
                "msg" => "Equipment created successfully",
                "Equipment Data" => $Equipment
            ], 201, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }
    //-------------------------------------------------------------------------------------------
    //Show All Request You Send ----------------------------------------------------------------
    public function ShowAllEquipmentRequest(Request $request)
    {

        try {
            $validatedData = $request->validate([
                'technical_expert_id' => 'required|exists:technical_experts,technical_expert_id'
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], 422, [], JSON_PRETTY_PRINT);
        }
        try {

            $AllEquipment = RequestEquipment::with('Panel', 'Battery', 'Inverter')->where('technical_expert_id', $validatedData['technical_expert_id'])->get();
            if ($AllEquipment->isNotEmpty()) {
                return response()->json([
                    'msg' => 'Successfully',
                    'All Equipment Request your Send' => $AllEquipment
                ], 200, [], JSON_PRETTY_PRINT);
            } else return response()->json([
                'msg' => 'You have not Send any Request Equipment',
            ], 404, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }

    //---------------------------------------------------------------------------------------------------
    //Show Equipment Request Data----------------------------------------------------------------------
    public function ShowEquipmentRequestData(Request $request)
    {
        try {
            // قواعد التحقق من البيانات
            $validatedData = $request->validate([
                'request_equipment_id' => 'required|exists:request_equipment,request_equipment_id',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], $e->status, [], JSON_PRETTY_PRINT);
        }
        try {
            $RequestEquipmentData = RequestEquipment::with('Inverter', 'Battery', 'Panel')->find($request->input('request_equipment_id'));
            return response()->json([
                'msg' => 'Successfully find',
                'Request Equipment Data' => $RequestEquipmentData
            ], 200, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }

    //-----------------------------------------------------------------------------------
    //Edit Request Equipment Data Function-----------------------------------------------------------
    public function EditRequestEquipmentData(Request $request)
    {

        try {
            $validatedData = $request->validate([
                'request_equipment_id' => 'required|exists:request_equipment,request_equipment_id',
                'name' => 'sometimes|required|string|max:255',
                'number_of_broadcast_device' => 'sometimes|required|integer',
                'number_of_port' => 'sometimes|required|integer',
                'number_of_socket' => 'sometimes|required|integer',
                'panel_id' => 'sometimes|exists:panels,panel_id',
                'number_of_panel' => 'sometimes|integer',
                'battery_id' => 'sometimes|exists:batteries,battery_id',
                'number_of_battery' => 'sometimes|integer',
                'inverters_id' => 'sometimes|exists:inverters,inverters_id',
                'number_of_inverter' => 'sometimes|integer',
                'additional_equipment' => 'sometimes|required|string',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], $e->status, [], JSON_PRETTY_PRINT);
        }
        try {
            $RequestEquipment_old = RequestEquipment::find($request->input('request_equipment_id'));
            if ($RequestEquipment_old['status'] == 'approved' || 'rejected') {
                return response()->json(["msg" => "You can't edit this request After " . $RequestEquipment_old['status'] . ' this request'], 403, [], JSON_PRETTY_PRINT);
            }

            $dataupdate = $request->except('request_equipment_id');
            $RequestEquipment_old->update($dataupdate);

            //get Client new data ----------
            $RequestEquipment_new = RequestEquipment::with('Panel', 'Battery', 'Inverter')->find($request->input('request_equipment_id'));
            //--------------------------------------------------------

            return response()->json(
                [
                    'msg' => 'Successfully Edit',
                    'Request Equipment Data' => $RequestEquipment_new,
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
