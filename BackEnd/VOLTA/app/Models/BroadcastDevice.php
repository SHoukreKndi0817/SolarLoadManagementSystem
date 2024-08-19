<?php

namespace App\Models;

use App\Models\Socket;
use App\Models\BroadcastData;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;

class BroadcastDevice extends Authenticatable
{
    use HasFactory, HasApiTokens;

    protected $primaryKey = 'broadcast_device_id';
    protected $fillable  = [
        'broadcast_device_id',
        'model',
        'version',
        'number_of_wired_port',
        'number_of_wireless_port',
        'mac_address',
        'status',
    ];
    public function SolarSystemInfo()
    {
        return $this->hasOne(SolarSystemInfo::class, 'broadcast_device_id');
    }
    public function BroadcastData()
    {
        return $this->hasOne(BroadcastData::class, 'broadcast_device_id');
    }
    public function Socket()
    {
        return $this->hasMany(Socket::class, 'broadcast_device_id');
    }
}
