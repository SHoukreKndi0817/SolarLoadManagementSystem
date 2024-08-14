<?php

namespace App\Http\Controllers\Application\TechnicalExpert;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Models\Client;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;

class CreateClient extends Controller
{
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
            //--------------------------------
            $Client = Client::create($ClientData);
            return response()->json([
                "msg" => "Client created successfully",
                "Client Data" => $Client
            ], 201, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }
}
