<?php

namespace App\Http\Controllers\DashBoard;

use Illuminate\Http\Request;
use App\Models\TechnicalExpert;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class AdmimTechnicalCRUDController extends Controller
{

    //------------------------------------------------------------
    //Create a Technical Expert New Record in DB
    public function addTechnicalExpert(Request $request)
    {

        try {
            // قواعد التحقق من البيانات
            $validatedData = $request->validate([
                'name' => 'required|string|max:255',
                'phone_number' => ['required', 'string', 'min:10', 'max:16', 'regex:/^0\d{8,14}$/'],
                'home_address' => 'required|string|max:255',
                'user_name' => 'required|string|max:255|unique:technical_experts',
                'password' => 'required|string|min:6',
                'admin_id' => 'required|exists:admins,admin_id',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], $e->status, [], JSON_PRETTY_PRINT);
        }
        // تجهيز البيانات
        $technicalExpertData = $request->all();
        // تشفير كلمة المرور
        $technicalExpertData['password'] = Hash::make($technicalExpertData['password']);
        // إنشاء الخبير التقني
        $technicalExpert = TechnicalExpert::create($technicalExpertData);
        return response()->json([
            "msg" => "Technical Expert created successfully",
            "Technical Expert Data" => $technicalExpert
        ], 201, [], JSON_PRETTY_PRINT);
    }


    //------------------------------------------------------------
    //Show All Technical we have in DB 
    public function ShowAllTechnicalExpert()
    {
        try {
            $AllTechnicalExpert = TechnicalExpert::get();
            if ($AllTechnicalExpert->isNotEmpty()) {
                return response()->json([
                    'msg' => 'Successfully ',
                    'All Technical Expert' => $AllTechnicalExpert
                ], 200, [], JSON_PRETTY_PRINT);
            } else return response()->json([
                'msg' => 'Not Found Technical Expert  ',
            ], 404, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }

    //------------------------------------------------------------
    //Show Technical Expert Date from DB 
    //i respone the id and i search for this id in DB and return it 
    public function ShowTechnicalExpertData(Request $request)
    {
        try {
            // قواعد التحقق من البيانات
            $validatedData = $request->validate([

                'technical_expert_id' => 'required|exists:technical_experts,technical_expert_id',
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
    //------------------------------------------------------------
    //update Technical Expert data
    //with password and username or not 
    public function EditTechnicalExpertData(Request $request)
    {

        try {
            $validatedData = $request->validate([
                'name' => 'required|string|max:255',
                'phone_number' => ['required', 'string', 'min:10', 'max:16', 'regex:/^0\d{8,14}$/'],
                'home_address' => 'required|string|max:255',
                'admin_id' => 'required|exists:admins,admin_id',
                'technical_expert_id' => 'required|exists:technical_experts,technical_expert_id',
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


    //---------------------------------------------------------------
    public function DeactivateTechnicalExpert(Request $request)
    {
        try {
            $validatedData = $request->validate([
                'technical_expert_id' => 'required|exists:technical_experts,technical_expert_id',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], 422, [], JSON_PRETTY_PRINT);
        }

        try {
            $technicalExpert = TechnicalExpert::findOrFail($request->input('technical_expert_id'));

            if ($technicalExpert->is_active) {
                $technicalExpert->update(['is_active' => false]);
                $technicalExpert->tokens()->delete();
                return response()->json([
                    'msg' => 'Technical Expert account has been deactivated successfully',
                ], 200, [], JSON_PRETTY_PRINT);
            } else return response()->json([
                'msg' => 'Technical Expert account is already deactivated',
            ], 409, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => 'Failed to deactivate account'], 500, [], JSON_PRETTY_PRINT);
        }
    }

    //----------------------------------------------------------------------
    public function ActivateTechnicalExpert(Request $request)
    {
        try {
            $validatedData = $request->validate([
                'technical_expert_id' => 'required|exists:technical_experts,technical_expert_id',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], 422, [], JSON_PRETTY_PRINT);
        }

        try {
            $technicalExpert = TechnicalExpert::findOrFail($request->input('technical_expert_id'));

            if (!$technicalExpert->is_active) {
                $technicalExpert->update(['is_active' => true]);
                return response()->json([
                    'msg' => 'Technical Expert account has been Activated successfully',
                ], 200, [], JSON_PRETTY_PRINT);
            } else return response()->json([
                'msg' => 'Technical Expert account is already Activated',
            ], 409, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => 'Failed to deactivate account'], 500, [], JSON_PRETTY_PRINT);
        }
    }
}
