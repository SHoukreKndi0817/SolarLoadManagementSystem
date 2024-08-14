<?php

namespace App\Models;

use App\Models\TechnicalExpert;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;

class Admin extends Authenticatable
{
    use HasApiTokens, HasFactory;

    protected $primaryKey = 'admin_id';

    protected $fillable = [
        'admin_id',
        'name',
        'phone_number',
        'user_name',
        'password',
        'role',
        'is_active'
    ];

    protected $hidden = ['password'];

    public function TechnicalExpert()
    {
        return $this->hasMany(TechnicalExpert::class, 'admin_id');
    }
}
