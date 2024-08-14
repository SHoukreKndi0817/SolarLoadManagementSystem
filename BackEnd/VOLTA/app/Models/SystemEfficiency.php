<?php

namespace App\Models;

use App\Models\SolarSystemInfo;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;

class SystemEfficiency extends Authenticatable
{
    use HasFactory, HasApiTokens;

    protected $primaryKey = 'system_efficiency_id';

    protected $fillable = [
        'system_efficiency_id',
        'solar_sys_info_id',
        'power_generation',
        'power_consumption',
        'efficiency',
        'date',
    ];

    public function SolarSystemInfo()
    {
        return $this->belongsTo(SolarSystemInfo::class, 'solar_sys_info_id');
    }
}
