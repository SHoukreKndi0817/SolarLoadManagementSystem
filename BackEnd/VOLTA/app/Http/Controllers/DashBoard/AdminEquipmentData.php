<?php

namespace App\Http\Controllers\DashBoard;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Models\Battery;
use App\Models\Inverter;
use App\Models\Panel;
use App\Models\RequestEquipment;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class AdminEquipmentData extends Controller
{
    //---------------------------------------------Panel Function Section----------------------------------------------------------------------------------------------------------------------

    //------------------------------------------------------------
    //Create a Panel New Record in DB
    public function AddPanel(Request $request)
    {

        try {
            // قواعد التحقق من البيانات
            $validatedData = $request->validate([
                'manufacturer' => 'required|string|max:255',
                'model' => 'required|string|max:255',
                'max_power_output_watt' => 'required|string|max:255',
                'cell_type' => 'required|string|max:255',
                'efficiency' => 'required|string|max:255',
                'panel_type' => 'required|string|max:255',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], $e->status, [], JSON_PRETTY_PRINT);
        }
        try {
            // التحقق من وجود سجل مماثل
            $duplicatePanel = Panel::where('manufacturer', $request->manufacturer)
                ->where('model', $request->model)
                ->where('max_power_output_watt', $request->max_power_output_watt)
                ->where('cell_type', $request->cell_type)
                ->where('efficiency', $request->efficiency)
                ->where('panel_type', $request->panel_type)
                ->first();

            if ($duplicatePanel) {
                return response()->json(
                    ["msg" => "Duplicate entry: Panel already exists with the same details"],
                    409,
                    [],
                    JSON_PRETTY_PRINT
                );
            }

            $panelData = $request->all();
            $panel = Panel::create($panelData);
            return response()->json([
                "msg" => "Panel created successfully",
                "Panel Data" => $panel
            ], 201, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }

    //----------------------------------------------------------------------------------
    //Show All panel is DB-------------------------------------------
    public function ShowAllPanel()
    {
        try {
            $Panel = Panel::get();
            if ($Panel->isNotEmpty()) {
                return response()->json([
                    'msg' => 'Successfully ',
                    'All Panel' => $Panel
                ], 200, [], JSON_PRETTY_PRINT);
            } else return response()->json([
                'msg' => 'Not Found Panel  ',
            ], 404, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }
    //-------------------------------------------------------------------------------------------------
    //Show Panel --------------------------------------------
    public function ShowPanel(Request $request)
    {
        try {
            // قواعد التحقق من البيانات
            $validatedData = $request->validate([

                'panel_id' => 'required|exists:panels,panel_id',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], $e->status, [], JSON_PRETTY_PRINT);
        }
        try {
            $panel = Panel::findOrFail($request->input('panel_id'));
            return response()->json([
                'msg' => 'Successfully find',
                'Panel data' => $panel
            ], 200, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }
    //---------------------------------------------------------------
    //Edit Panel Data ------------------------------------------------
    public function EditPanelData(Request $request)
    {

        try {
            $validatedData = $request->validate([
                'panel_id' => 'required|exists:panels,panel_id',
                'manufacturer' => 'sometimes|required|string|max:255',
                'model' => 'sometimes|required|string|max:255',
                'max_power_output_watt' => 'sometimes|required|string|max:255',
                'cell_type' => 'sometimes|required|string|max:255',
                'efficiency' => 'sometimes|required|string|max:255',
                'panel_type' => 'sometimes|required|string|max:255',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], $e->status, [], JSON_PRETTY_PRINT);
        }
        try {
            $panel_old = Panel::findOrFail($request->input('panel_id'));
            $dataupdate = $request->except('panel_id');
            $panel_old->update($dataupdate);
            $panel_new = Panel::findOrFail($request->input('panel_id'));
            return response()->json(
                [
                    'msg' => 'Successfully Edit',
                    'panel Data' => $panel_new,
                ],
                200,
                [],
                JSON_PRETTY_PRINT
            );
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }




    //---------------------------------------------Battery Function Section----------------------------------------------------------------------------------------------------------------------


    //Create a Panel New Record in DB--------------------------------------
    public function AddBattery(Request $request)
    {
        try {
            // قواعد التحقق من البيانات
            $validatedData = $request->validate([
                'battery_type' => 'required|string|max:255',
                'absorb_stage_volts' => 'required|string|max:255',
                'float_stage_volts' => 'required|string|max:255',
                'equalize_stage_volts' => 'required|string|max:255',
                'equalize_interval_days' => 'required|string|max:255',
                'seting_switches' => 'required|string|max:255',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], $e->status, [], JSON_PRETTY_PRINT);
        }
        try {
            // التحقق من وجود سجل مماثل
            $duplicateBattery = Battery::where('battery_type', $request->battery_type)
                ->where('absorb_stage_volts', $request->absorb_stage_volts)
                ->where('float_stage_volts', $request->float_stage_volts)
                ->where('equalize_stage_volts', $request->equalize_stage_volts)
                ->where('equalize_interval_days', $request->equalize_interval_days)
                ->where('seting_switches', $request->seting_switches)
                ->first();

            if ($duplicateBattery) {
                return response()->json(
                    ["msg" => "Duplicate entry: Battery already exists with the same details"],
                    409,
                    [],
                    JSON_PRETTY_PRINT
                );
            }

            $BatteryData = $request->all();
            $Battery = Battery::create($BatteryData);
            return response()->json([
                "msg" => "Panel created successfully",
                "Battery Data" => $Battery
            ], 201, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }

    //-----------------------------------------------------------------------------------------------
    //----Show All Battery in DB---------------------------------------------------------------------
    public function ShowAllBattery()
    {
        try {
            $Battery = Battery::get();
            if ($Battery->isNotEmpty()) {
                return response()->json([
                    'msg' => 'Successfully ',
                    'All Battery' => $Battery
                ], 200, [], JSON_PRETTY_PRINT);
            } else return response()->json([
                'msg' => 'Not Found Battery  ',
            ], 404, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }

    //-----------------------------------------------------------------------------
    //Show Battery --------------------------------------------
    public function ShowBattery(Request $request)
    {
        try {
            // قواعد التحقق من البيانات
            $validatedData = $request->validate([

                'battery_id' => 'required|exists:batteries,battery_id',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], $e->status, [], JSON_PRETTY_PRINT);
        }
        try {
            $Battery = Battery::findOrFail($request->input('battery_id'));
            return response()->json([
                'msg' => 'Successfully find',
                'Battery data' => $Battery
            ], 200, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }

    //--------------------------------------------------------------------------------
    //Edit Battery Data ------------------------------------------------
    public function EditBatteryData(Request $request)
    {

        try {
            $validatedData = $request->validate([
                'battery_id' => 'required|exists:batteries,battery_id',
                'battery_type' => 'sometimes|required|string|max:255',
                'absorb_stage_volts' => 'sometimes|required|string|max:255',
                'float_stage_volts' => 'sometimes|required|string|max:255',
                'equalize_stage_volts' => 'sometimes|required|string|max:255',
                'equalize_interval_days' => 'sometimes|required|string|max:255',
                'seting_switches' => 'sometimes|required|string|max:255',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], $e->status, [], JSON_PRETTY_PRINT);
        }
        try {
            $battery_old = Battery::findOrFail($request->input('battery_id'));
            $dataupdate = $request->except('battery_id');
            $battery_old->update($dataupdate);
            $battery_new = Battery::findOrFail($request->input('battery_id'));
            return response()->json(
                [
                    'msg' => 'Successfully Edit',
                    'Battery Data' => $battery_new,
                ],
                200,
                [],
                JSON_PRETTY_PRINT
            );
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }

    //---------------------------------------------Inverter Function Section----------------------------------------------------------------------------------------------------------------------

    //Create a Inverter New Record in DB--------------------------------------
    public function AddInverter(Request $request)
    {
        try {
            // قواعد التحقق من البيانات
            $validatedData = $request->validate([
                'model_name' => 'required|string|max:255',
                'operating_temperature' => 'required|string|max:255',
                'invert_mode_rated_power' => 'required|string|max:255',
                'invert_mode_dc_input' => 'required|string|max:255',
                'invert_mode_ac_output' => 'required|string|max:255',
                'ac_charger_mode_ac_input' => 'required|string|max:255',
                'ac_charger_mode_ac_output' => 'required|string|max:255',
                'ac_charger_mode_dc_output' => 'required|string|max:255',
                'ac_charger_mode_max_charger' => 'required|string|max:255',
                'solar_charger_mode_rated_power' => 'required|string|max:255',
                'solar_charger_mode_system_voltage' => 'required|string|max:255',
                'solar_charger_mode_mppt_voltage_range' => 'required|string|max:255',
                'solar_charger_mode_max_solar_voltage' => 'required|string|max:255',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], $e->status, [], JSON_PRETTY_PRINT);
        }
        try {
            // التحقق من وجود سجل مماثل
            $duplicateBattery = Inverter::where('model_name', $request->model_name)
                ->where('operating_temperature', $request->operating_temperature)
                ->where('invert_mode_rated_power', $request->invert_mode_rated_power)
                ->where('invert_mode_dc_input', $request->invert_mode_dc_input)
                ->where('invert_mode_ac_output', $request->invert_mode_ac_output)
                ->where('ac_charger_mode_ac_input', $request->ac_charger_mode_ac_input)
                ->where('ac_charger_mode_ac_output', $request->ac_charger_mode_ac_output)
                ->where('ac_charger_mode_dc_output', $request->ac_charger_mode_dc_output)
                ->where('ac_charger_mode_max_charger', $request->ac_charger_mode_max_charger)
                ->where('solar_charger_mode_rated_power', $request->solar_charger_mode_rated_power)
                ->where('solar_charger_mode_system_voltage', $request->solar_charger_mode_system_voltage)
                ->where('solar_charger_mode_mppt_voltage_range', $request->solar_charger_mode_mppt_voltage_range)
                ->where('solar_charger_mode_max_solar_voltage', $request->solar_charger_mode_max_solar_voltage)
                ->first();

            if ($duplicateBattery) {
                return response()->json(
                    ["msg" => "Duplicate entry: Inverter already exists with the same details"],
                    409,
                    [],
                    JSON_PRETTY_PRINT
                );
            }

            $InverterData = $request->all();
            $Inverter = Inverter::create($InverterData);
            return response()->json([
                "msg" => "Panel created successfully",
                "Inverter Data" => $Inverter
            ], 201, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }

    //-----------------------------------------------------------------------------------------------
    //----Show All Inverter in DB---------------------------------------------------------------------
    public function ShowAllInverter()
    {
        try {
            $Inverter = Inverter::get();
            if ($Inverter->isNotEmpty()) {
                return response()->json([
                    'msg' => 'Successfully ',
                    'All Inverter' => $Inverter
                ], 200, [], JSON_PRETTY_PRINT);
            } else return response()->json([
                'msg' => 'Not Found Inverter  ',
            ], 404, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }

    //-----------------------------------------------------------------------------
    //Show Inverter --------------------------------------------
    public function ShowInverter(Request $request)
    {
        try {
            // قواعد التحقق من البيانات
            $validatedData = $request->validate([

                'inverters_id' => 'required|exists:inverters,inverters_id',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], $e->status, [], JSON_PRETTY_PRINT);
        }
        try {
            $Inverter = Inverter::findOrFail($request->input('inverters_id'));
            return response()->json([
                'msg' => 'Successfully find',
                'Inverter data' => $Inverter
            ], 200, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }

    //--------------------------------------------------------------------------------
    //Edit Inverter Data ------------------------------------------------
    public function EditInverterData(Request $request)
    {

        try {
            $validatedData = $request->validate([
                'inverters_id' => 'required|exists:inverters,inverters_id',
                'model_name' => 'sometimes|required|string|max:255',
                'operating_temperature' => 'sometimes|required|string|max:255',
                'invert_mode_rated_power' => 'sometimes|required|string|max:255',
                'invert_mode_dc_input' => 'sometimes|required|string|max:255',
                'invert_mode_ac_output' => 'sometimes|required|string|max:255',
                'ac_charger_mode_ac_input' => 'sometimes|required|string|max:255',
                'ac_charger_mode_ac_output' => 'sometimes|required|string|max:255',
                'ac_charger_mode_dc_output' => 'sometimes|required|string|max:255',
                'ac_charger_mode_max_charger' => 'sometimes|required|string|max:255',
                'solar_charger_mode_rated_power' => 'sometimes|required|string|max:255',
                'solar_charger_mode_system_voltage' => 'sometimes|required|string|max:255',
                'solar_charger_mode_mppt_voltage_range' => 'sometimes|required|string|max:255',
                'solar_charger_mode_max_solar_voltage' => 'sometimes|required|string|max:255',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], $e->status, [], JSON_PRETTY_PRINT);
        }
        try {
            $Inverter_old = Inverter::findOrFail($request->input('inverters_id'));
            $dataupdate = $request->except('inverters_id');
            $Inverter_old->update($dataupdate);
            $Inverter_new = Inverter::findOrFail($request->input('inverters_id'));
            return response()->json(
                [
                    'msg' => 'Successfully Edit',
                    'Inverter Data' => $Inverter_new,
                ],
                200,
                [],
                JSON_PRETTY_PRINT
            );
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }
    //---------------------------------------------Request Equipment  Function Section----------------------------------------------------------------------------------------------------------------------

    //----------------------------------------
    //Show All request sended from Technical expert--------------------
    public function ShowAllRequestEquipment()
    {
        try {
            $AllRequest = RequestEquipment::with('TechnicalExpert')->get();
            if ($AllRequest->isNotEmpty()) {
                return response()->json([
                    'msg' => 'Successfully ',
                    'All Equipment Request' => $AllRequest
                ], 200, [], JSON_PRETTY_PRINT);
            } else return response()->json([
                'msg' => 'Not Found Equipment Request  ',
            ], 404, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }

    //--------------------------------------------------------------------
    //Show data for Equipment Request--------------------------------- 
    public function ShowRequestEquipment(Request $request)
    {
        try {

            $validatedData = $request->validate([

                'request_equipment_id' => 'required|exists:request_equipment,request_equipment_id',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], $e->status, [], JSON_PRETTY_PRINT);
        }
        try {
            $RequestEquipment = RequestEquipment::with('TechnicalExpert', 'Panel', 'Battery', 'Inverter')->findOrFail($request->input('request_equipment_id'));
            return response()->json([
                'msg' => 'Successfully find',
                'Equipment Request data' => $RequestEquipment
            ], 200, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }

    //----------------------------------------------------------------------------
    //approved the Equipment Request---------------------------------------------
    public function approved(Request $request)
    {
        try {

            $validatedData = $request->validate([

                'request_equipment_id' => 'required|exists:request_equipment,request_equipment_id',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], $e->status, [], JSON_PRETTY_PRINT);
        }
        try {
            $RequestEquipment = RequestEquipment::findOrFail($request->input('request_equipment_id'));
            //--------------
            if ($RequestEquipment->status === 'approved') {
                return response()->json([
                    'msg' => 'This request has already been approved.',
                ], 200, [], JSON_PRETTY_PRINT);
            }
            //---------------
            $RequestEquipment['status'] = 'approved';
            $RequestEquipment->save();
            return response()->json([
                'msg' => 'Successfully status update',

            ], 200, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }


    //----------------------------------------------------------------------------
    //rejected the Equipment Request---------------------------------------------
    public function rejected(Request $request)
    {
        try {

            $validatedData = $request->validate([

                'request_equipment_id' => 'required|exists:request_equipment,request_equipment_id',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], $e->status, [], JSON_PRETTY_PRINT);
        }
        try {
            $RequestEquipment = RequestEquipment::findOrFail($request->input('request_equipment_id'));
            //--------------
            if ($RequestEquipment->status === 'rejected') {
                return response()->json([
                    'msg' => 'This request has already been rejected.',
                ], 200, [], JSON_PRETTY_PRINT);
            }
            //---------------
            $RequestEquipment['status'] = 'rejected';
            $RequestEquipment->save();
            return response()->json([
                'msg' => 'Successfully status update',

            ], 200, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }
}
