<?php

namespace App\Http\Controllers\Application\TechnicalExpert;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Models\TechnicalExpert;
use Illuminate\Validation\ValidationException;

class ProfileController extends Controller
{
    public function ShowTechnicalExpertData(Request $request)
    {
        try {
            // قواعد التحقق من البيانات
            $validatedData = $request->validate([

                'technical_expert_id' => 'required|exists:technical_experts,technical_expert_id'
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], $e->status, [], JSON_PRETTY_PRINT);
        }
        try {
            $TechnicalExpert = TechnicalExpert::findOrFail($request->input('technical_expert_id'));
            return response()->json([
                'msg' => 'Successfully find',
                'Technical Expert data' => $TechnicalExpert
            ], 200, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }

     //-----------------------------------------------------------------------
    //update Technical Expert data
    public function EditTechnicalExpertData(Request $request)
    {

        try {
            $validatedData = $request->validate([
                'technical_expert_id' => 'required|exists:technical_experts,technical_expert_id',
                'name' => 'sometimes|required|string|max:255',
                'phone_number' => ['sometimes', 'required', 'string', 'min:10', 'max:16', 'regex:/^0\d{8,14}$/'],
                'home_address' => 'sometimes|required|string|max:255',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], $e->status, [], JSON_PRETTY_PRINT);
        }
        try {
            $technical_expert_old = TechnicalExpert::findOrFail($request->input('technical_expert_id'));
            $dataupdate = $request->except('technical_expert_id');
            $technical_expert_old->update($dataupdate);
            $technical_expert_new = TechnicalExpert::findOrFail($request->input('technical_expert_id'));
            return response()->json(
                [
                    'msg' => 'Successfully Edit',
                    'Technical Expert Data' => $technical_expert_new
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
