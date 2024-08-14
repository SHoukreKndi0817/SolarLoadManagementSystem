<?php

namespace App\Models;

use App\Models\Client;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;

class Rating extends Authenticatable
{
    use HasFactory, HasApiTokens;

    protected $primaryKey = 'rating_id';

    protected $fillable = [
        'rating_id',
        'client_id',
        'technical_expert_id',
        'rate',
        'commet',
    ];

    public function Client()
    {
        return $this->belongsTo(Client::class, 'client_id');
    }
    public function TechnicalExpert()
    {
        return $this->belongsTo(TechnicalExpert::class, 'technical_expert_id');
    }
}
