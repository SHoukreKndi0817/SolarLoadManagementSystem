<?php

namespace App\Http\Controllers\Application\Client;

use App\Models\Tasks;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Models\HomeDevice;
use App\Models\Socket;
use Exception;
use Illuminate\Validation\ValidationException;

class TaskSchedulerController extends Controller
{
    //-----------------------------------------------------------------------------------------------------------------------------------
    //CreateTask ----------------------------------------------------------------------------
    public function CreateTask(Request $request)
    {
        try {

            $validatedData = $request->validate([
                'client_id' => 'required|exists:clients,client_id',
                'home_device_id' => 'required|exists:home_devices,home_device_id',
                'task_type' => 'required|in:on,off',
                'start_time' => 'required|date_format:H:i',
                'end_time' => 'required|date_format:H:i',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], $e->status, [], JSON_PRETTY_PRINT);
        }

        try {
            $validatedData['status'] = 'in progress';
            $Task = Tasks::create($validatedData);
            $Device = HomeDevice::where('home_device_id', $validatedData['home_device_id'])->first();
            $Socket = Socket::where('socket_id', $Device['socket_id'])->first();
            return response()->json([
                'msg' => 'Task created successfully',
                "Task Data" => $Task,
                "Device name" => $Device->device_name,
                "Socket name" => $Socket->socket_name,
            ], 201, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }

    //-------------------------------------------------------------------------
    //EditTasks--------------------------------------------------------------
    public function EditTasks(Request $request)
    {
        try {

            $validatedData = $request->validate([
                'task_id' => 'required|exists:tasks,task_id',
                'task_type' => 'sometimes|required|in:on,off',
                'start_time' => 'sometimes|required|date_format:H:i',
                'end_time' => 'sometimes|required|date_format:H:i',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], $e->status, [], JSON_PRETTY_PRINT);
        }


        try {
            $taskOldData = Tasks::where('task_id', $validatedData['task_id'])->first();
            $taskOldData->update();
            return response()->json([
                "msg" => "Task updated successfully",
            ], 200, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }

    //----------------------------------------------------------------------
    //Show All Tasks -------------------------------------------------------
    public function ShowAllTasks(Request $request)
    {
        try {
            $AllTasks = Tasks::with('HomeDevice')->get();
            return response()->json([
                "msg" => "successfully",
                "All Tasks Data" => $AllTasks,
            ], 200, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }
    //----------------------------------------------------------------------------
    //Delet Tasks ----------------------------------------------------------------
    public function DeletTask(Request $request)
    {
        try {

            $validatedData = $request->validate([
                'task_id' => 'required|exists:tasks,task_id',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], $e->status, [], JSON_PRETTY_PRINT);
        }
        try {
            $DeletTask = Tasks::where('task_id', $validatedData['task_id'])->first();
            $DeletTask->delete();
            return response()->json([
                "msg" => "successfully",
            ], 200, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }
}
