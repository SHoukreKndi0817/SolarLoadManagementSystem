<?php

namespace App\Http\Controllers\Application\Client;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Models\Client;
use Illuminate\Validation\ValidationException;

class ProfileController extends Controller
{
    public function ShowClientData(Request $request)
    {
        try {
            // قواعد التحقق من البيانات
            $validatedData = $request->validate([

                'client_id' => 'required|exists:clients,client_id'
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], $e->status, [], JSON_PRETTY_PRINT);
        }
        try {
            $Client = Client::find($request->input('client_id'));
            return response()->json([
                'msg' => 'Successfully find',
                'Client data' => $Client
            ], 200, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }
   
    //-----------------------------------------------------------------------
    //update Client data
    public function ClientDataUpdate(Request $request)
    {

        try {
            $validatedData = $request->validate([
                'client_id' => 'required|exists:clients,client_id',
                'name' => 'sometimes|required|string|max:255',
                'phone_number' => [
                    'sometimes',
                    'required',
                    'string',
                    'min:10',
                    'max:16',
                    'regex:/^0\d{8,14}$/',
                    'unique:clients,phone_number,' . $request->client_id . ',client_id'
                ],
                'home_address' => 'sometimes|required|string|max:255',
                'user_name' => [
                    'sometimes',
                    'required',
                    'string',
                    'max:255',
                    'unique:clients,user_name,' . $request->client_id . ',client_id'
                ],
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], $e->status, [], JSON_PRETTY_PRINT);
        }
        try {
            $client_old = Client::find($request->input('client_id'));
            $dataupdate = $request->except('client_id');
            $client_old->update($dataupdate);
            $client_new = Client::find($request->input('client_id'));
            return response()->json(
                [
                    'msg' => 'Successfully Edit',
                    'Client Data' => $client_new
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
