<?php

namespace App\Models;


use App\Models\BroadcastDevice;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;

class BroadcastData extends Authenticatable
{
    use HasFactory, HasApiTokens;

    protected $primaryKey = 'broadcast_data_id';
    protected $filabel = [
        'broadcast_data_id',
        'inverter_output_voltage',
        'inverter_input_voltage',
        'battery_voltage',
        'solar_power_generation',
        'power_consumption',
        'load_percentage',
        'output_frequency(hz)',
        'battery_charging_power(w)',
        'battery_percentage',
        'battery_discharge_power',
        'electric',
        'status',
        'error_code',
        'broadcast_device_id'
    ];

    public function BroadcastDevice()
    {
        return $this->belongsTo(BroadcastDevice::class, 'broadcast_device_id');
    }
}
