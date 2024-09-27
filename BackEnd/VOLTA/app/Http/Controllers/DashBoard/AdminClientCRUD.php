<?php

namespace App\Http\Controllers\DashBoard;

use App\Models\Client;
use Illuminate\Http\Request;
use App\Models\SolarSystemInfo;
use App\Models\TechnicalExpert;
use App\Http\Controllers\Controller;
use Illuminate\Validation\ValidationException;

class AdminClientCRUD extends Controller
{


    //Show all client data in DB---------------------------------------------
    public function ShowAllClient()
    {
        try {
            $Client  = Client::with('TechnicalExpert')->get();
            if ($Client->isNotEmpty()) {
                return response()->json([
                    'msg' => 'Successfully ',
                    'All Client' => $Client
                ], 200, [], JSON_PRETTY_PRINT);
            } else return response()->json([
                'msg' => 'Not Found Client  ',
            ], 404, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }

    //Show Client Data----------------------------------------------------------------------
    public function ShowClient(Request $request)
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
            $Client = Client::with('TechnicalExpert')->findOrFail($request->input('client_id'));
            return response()->json([
                'msg' => 'Successfully find',
                'Client data' => $Client
            ], 200, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }


    //Edit Client Data Function----------------------------------------------
    public function EditClientData(Request $request)
    {

        try {
            $validatedData = $request->validate([
                'client_id' => ['required', 'exists:clients,client_id'],
                'name' => 'sometimes|required|string|max:255',
                'phone_number' => ['sometimes', 'required', 'string', 'min:10', 'max:16', 'regex:/^0\d{8,14}$/'],
                'home_address' => 'sometimes|required|string|max:255',
                'user_name' => 'sometimes|required|string|max:255',
                'technical_user_name' => 'required|exists:technical_experts,user_name',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], $e->status, [], JSON_PRETTY_PRINT);
        }
        try {
            $Client_old = Client::findOrFail($request->input('client_id'));


            //get technical expert data-----------------------
            $technicalUserId = TechnicalExpert::where('user_name', $request->input('technical_user_name'))->value('technical_expert_id');
            //-----------------------------------------------------

            $dataupdate = $request->except('client_id', 'technical_user_name');

            //add technical_expert_id-------------
            $dataupdate['technical_expert_id'] = $technicalUserId;
            //------------------------------------

            $Client_old->update($dataupdate);

            //get Client new data with Technical expert data----------
            $Client_new = Client::with("TechnicalExpert")->findOrFail($request->input('client_id'));
            //--------------------------------------------------------

            return response()->json(
                [
                    'msg' => 'Successfully Edit',
                    'Client Data' => $Client_new,
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
    public function DeactivateClient(Request $request)
    {
        try {
            $validatedData = $request->validate([
                'client_id' => 'required|exists:clients,client_id',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], 422, [], JSON_PRETTY_PRINT);
        }

        try {
            $Client = Client::findOrFail($request->input('client_id'));

            if ($Client->is_active) {
                $Client->update(['is_active' => false]);
                $Client->tokens()->delete();
                return response()->json([
                    'msg' => 'Client account has been deactivated successfully',
                ], 200, [], JSON_PRETTY_PRINT);
            } else return response()->json([
                'msg' => 'Client account is already deactivated',
            ], 409, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => 'Failed to deactivate account'], 500, [], JSON_PRETTY_PRINT);
        }
    }

    //----------------------------------------------------------------------
    public function ActivateClient(Request $request)
    {
        try {
            $validatedData = $request->validate([
                'client_id' => 'required|exists:clients,client_id',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], 422, [], JSON_PRETTY_PRINT);
        }

        try {
            $Client = Client::findOrFail($request->input('client_id'));

            if (!$Client->is_active) {
                $Client->update(['is_active' => true]);
                return response()->json([
                    'msg' => 'Client account has been Activated successfully',
                ], 200, [], JSON_PRETTY_PRINT);
            } else return response()->json([
                'msg' => 'Client account is already Activated',
            ], 409, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => 'Failed to deactivate account'], 500, [], JSON_PRETTY_PRINT);
        }
    }


    //---------------------------------------------------------------------------------------
    //-------Show All Solar System You Associated With it------------------------------

    public function ShowAllSolarSystemYouAssociated(Request $request)
    {
        try {
            $validatedData = $request->validate([
                'client_id' => 'required|exists:clients,client_id',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], 422, [], JSON_PRETTY_PRINT);
        }

        try {
            $AllSolarSYstemYouHad = SolarSystemInfo::with('Inverter', 'Battery', 'Panel')->where('client_id', $validatedData['client_id'])
                ->get();
            if ($AllSolarSYstemYouHad->isNotEmpty()) {
                return response()->json(
                    [
                        'msg' => 'Succesfly',
                        'All Solar System You Have' => $AllSolarSYstemYouHad,

                    ],
                    200,
                    [],
                    JSON_PRETTY_PRINT
                );
            } else return response()->json(['msg' => 'Not Found Any Solar System You Associated With Him '], 404, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }
}
