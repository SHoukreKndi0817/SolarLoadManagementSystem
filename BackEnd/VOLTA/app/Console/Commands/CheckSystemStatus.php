<?php

namespace App\Console\Commands;

use App\Models\BroadcastData;
use App\Models\Inverter;
use App\Models\Socket;
use App\Events\ClientNotiEvent;
use App\Models\Battery;
use Illuminate\Console\Command;

class CheckSystemStatus extends Command
{
    // اسم الكوماند التي سيتم تشغيلها لتفعيل الجدولة
    protected $signature = 'system:check-status';

    // وصف الكوماند
    protected $description = 'Check the system status for any issues and send alerts if needed';

    public function handle()
    {
        while (true) {
            $broadcastDataList = BroadcastData::with('BroadcastDevice.SolarSystemInfo')->get();

            foreach ($broadcastDataList as $broadcastData) {
                $solarSystem = $broadcastData->BroadcastDevice->SolarSystemInfo;
                $clientId = $solarSystem->client_id;
                $inverter = Inverter::find($solarSystem->inverters_id);
                $Battery = Battery::find($solarSystem->battery_id);

                // 1. التحقق من البطارية
                if ($broadcastData->battery_voltage < 11.10) {
                    // تغيير حالة جميع المقابس إلى 0 باستثناء المقبس الذي يحمل اسم "إنذار"
                    $sockets = $broadcastData->BroadcastDevice->Socket;
                    foreach ($sockets as $socket) {
                        $socket->status = ($socket->socket_name === 'alarm') ? 1 : 0;
                        $socket->save();
                    }

                    // إرسال الإنذار
                    $this->sendAlert("Low battery level! Battery voltage: {$broadcastData->battery_voltage}V", $clientId);
                }

                // 2. التحقق من استهلاك الطاقة مقارنة بقدرة الانفرتر
                elseif ($broadcastData['power_consumption(w)'] > ($inverter->invert_mode_rated_power - 200)) {
                    // تغيير حالة جميع المقابس إلى 0 باستثناء المقبس الذي يحمل اسم "إنذار"
                    $sockets = $broadcastData->BroadcastDevice->Socket;
                    foreach ($sockets as $socket) {
                        $socket->status = ($socket->socket_name === 'alarm') ? 1 : 0;
                        $socket->save();
                    }

                    // إرسال الإنذار
                    $power_consumption = $broadcastData['power_consumption(w)'];
                    $Inverterpower = $inverter->invert_mode_rated_power - 200;
                    $this->sendAlert("Power consumption exceeded inverter limit! Consumption: {$power_consumption}W, Inverter limit: {$Inverterpower}W", $clientId);
                }

                // 3. التحقق من الشحن الزائد للبطارية
                elseif ($broadcastData->battery_voltage > $Battery->float_stage_volts) {
                    // تغيير حالة جميع المقابس إلى 0 باستثناء المقبس الذي يحمل اسم "إنذار"
                    $sockets = $broadcastData->BroadcastDevice->Socket;
                    foreach ($sockets as $socket) {
                        $socket->status = ($socket->socket_name === 'alarm') ? 1 : 0;
                        $socket->save();
                    }

                    // إرسال الإنذار
                    $this->sendAlert("Battery overcharge detected! Voltage: {$broadcastData->battery_voltage}V", $clientId);
                }

                // 4. التحقق من مستوى البطارية
                elseif ($broadcastData->battery_percentage < 22) {
                    // تغيير حالة جميع المقابس إلى 0 باستثناء المقبس الذي يحمل اسم "إنذار"
                    $sockets = $broadcastData->BroadcastDevice->Socket;
                    foreach ($sockets as $socket) {
                        $socket->status = ($socket->socket_name === 'alarm') ? 1 : 0;
                        $socket->save();
                    }

                    // إرسال الإنذار
                    $this->sendAlert("Low battery level! Battery at {$broadcastData->battery_percentage}%", $clientId);
                }
            }
            sleep(6);  // تأخير التنفيذ لعدد معين من الثواني
        }
    }

    // دالة لإرسال الإنذارات باستخدام Pusher
    public function sendAlert($message, $clientId)
    {
        // البيانات التي سيتم إرسالها إلى الحدث
        $data = [
            'message' => $message,
            'time' => now(),
        ];

        // إطلاق الحدث
        event(new ClientNotiEvent($data, $clientId));

        // طباعة الرسالة في السجل
        $this->info("Alert sent to client {$clientId}: {$message}");
    }
}
