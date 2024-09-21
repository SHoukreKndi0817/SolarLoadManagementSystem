<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\SLMT\BroadcastSLMTController;
use App\Http\Controllers\SLMT\ShowBroadcastDataController;
use App\Http\Controllers\SLMT\SendActionToSocketController;
use App\Http\Controllers\Application\Client\ProfileController;
use App\Http\Controllers\Application\Client\RateTechnicalExpert;
use App\Http\Controllers\Application\Client\AddHomeDeviceController;
use App\Http\Controllers\Application\Client\TaskSchedulerController;
use App\Http\Controllers\Application\Client\YouSolarSystemInfoController;
/*
|--------------------------------------------------------------------------
| Client Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/
//---------------------------------------------------------------------
//-----------------The Profile Route -------------------------------

Route::middleware('auth:sanctum', 'CheckUserRole:client')
      ->controller(ProfileController::class)->group(function () {
            Route::post('Phone/ShowClientData', 'ShowClientData');
            Route::post('Phone/ClientDataUpdate', 'ClientDataUpdate');
      });

//----------------------------------------------------------------------------------
//----------------Solar System Infor You Associated With ----------------------------------------
Route::middleware('auth:sanctum', 'CheckUserRole:client')
      ->controller(YouSolarSystemInfoController::class)->group(function () {
            Route::post('Phone/ShowAllSolarSystemAssociated', 'ShowAllSolarSystemAssociated');
            Route::post('Phone/ShowSolarSystemInfo', 'ShowSolarSystemInfo');
      });

//----------------------------------------------------------------------------------
//----------------Rate The Technical Expert ----------------------------------------
Route::middleware('auth:sanctum', 'CheckUserRole:client')
      ->controller(RateTechnicalExpert::class)->group(function () {
            Route::post('Phone/ShowTechnicalExpertRating', 'ShowTechnicalExpertRating');
            Route::post('Phone/RateTechnicalExpert', 'RateTechnicalExpert');
            Route::post('Phone/UpdateTechnicalExpertRating', 'UpdateTechnicalExpertRating');
      });

//-------------------------------------------------------------------------------------
//-------------------------Home Device --------------------------------------------------
Route::middleware('auth:sanctum', 'CheckUserRole:client')
      ->controller(AddHomeDeviceController::class)->group(function () {
            Route::post('Phone/AllSocket', 'AllSocket');
            Route::post('Phone/AddHomeDeviceData', 'AddHomeDeviceData');
            Route::post('Phone/GetHomeDevicesAddedByClient', 'GetHomeDevicesAddedByClient');
            Route::post('Phone/ShowHomeDeviceInfo', 'ShowHomeDeviceInfo');
            Route::post('Phone/ChangeSocketName', 'ChangeSocketName');
      });

//-----------------------------------------------------------------------------------------
//-----------------------CreateTask------------------
Route::middleware('auth:sanctum', 'CheckUserRole:client')
      ->controller(TaskSchedulerController::class)->group(function () {
            Route::post('Phone/CreateTask', 'CreateTask');
            Route::post('Phone/ShowAllTasks', 'ShowAllTasks');
            Route::post('Phone/EditTasks', 'EditTasks');
            Route::post('Phone/DeletTask', 'DeletTask');
      });


//--------------------------------------------------------------------------------
//--------------------SLMT Data----------------------------------------------------------------------------------------
//----Send Action to SLMT ------------------------------------
Route::middleware('auth:sanctum', 'CheckUserRole:client')
      ->controller(SendActionToSocketController::class)->group(function () {
            Route::post('SLMT/CheckPowerToSendAction', 'CheckPowerToSendAction');
      });

//-----------------------------------------------------------------------
//----Online Data From SLMT--------------------------------
Route::controller(BroadcastSLMTController::class)->group(function () {
      Route::post('SLMT/addBroadcastData', 'addBroadcastData');
});
//------------------------------------------------------------------------
//----Show SLMT Data Online ------------------------------------
Route::middleware('auth:sanctum', 'CheckUserRole:client')
      ->controller(ShowBroadcastDataController::class)->group(function () {
            Route::post('SLMT/getBroadcastDataForClient', 'getBroadcastDataForClient');
      });
