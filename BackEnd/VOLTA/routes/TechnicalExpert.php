<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Application\TechnicalExpert\CreateClient;
use App\Http\Controllers\Application\TechnicalExpert\EquipmentRequest;


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
            Route::post('Phone/SolarSystemAssociatedWithClient', 'SolarSystemAssociatedWithClient');
            Route::post('Phone/AddSolarSystemInfo', 'AddSolarSystemInfo');
      });

//--------------------------------------------------------
//------------------------------------Equipment CRUD -----------------------------------------------------------

Route::middleware('auth:sanctum', 'CheckUserRole:technical_expert')
      ->controller(EquipmentRequest::class)->group(function () {
            Route::post('Phone/SendEquipmentRequest', 'SendEquipmentRequest');
      });
