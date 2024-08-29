<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AccessController;
use App\Http\Controllers\DashBoard\AdminClientCRUD;
use App\Http\Controllers\DashBoard\ProfileController;
use App\Http\Controllers\DashBoard\AdminEquipmentData;
use App\Http\Controllers\DashBoard\AdminEmployCRUDController;
use App\Http\Controllers\DashBoard\BroadcastDeviceController;
use App\Http\Controllers\DashBoard\AdmimTechnicalCRUDController;

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


//-----------------------------------Auth Route---------------------------------------------
Route::controller(AccessController::class)->group(function () {
    Route::post('Phone/Login', 'Phone_Login');
    Route::post('Dash/Login', 'Dash_Login');
});

Route::middleware('auth:sanctum')->post('logout', [AccessController::class, 'Logout']);
//--------------------------------------------------------------------------------------------

//--------------------------------Admin CRUD in Dashboard------------------------------------------
Route::middleware('auth:sanctum', 'CheckUserRole:super_admin')->controller(AdminEmployCRUDController::class)->group(function () {

    Route::post('Dash/AddAdmin', 'AddAdminAccount');
    Route::post('Dash/ShowAllAdmin', 'ShowAllAdmin');
    Route::post('Dash/ShowAdmin', 'ShowAdmin');
    Route::post('Dash/EditAdminData', 'EditAdminData');
    Route::post('Dash/DeactivateAdmin', 'DeactivateAdmin');
    Route::post('Dash/ActivateAdmin', 'ActivateAdmin');
});
//------------------------------------------------------------------------------------------------

//----------------------------Technical CRUD in Dashboard-----------------------------------------
Route::middleware('auth:sanctum', 'CheckUserRole:employe,super_admin')->controller(AdmimTechnicalCRUDController::class)->group(function () {
    Route::post('Dash/AddTechnicalExpert', 'AddTechnicalExpert');
    Route::post('Dash/ShowAllTechnicalExpert', 'ShowAllTechnicalExpert');
    Route::post('Dash/ShowTechnicalExpert', 'ShowTechnicalExpertData');
    Route::post('Dash/EditTechnicalExpert', 'EditTechnicalExpertData');
    Route::post('Dash/DeactivateTechnicalExpert', 'DeactivateTechnicalExpert');
    Route::post('Dash/ActivateTechnicalExpert', 'ActivateTechnicalExpert');
});
//---------------------------------------------------------------------------------------------



//---------------------------------Client maneger in Admin DashBoard-------------------------------
Route::middleware('auth:sanctum', 'CheckUserRole:employe,super_admin')->controller(AdminClientCRUD::class)->group(function () {

    Route::post('Dash/ShowAllClient', 'ShowAllClient');
    Route::post('Dash/ShowClient', 'ShowClient');
    Route::post('Dash/EditClientData', 'EditClientData');
    Route::post('Dash/DeactivateClient', 'DeactivateClient');
    Route::post('Dash/ActivateClient', 'ActivateClient');
});

//---------------------------Add Equipment data-----------------------
//Add Panel ---Add Inverter ---Add Battary------------------
Route::middleware('auth:sanctum', 'CheckUserRole:employe,super_admin')->controller(AdminEquipmentData::class)->group(function () {
    //Panel route section-----------------------------------
    Route::post('Dash/AddPanel', 'AddPanel');
    Route::post('Dash/ShowAllPanel', 'ShowAllPanel');
    Route::post('Dash/ShowPanel', 'ShowPanel');
    Route::post('Dash/EditPanelData', 'EditPanelData');
    //Battery route section----------------------------------
    Route::post('Dash/AddBattery', 'AddBattery');
    Route::post('Dash/ShowAllBattery', 'ShowAllBattery');
    Route::post('Dash/ShowBattery', 'ShowBattery');
    Route::post('Dash/EditBatteryData', 'EditBatteryData');
    //AddInverter route section----------------------------------
    Route::post('Dash/AddInverter', 'AddInverter');
    Route::post('Dash/ShowAllInverter', 'ShowAllInverter');
    Route::post('Dash/ShowInverter', 'ShowInverter');
    Route::post('Dash/EditInverterData', 'EditInverterData');
    //Send Request Equipment Route-----------------------------------
    Route::post('Dash/ShowAllRequestEquipment', 'ShowAllRequestEquipment');
    Route::post('Dash/ShowRequestEquipment', 'ShowRequestEquipment');
    Route::post('Dash/approved', 'approved');
    Route::post('Dash/rejected', 'rejected');
});
//--------------------------------------------------------------------------------------------------
//-------------------------------Broadcast Device CRUD and QRcode data------------------------------

Route::middleware('auth:sanctum', 'CheckUserRole:employe,super_admin')->controller(BroadcastDeviceController::class)->group(function () {
    Route::post('Dash/AddBroadcastDeviceData', 'AddBroadcastDeviceData');
    Route::post('Dash/ShowAllDeviceBroadcast', 'ShowAllDeviceBroadcast');
    Route::post('Dash/ShowDeviceBroadcast', 'ShowDeviceBroadcast');
    Route::post('Dash/EditBroadcastDeviceData', 'EditBroadcastDeviceData');
    Route::post('Dash/ChangeBroadcastDeviceStatus', 'ChangeBroadcastDeviceStatus');
    Route::post('Dash/ChangeSocketStatus', 'ChangeSocketStatus');
    Route::post('Dash/DeleteBroadcastDevice', 'DeleteBroadcastDevice');
    Route::post('Dash/GenerateQRCodeData', 'GenerateQRCodeData');
});


