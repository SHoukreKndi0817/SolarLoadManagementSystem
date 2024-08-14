<?php

namespace App\Models;

use App\Models\Log;
use App\Models\Tasks;
use App\Models\Rating;
use App\Models\SolarSystemInfo;
use App\Models\TechnicalExpert;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;

class Client extends Authenticatable
{
    use HasFactory, HasApiTokens;

    protected $primaryKey = 'client_id';

    protected $fillable = [
        'client_id',
        'name',
        'phone_number',
        'home_address',
        'user_name',
        'password',
        'connection_code',
        'technical_expert_id',
        'role',
        'is_active'

    ];

    protected $hidden = ['password'];

    public function TechnicalExpert()
    {
        return $this->belongsTo(TechnicalExpert::class, 'technical_expert_id');
    }
    public function SolarSystemInfo()
    {
        return $this->hasMany(SolarSystemInfo::class, 'client_id');
    }
    public function Tasks()
    {
        return $this->hasMany(Tasks::class, 'client_id');
    }
    public function Log()
    {
        return $this->hasMany(Log::class, 'client_id');
    }
    public function Rating()
    {
        return $this->hasMany(Rating::class, 'client_id');
    }
}
