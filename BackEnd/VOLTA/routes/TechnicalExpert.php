<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\DashBoard\AdminEquipmentData;
use App\Http\Controllers\Application\TechnicalExpert\CreateClient;
use App\Http\Controllers\Application\TechnicalExpert\EquipmentRequest;
use App\Http\Controllers\Application\TechnicalExpert\ProfileController;
use App\Http\Controllers\Application\TechnicalExpert\SolarSysytemInfoController;

/*
|--------------------------------------------------------------------------
| TechnicalExpert Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/


//-------------------------------Client maneger in Technical Expert phone-------------------------------

Route::middleware('auth:sanctum', 'CheckUserRole:technical_expert')
      ->controller(CreateClient::class)->group(function () {
            Route::post('Phone/AddClientAccount', 'AddClientAccount');
            Route::post('Phone/ShowAllClientYouAdd', 'ShowAllClientYouAdd');
            Route::post('Phone/ShowClientData', 'ShowClientData');
            Route::post('Phone/EditClient', 'EditClient');
            Route::post('Phone/changeClientExpert', 'changeClientExpert');
      });

//--------------------------------------------------
//--------------------Solar System Maneger For Client use technical --------------------------
Route::middleware('auth:sanctum', 'CheckUserRole:technical_expert')
      ->controller(SolarSysytemInfoController::class)->group(function () {
            Route::post('Phone/AddSolarSystemInfo', 'AddSolarSystemInfo');
            Route::post('Phone/UpdateSolarSystemInfo', 'UpdateSolarSystemInfo');
            Route::post('Phone/SolarSystemAssociatedWithClient', 'SolarSystemAssociatedWithClient');
      });

//--------------------------------------------------
//-------------------- Technical Expert Profile --------------------------
Route::middleware('auth:sanctum', 'CheckUserRole:technical_expert')
      ->controller(ProfileController::class)->group(function () {
            Route::post('Phone/ShowTechnicalExpertData', 'ShowTechnicalExpertData');
            Route::post('Phone/EditTechnicalExpertData', 'EditTechnicalExpertData');
      });

//--------------------------------------------------------
//------------------------------------Equipment CRUD -----------------------------------------------------------

Route::middleware('auth:sanctum', 'CheckUserRole:technical_expert')
      ->controller(EquipmentRequest::class)->group(function () {
            Route::post('Phone/SendEquipmentRequest', 'SendEquipmentRequest');
            Route::post('Phone/ShowAllEquipmentRequest', 'ShowAllEquipmentRequest');
            Route::post('Phone/ShowEquipmentRequestData', 'ShowEquipmentRequestData');
            Route::post('Phone/EditRequestEquipmentData', 'EditRequestEquipmentData');
      });

//-----------------------------------------------------------------------------------------------
//------------------Api get data for Equipment Form-------------------------------------
Route::middleware('auth:sanctum', 'CheckUserRole:technical_expert')
      ->controller(AdminEquipmentData::class)->group(function () {
            Route::post('Phone/ShowAllInverter', 'ShowAllInverter');
            Route::post('Phone/ShowAllBattery', 'ShowAllBattery');
            Route::post('Phone/ShowAllPanel', 'ShowAllPanel');
      });
