<?php

namespace App\Models;

use App\Models\Client;
use App\Models\HomeDevice;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;

class Log extends Authenticatable
{
    use HasFactory, HasApiTokens;

    protected $primaryKey = 'log_id';
    protected $filabel = [
        'log_id',
        'client_id',
        'home_device_id',
        'log_type',
        'log_description',
        'start_time',
        'end_time',
    ];

    public function Client()
    {
        return $this->belongsTo(Client::class, 'client_id');
    }
    public function HomeDevice()
    {
        return $this->belongsTo(HomeDevice::class, 'home_device_id');
    }
}
