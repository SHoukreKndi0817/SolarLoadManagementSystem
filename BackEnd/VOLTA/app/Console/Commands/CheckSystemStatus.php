<?php


namespace App\Console\Commands;

use App\Models\BroadcastData;
use App\Models\Inverter;
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
                if ($broadcastData->battery_voltage < 11.00) {
                    $this->sendAlert("low battery level!  Battery voltage: {$broadcastData->battery_voltage}V", $clientId);
                }

                // 2. التحقق من استهلاك الطاقة مقارنة بالطاقة المتاحة
                $totalAvailablePower = $broadcastData->solar_power_generation + ($broadcastData->battery_voltage * 100);
                if ($broadcastData->power_consumption > $totalAvailablePower) {
                    $this->sendAlert("Power consumption exceeds available power! Consumption: {$broadcastData->power_consumption}W, Available power: {$totalAvailablePower}W", $clientId);
                }

                // 3. التحقق من استهلاك الطاقة مقارنة بقدرة الانفرتر
                if ($broadcastData->power_consumption > $inverter->invert_mode_rated_power) {
                    $this->sendAlert("Power consumption exceeded inverter limit! Consumption: {$broadcastData->power_consumption}W, Inverter limit: {$inverter->invert_mode_rated_power}W", $clientId);
                }

                // 5. التحقق من الشحن الزائد للبطارية
                if ($broadcastData->battery_voltage > $Battery->float_stage_volts) {
                    $this->sendAlert("Battery overcharge detected! Voltage: {$broadcastData->battery_voltage}V", $clientId);
                }

                // 6. التحقق من مستوى البطارية
                if ($broadcastData->battery_percentage < 20) {
                    $this->sendAlert("Low battery level! Battery at {$broadcastData->battery_percentage}%", $clientId);
                }
            }
            sleep(6);
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
