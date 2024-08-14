<?php

namespace App\Http\Controllers\DashBoard;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Models\Admin;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class AdminEmployCRUDController extends Controller
{
    public function AddAdminAccount(Request $request)
    {

        try {
            // قواعد التحقق من البيانات
            $validatedData = $request->validate([
                'name' => 'required|string|max:255',
                'phone_number' => ['required', 'string', 'min:10', 'max:16', 'regex:/^0\d{8,14}$/', 'unique:admins'],
                'user_name' => 'required|string|max:255|unique:admins',
                'password' => 'required|string|min:6',
                'role' => 'required|in:super_admin,employe',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], $e->status, [], JSON_PRETTY_PRINT);
        }
        try {
            $AdminData = $request->all();
            $AdminData['password'] = Hash::make($AdminData['password']);
            $Admin = Admin::create($AdminData);
            return response()->json([
                "msg" => "Admin created successfully",
                "Admin Data" => $Admin
            ], 201, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }


    public function ShowAllAdmin()
    {
        try {
            $Admin  = Admin::get();
            if ($Admin->isNotEmpty()) {
                return response()->json([
                    'msg' => 'Successfully ',
                    'All Admin' => $Admin
                ], 200, [], JSON_PRETTY_PRINT);
            } else return response()->json([
                'msg' => 'Not Found Admin  ',
            ], 404, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }
    //-----------------------------------------------------------
    public function ShowAdmin(Request $request)
    {
        try {
            // قواعد التحقق من البيانات
            $validatedData = $request->validate([

                'admin_id' => 'required|exists:admins,admin_id',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], $e->status, [], JSON_PRETTY_PRINT);
        }
        try {
            $Admin = Admin::findOrFail($request->input('admin_id'));
            return response()->json([
                'msg' => 'Successfully find',
                'Admin data' => $Admin
            ], 200, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }

    //--------------------------------------------------------
    public function EditAdminData(Request $request)
    {

        try {
            $validatedData = $request->validate([
                'name' => 'required|string|max:255',
                'phone_number' => ['required', 'string', 'min:10', 'max:16', 'regex:/^0\d{8,14}$/'],
                'role' => 'required|in:super_admin,employe',
                'admin_id' => 'required|exists:admins,admin_id'
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], $e->status, [], JSON_PRETTY_PRINT);
        }
        try {
            $Admin_old = Admin::findOrFail($request->input('admin_id'));
            $dataupdate = $request->except('admin_id');
            $Admin_old->update($dataupdate);
            $Admin_new = Admin::findOrFail($request->input('admin_id'));
            return response()->json(
                [
                    'msg' => 'Successfully Edit',
                    'Admin Data' => $Admin_new
                ],
                200,
                [],
                JSON_PRETTY_PRINT
            );
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }


    //-----------------------------------------------------
    public function DeactivateAdmin(Request $request)
    {
        try {
            $validatedData = $request->validate([
                'admin_id' => 'required|exists:admins,admin_id'
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], 422, [], JSON_PRETTY_PRINT);
        }

        try {
            $Admin = Admin::findOrFail($request->input('admin_id'));

            if ($Admin->is_active) {
                $Admin->update(['is_active' => false]);
                $Admin->tokens()->delete();
                return response()->json([
                    'msg' => 'Admin account has been deactivated successfully',
                ], 200, [], JSON_PRETTY_PRINT);
            } else return response()->json([
                'msg' => 'Admin account is already deactivated',
            ], 409, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => 'Failed to deactivate account'], 500, [], JSON_PRETTY_PRINT);
        }
    }


    //----------------------------------------------------------------------
    public function ActivateAdmin(Request $request)
    {
        try {
            $validatedData = $request->validate([
                'admin_id' => 'required|exists:admins,admin_id'
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], 422, [], JSON_PRETTY_PRINT);
        }

        try {
            $Admin = Admin::findOrFail($request->input('admin_id'));

            if (!$Admin->is_active) {
                $Admin->update(['is_active' => true]);
                return response()->json([
                    'msg' => 'Admin account has been Activated successfully',
                ], 200, [], JSON_PRETTY_PRINT);
            } else return response()->json([
                'msg' => 'Admin account is already Activated',
            ], 409, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => 'Failed to deactivate account'], 500, [], JSON_PRETTY_PRINT);
        }
    }
}
