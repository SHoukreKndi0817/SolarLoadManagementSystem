<?php

use App\Http\Controllers\Application\Client\ProfileController;
use App\Http\Controllers\Application\Client\RateTechnicalExpert;
use Illuminate\Support\Facades\Route;
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
//----------------Rate The Technical Expert ----------------------------------------
Route::middleware('auth:sanctum', 'CheckUserRole:client')
      ->controller(RateTechnicalExpert::class)->group(function () {

            Route::post('Phone/RateTechnicalExpert', 'RateTechnicalExpert');
      });
