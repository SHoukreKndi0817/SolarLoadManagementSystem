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
            $ClientData['telegram_chat'] = "0";
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

    //---------------------------------------------------------------------------------------------------------------------------
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


    //---------------------------------------------------------------------------------------------------
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

    //Edit Client Data Function----------------------------------------------
    public function EditClient(Request $request)
    {

        try {
            $validatedData = $request->validate([
                'client_id' => ['required', 'exists:clients,client_id'],
                'name' => 'sometimes|required|string|max:255',
                'phone_number' => ['sometimes', 'required', 'string', 'min:10', 'max:16', 'regex:/^0\d{8,14}$/'],
                'home_address' => 'sometimes|required|string|max:255',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], $e->status, [], JSON_PRETTY_PRINT);
        }
        try {
            $Client_old = Client::findOrFail($request->input('client_id'));


            $dataupdate = $request->except('client_id');
            $Client_old->update($dataupdate);

            //get Client new data ----------
            $Client_new = Client::findOrFail($request->input('client_id'));
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

    //-------------------------------------------------------------------------
    //Change Client technical expert-------------------
    public function changeClientExpert(Request $request)
    {

        try {
            $validatedData = $request->validate([
                'connection_code' => 'required|string|exists:clients,connection_code',
                'technical_expert_id' => 'required|exists:technical_experts,technical_expert_id'
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], 422, [], JSON_PRETTY_PRINT);
        }


        try {
            // البحث عن العميل بواسطة connection_code
            $client = Client::where('connection_code', $validatedData['connection_code'])->first();



            // التحقق مما إذا كان العميل مرتبطًا بالفعل بالخبير الفني الجديد
            if ($client->technical_expert_id == $validatedData['technical_expert_id']) {
                return response()->json([
                    "msg" => "Client is already associated with this technical expert.",
                ], 400, [], JSON_PRETTY_PRINT);
            }


            //update the technical in client record---------
            $client->technical_expert_id = $validatedData['technical_expert_id'];
            $client->save();
            //--------------------------------------------
            // البحث عن جميع المنظومات الشمسية المرتبطة بهذا العميل
            $solarSystems = SolarSystemInfo::where('client_id', $client->client_id)->get();

            if ($solarSystems->isEmpty()) {
                // في حالة عدم وجود أي منظومات شمسية لهذا العميل
                return response()->json([
                    "msg" => "Technical expert updated successfully for client. No solar systems found for this client.",
                    "Client" => $client
                ], 200, [], JSON_PRETTY_PRINT);
            }

            // تحديث technical_expert_id في جميع منظومات الطاقة الشمسية التابعة لهذا العميل
            foreach ($solarSystems as $solarSystem) {
                $solarSystem->technical_expert_id = $validatedData['technical_expert_id'];
                $solarSystem->save();
            }
            $solarSystems_new = SolarSystemInfo::where('client_id', $client->client_id)->get();
            return response()->json([
                "msg" => "Technical expert updated successfully for client and associated solar systems",
                "Client" => $client,
                "Solar Systems Updated" => $solarSystems_new
            ], 200, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }
}
