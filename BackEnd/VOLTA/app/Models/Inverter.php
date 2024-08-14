<?php

namespace App\Models;

use App\Models\SolarSystemInfo;
use App\Models\RequestEquipment;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;

class Inverter extends Authenticatable
{
    use HasFactory, HasApiTokens;
    protected $primaryKey = 'inverters_id';

    protected $fillable = [
        'inverters_id',
        'model_name',
        'operating_temperature',
        'inver_mode_rated_power',
        'inver_mode_dc_input',
        'inver_mode_ac_output',
        'ac_charger_mode_ac_input',
        'ac_charger_mode_ac_output',
        'ac_charger_mode_dc_output',
        'ac_charger_mode_max_amber_charger',
        'solar_charger_mode_rated_power',
        'solar_charger_mode_system_voltage',
        'solar_charger_mode_mppt_voltage_range',
        'solar_charger_mode_max_solar_voltage'
    ];

    public function RequestEquipment()
    {
        return $this->hasMany(RequestEquipment::class, 'inverters_id');
    }
    public function SolarSystemInfo()
    {
        return $this->hasMany(SolarSystemInfo::class, 'inverters_id');
    }
}
