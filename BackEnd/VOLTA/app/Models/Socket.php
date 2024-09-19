<?php

namespace App\Models;

use App\Models\BroadcastDevice;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;

class Socket extends Authenticatable
{
    use HasFactory, HasApiTokens;

    protected $primaryKey = 'socket_id';
    protected $fillable  = [
        'socket_id',
        'broadcast_device_id',
        'socket_model',
        'socket_version',
        'serial_number',
        'socket_name',
        'socket_connection_type',
        'status',
    ];

    public function BroadcastDevice()
    {
        return $this->belongsTo(BroadcastDevice::class, 'broadcast_device_id');
    }

    public function HomeDevice()
    {
        return $this->hasOne(HomeDevice::class, 'socket_id');
    }
}
