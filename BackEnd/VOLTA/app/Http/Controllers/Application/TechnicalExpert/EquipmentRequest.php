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
                'number_of_broadcast_device' => 'required|integer',
                'number_of_port' => 'required|integer',
                'number_of_socket' => 'required|integer',
                'panel_id' => 'exists:panels,panel_id',
                'number_of_panel' => 'integer',
                'battery_id' => 'exists:batteries,battery_id',
                'number_of_battery' => 'integer',
                'inverters_id' => 'exists:inverters,inverters_id',
                'additional_equipment' => 'required|string',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], $e->status, [], JSON_PRETTY_PRINT);
        }
        try {
            $EquipmentData = $request->all();
            $EquipmentData['status'] = 'pending'; //approved ,rejected 
            $Equipment = RequestEquipment::create($EquipmentData);
            return response()->json([
                "msg" => "Equipment created successfully",
                "Equipment Data" => $Equipment
            ], 201, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }


    
}
