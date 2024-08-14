<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AccessController;
use App\Http\Controllers\AdminAddController;
use App\Http\Controllers\DashBoard\AdmimTechnicalCRUDController;
use App\Http\Controllers\DashBoard\AdminEmployCRUDController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/



Route::controller(AccessController::class)->group(function () {
    Route::post('Phone/Login', 'Phone_Login');
    Route::post('Dash/Login', 'Dash_Login');
});

Route::middleware('auth:sanctum')->post('logout', [AccessController::class, 'Logout']);


Route::middleware('auth:sanctum', 'CheckUserRole:employe,super_admin')->controller(AdmimTechnicalCRUDController::class)->group(function () {
    Route::post('Dash/AddTechnicalExpert', 'AddTechnicalExpert');
    Route::post('Dash/ShowAllTechnicalExpert', 'ShowAllTechnicalExpert');
    Route::post('Dash/ShowTechnicalExpert', 'ShowTechnicalExpertData');
    Route::post('Dash/EditTechnicalExpert', 'EditTechnicalExpertData');
    Route::post('Dash/DeactivateTechnicalExpert', 'DeactivateTechnicalExpert');
    Route::post('Dash/ActivateTechnicalExpert', 'ActivateTechnicalExpert');
});

Route::middleware('auth:sanctum', 'CheckUserRole:super_admin')->controller(AdminEmployCRUDController::class)->group(function () {

    Route::post('Dash/AddAdmin', 'AddAdminAccount');
    Route::post('Dash/ShowAllAdmin', 'ShowAllAdmin');
    Route::post('Dash/ShowAdmin', 'ShowAdmin');
    Route::post('Dash/EditAdminData', 'EditAdminData');
    Route::post('Dash/DeactivateAdmin', 'DeactivateAdmin');
    Route::post('Dash/ActivateAdmin', 'ActivateAdmin');
});
