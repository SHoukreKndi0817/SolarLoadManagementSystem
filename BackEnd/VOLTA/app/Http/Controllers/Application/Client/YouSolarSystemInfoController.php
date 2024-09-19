<?php

namespace App\Http\Controllers\Application\Client;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Models\SolarSystemInfo;
use Illuminate\Validation\ValidationException;

class YouSolarSystemInfoController extends Controller
{
    //---------------------------------------------------------------------------
    //-------Show All SolarS ystem Associated ------------------------------------
    public function ShowAllSolarSystemAssociated(Request $request)
    {
        try {
            $validatedData = $request->validate([
                'client_id' => 'required|exists:clients,client_id',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], 422, [], JSON_PRETTY_PRINT);
        }

        try {
            $AllSolarSYstemYouHad = SolarSystemInfo::where('client_id', $validatedData['client_id'])
                ->select('solar_sys_info_id', 'name')
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

    //-----------------------------------------------------------------------------------------------------------
    //-----------------------------Show Solar System Info ---------------------------------
    public function ShowSolarSystemInfo(Request $request)
    {
        try {
            $validatedData = $request->validate([
                'solar_sys_info_id' => 'required|exists:solar_system_infos,solar_sys_info_id',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], 422, [], JSON_PRETTY_PRINT);
        }

        try {
            $SolarSystemInfo = SolarSystemInfo::with('TechnicalExpert', 'Inverter', 'Battery', 'Panel')->where('solar_sys_info_id', $validatedData['solar_sys_info_id'])->first();
            return response()->json(
                [
                    'msg' => 'Succesfly',
                    'Solar System Information' => $SolarSystemInfo,

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
