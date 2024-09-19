<?php

namespace App\Events;

use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class ClientNotiEvent implements ShouldBroadcast
{
    use Dispatchable, InteractsWithSockets, SerializesModels;
    public $data;
    public $clientId;
    /**
     * Create a new event instance.
     */
    public function __construct($data, $clientId = null)
    {
        $this->data = $data;
        $this->clientId = $clientId;
    }

    /**
     * Get the channels the event should broadcast on.
     *
     * @return array<int, \Illuminate\Broadcasting\Channel>
     */
    public function broadcastOn(): array
    {
        return [new PrivateChannel('private-client.' . $this->clientId)];
    }


    // تحديد البيانات التي يتم إرسالها عبر القناة
    public function broadcastWith()
    {
        return ['data' => $this->data];
    }
}
