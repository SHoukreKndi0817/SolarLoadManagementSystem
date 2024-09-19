<?php

namespace App\Events;

use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class NewNotificationEvent implements ShouldBroadcast
{
    use Dispatchable, InteractsWithSockets, SerializesModels;
    public $data;
    public $adminId;
    public $expertId;
    public $clientId;
    /**
     * Create a new event instance.
     */
    public function __construct($data, $adminId = null, $expertId = null, $clientId = null)
    {
        $this->data = $data; 
        $this->adminId = $adminId;
        $this->expertId = $expertId;
        $this->clientId = $clientId;
    }

    /**
     * Get the channels the event should broadcast on.
     *
     * @return array<int, \Illuminate\Broadcasting\Channel>
     */
    public function broadcastOn(): array
    {
        if ($this->adminId) {
            return [new PrivateChannel('private-admin.' . $this->adminId)];
        }

        if ($this->expertId) {
            return [new PrivateChannel('private-expert.' . $this->expertId)];
        }

        if ($this->clientId) {
            return [new PrivateChannel('private-client.' . $this->clientId)];
        }

        return [];
    }
    public function broadcastWith()
    {
        // تحديد البيانات التي يتم إرسالها عبر القناة
        return ['data' => $this->data];
    }
}
