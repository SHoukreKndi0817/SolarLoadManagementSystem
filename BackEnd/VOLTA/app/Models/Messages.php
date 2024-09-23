<?php

namespace App\Models;

use App\Models\Client;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Notifications\Notifiable;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;

class Messages extends Authenticatable
{
    use HasFactory, HasApiTokens, Notifiable;

    protected $primaryKey = 'message_id';

    protected $fillable = [
        'message_id',
        'message',
        'client_id'
    ];

    public function Client()
    {
        return $this->belongsTo(Client::class, 'client_id');
    }
}
