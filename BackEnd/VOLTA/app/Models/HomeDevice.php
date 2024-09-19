<?php

namespace App\Models;

use App\Models\Log;
use App\Models\Tasks;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;

class HomeDevice extends Authenticatable
{
    use HasFactory, HasApiTokens;

    protected $primaryKey = 'home_device_id';
    protected $fillable = [
        'home_device_id',
        'socket_id',
        'device_name',
        'device_type',
        'device_operation_type',
        'operation_max_watt',
        'priority',
    ];
    public function Socket()
    {
        return $this->belongsTo(Socket::class, 'socket_id');
    }
    public function Tasks()
    {
        return $this->hasMany(Tasks::class, 'home_device_id');
    }
    public function Log()
    {
        return $this->hasMany(Log::class, 'home_device_id');
    }
}
