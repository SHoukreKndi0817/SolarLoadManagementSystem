<?php

namespace App\Http\Controllers;

use App\Models\Admin;
use App\Models\Client;
use Illuminate\Http\Request;
use App\Models\TechnicalExpert;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Facades\Auth;

class AccessController extends Controller
{
    //Flutter login request .
    public function Phone_Login(Request $request)
    {
        try {
            $validatedData = $request->validate([
                'user_name' => ['required', 'string', 'max:255'],
                'password' => ['required', 'min:6'],
                'type' => ['required', 'in:client,technicalexpert'],
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], $e->status, [], JSON_PRETTY_PRINT);
        }
        try {
            $credentials = $request->only('user_name', 'password');
            $type = $request->input('type');
            $guard = $type;
            $model = $type === 'client' ? Client::class : TechnicalExpert::class;

            if (!Auth::guard($guard)->attempt($credentials)) {
                return response()->json(["msg" => "Login failed: Invalid credentials"], 401, [], JSON_PRETTY_PRINT);
            }

            $user = $model::where("user_name", $request->user_name)->first();
            // التحقق من حالة الحساب
            if (!$user->is_active) {
                return response()->json(["msg" => "Your account has been deactivated by the company"], 403, [], JSON_PRETTY_PRINT);
            }

            $user = $model::where("user_name", $request->user_name)->first();
            $token = $user->createToken($guard . " " . "access token", [$guard])->plainTextToken;
            $user->token = $token;

            return response()->json(["msg" => "Login successfully", $guard . ' ' . 'date' => $user], 200, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }


    //Dashboard login request
    public function Dash_Login(Request $request)
    {

        try {
            $validatedData = $request->validate([
                'user_name' => ['required', 'string', 'max:255'],
                'password' => ['required', 'min:6'],
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], $e->status, [], JSON_PRETTY_PRINT);
        }
        try {
            $credentials = $request->only('user_name', 'password');
            if (Auth::guard('admin')->attempt($credentials)) {
                $user = Admin::where("user_name", $request->user_name)->first();
                if (!$user->is_active) {
                    return response()->json(["msg" => "Your account has been deactivated by the company"], 403, [], JSON_PRETTY_PRINT);
                }
                $type = $user->role;
                $token = $user->createToken($type . " " . " access token", [$type])->plainTextToken;
                $user->token = $token;
                return response()->json(["msg" => "Login successfully", $type . ' ' . 'date' => $user], 200, [], JSON_PRETTY_PRINT);
            }

            return response()->json(["msg" => "Login failed: Invalid credentials"], 401, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }



    //logout for Phone and Dashboard
    public function logout(Request $request)
    {
        try {
            if ($request->user()->currentAccessToken()->delete()) {

                return response()->json(["msg" => "success logout"], 200, [], JSON_PRETTY_PRINT);
            }
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }
}
