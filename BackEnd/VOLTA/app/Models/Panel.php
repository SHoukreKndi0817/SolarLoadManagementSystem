<?php

namespace App\Models;

use App\Models\SolarSystemInfo;
use App\Models\RequestEquipment;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;

class Panel extends Authenticatable
{
    use HasFactory, HasApiTokens;
    protected $primaryKey = 'panel_id';

    protected  $fillable = [
        'panel_id',
        'manufacturer',
        'model',
        'max_power_output_watt',
        'cell_type',
        'efficiency',
        'panel_type'
    ];

    public function RequestEquipment()
    {
        return $this->hasMany(RequestEquipment::class, 'panel_id');
    }
    public function SolarSystemInfo()
    {
        return $this->hasMany(SolarSystemInfo::class, 'panel_id');
    }
}
