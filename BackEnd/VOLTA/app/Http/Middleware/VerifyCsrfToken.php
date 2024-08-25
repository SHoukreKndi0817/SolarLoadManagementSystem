<?php

namespace App\Http\Middleware;

use Illuminate\Foundation\Http\Middleware\VerifyCsrfToken as Middleware;

class VerifyCsrfToken extends Middleware
{
    /**
     * The URIs that should be excluded from CSRF verification.
     *
     * @var array<int, string>
     */
    protected $except = [
        'api/Dash/Login',
        'api/logout',
        'api/Dash/AddAdmin',
        'api/Dash/ShowAllAdmin',
        'api/Dash/ShowAdmin',
        'api/Dash/EditAdminData',
        'api/Dash/DeactivateAdmin',
        'api/Dash/ActivateAdmin',
        'api/Dash/AddTechnicalExpert',
        'api/Dash/ShowAllTechnicalExpert',
        'api/Dash/ShowTechnicalExpert',
        'api/Dash/EditTechnicalExpert',
        'api/Dash/DeactivateTechnicalExpert',
        'api/Dash/ActivateTechnicalExpert',
        'api/Dash/ShowAllClient',
        'api/Dash/ShowClient',
        'api/Dash/EditClientData',
        'api/Dash/DeactivateClient',
        'api/Dash/AddPanel',
        'api/Dash/ShowAllPanel',
        'api/Dash/ShowPanel',
        'api/Dash/EditPanelData',
        'api/Dash/AddBattery',
        'api/Dash/ShowAllBattery',
        'api/Dash/ShowBattery',
        'api/Dash/EditBatteryData',
        'api/Dash/AddInverter',
        'api/Dash/ShowAllInverter',
        'api/Dash/ShowInverter',
        'api/Dash/EditInverterData',
        'api/Dash/ShowAllRequestEquipment',
        'api/Dash/ShowRequestEquipment',
        'api/Dash/approved',
        'api/Dash/rejected',
        'api/Dash/AddBroadcastDeviceData',
        'api/Dash/ShowAllDeviceBroadcast',
        'api/Dash/ShowDeviceBroadcast',
        'api/Dash/EditBroadcastDeviceData',
        'api/Dash/ChangeBroadcastDeviceStatus',
        'api/Dash/ChangeSocketStatus',
        'api/Dash/DeleteBroadcastDevice',
        'api/Dash/GenerateQRCodeData',


    ];
}
