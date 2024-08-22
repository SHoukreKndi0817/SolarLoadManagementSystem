<?php

namespace App\Models;

use App\Models\Panel;
use App\Models\Client;
use App\Models\Battery;
use App\Models\Inverter;
use App\Models\BroadcastDevice;
use App\Models\TechnicalExpert;
use App\Models\SystemEfficiency;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;

class SolarSystemInfo extends Authenticatable
{
    use HasFactory, HasApiTokens;
    protected $primaryKey = 'solar_sys_info_id';
    protected $fillable = [
        'solar_sys_info_id',
        'name',
        'client_id',
        'technical_expert_id',
        'inverters_id',
        'battery_id',
        'number_of_broadcast_device',
        'number_of_battery',
        'battery_conection_type',
        'panel_id',
        'number_of_panel',
        'number_of_panel_group',
        'panel_conection_typeone',
        'panel_conection_typetwo',
        'phase_type',
        'broadcast_device_id'
    ];


    public function Client()
    {
        return $this->belongsTo(Client::class, 'client_id');
    }
    public function TechnicalExpert()
    {
        return $this->belongsTo(TechnicalExpert::class, 'technical_expert_id');
    }
    public function Inverter()
    {
        return $this->belongsTo(Inverter::class, 'inverters_id');
    }
    public function Battery()
    {
        return $this->belongsTo(Battery::class, 'battery_id');
    }
    public function Panel()
    {
        return $this->belongsTo(Panel::class, 'panel_id');
    }
    public function BroadcastDevice()
    {
        return $this->belongsTo(BroadcastDevice::class, 'broadcast_device_id');
    }
    public function SystemEfficiency()
    {
        return $this->hasOne(SystemEfficiency::class, 'solar_sys_info_id');
    }
}
