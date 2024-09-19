<?php

namespace App\Events;

use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class TechnicaExpertNotiEvent implements ShouldBroadcast
{
    use Dispatchable, InteractsWithSockets, SerializesModels;
    public $data;
    public $technicalexpertId;
    /**
     * Create a new event instance.
     */
    public function __construct($data, $technicalexpertId = null)
    {
        $this->data = $data;
        $this->technicalexpertId = $technicalexpertId;
    }

    /**
     * Get the channels the event should broadcast on.
     *
     * @return array<int, \Illuminate\Broadcasting\Channel>
     */
    public function broadcastOn(): array
    {
        return [new PrivateChannel('private-expert.' . $this->technicalexpertId)];
    }

    // تحديد البيانات التي يتم إرسالها عبر القناة
    public function broadcastWith()
    {
        return ['data' => $this->data];
    }
}
