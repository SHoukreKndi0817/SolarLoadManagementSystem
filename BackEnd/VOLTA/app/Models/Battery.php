<?php

namespace App\Models;

use App\Models\SolarSystemInfo;
use App\Models\RequestEquipment;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;

class Battery extends Authenticatable
{
    use HasFactory, HasApiTokens;

    protected $primaryKey = 'battery_id';
    protected $fillable = [
        'battery_id',
        'battery_type',
        'absorb_stage_volts',
        'float_stage_volts',
        'equalize_stage_volts',
        'equalize_interval_days',
        'seting_switches',
    ];
    public function RequestEquipment()
    {
        return $this->hasMany(RequestEquipment::class, 'battery_id');
    }
    public function SolarSystemInfo()
    {
        return $this->hasMany(SolarSystemInfo::class, 'battery_id');
    }
}
