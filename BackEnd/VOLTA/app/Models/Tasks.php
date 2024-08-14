<?php

namespace App\Models;

use App\Models\Client;
use App\Models\HomeDevice;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;

class Tasks extends Authenticatable
{
    use HasFactory, HasApiTokens;

    protected $primaryKey = 'task_id';

    protected $fillable = [
        'task_id',
        'client_id',
        'home_device_id',
        'task_type',
        'start_time',
        'end_time',
        'status',

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
