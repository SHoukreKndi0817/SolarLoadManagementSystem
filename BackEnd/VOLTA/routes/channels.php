<?php

use Illuminate\Support\Facades\Broadcast;

/*
|--------------------------------------------------------------------------
| Broadcast Channels
|--------------------------------------------------------------------------
|
| Here you may register all of the event broadcasting channels that your
| application supports. The given channel authorization callbacks are
| used to check if an authenticated user can listen to the channel.
|
*/

Broadcast::channel('App.Models.User.{id}', function ($user, $id) {
    return (int) $user->id === (int) $id;
});

Broadcast::channel('private-admin.{adminId}', function ($user, $adminId) {
    return (int) $user->id === (int) $adminId;
});

Broadcast::channel('private-expert.{expertId}', function ($user, $expertId) {
    return (int) $user->id === (int) $expertId;
});

Broadcast::channel('private-client.{clientId}', function ($user, $clientId) {
    return (int) $user->id === (int) $clientId;
});
