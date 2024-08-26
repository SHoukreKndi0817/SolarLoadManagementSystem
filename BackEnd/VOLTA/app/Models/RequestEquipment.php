<?php

namespace App\Models;

use App\Models\Panel;
use App\Models\Battery;
use App\Models\Inverter;
use App\Models\TechnicalExpert;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;

class RequestEquipment extends Authenticatable
{
    use HasApiTokens, HasFactory;

    protected $primaryKey = 'request_equipment_id';

    protected $fillable = [
        'request_equipment_id',
        'name',
        'technical_expert_id',
        'number_of_broadcast_device',
        'number_of_port',
        'number_of_socket',
        'panel_id',
        'number_of_panel',
        'battery_id',
        'number_of_battery',
        'inverters_id',
        'number_of_inverter',
        'additional_equipment',
        'status',
        'commet',
    ];

    public function TechnicalExpert()
    {
        return $this->belongsTo(TechnicalExpert::class, 'technical_expert_id');
    }
    public function Panel()
    {
        return $this->belongsTo(Panel::class, 'panel_id');
    }
    public function Battery()
    {
        return $this->belongsTo(Battery::class, 'battery_id');
    }
    public function Inverter()
    {
        return $this->belongsTo(Inverter::class, 'inverters_id');
    }
}
