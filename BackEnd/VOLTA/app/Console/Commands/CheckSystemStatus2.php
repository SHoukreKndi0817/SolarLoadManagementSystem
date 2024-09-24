<?php

namespace App\Console\Commands;

use App\Models\Battery;
use App\Models\Inverter;
use App\Models\HomeDevice;
use App\Models\BroadcastData;
use App\Events\ClientNotiEvent;
use App\Models\BroadcastDevice;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Http;

class CheckSystemStatus2 extends Command
{

    protected $signature = 'system:check-status2';
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
                    $this->sendAlert("Low battery level! Battery voltage: {$broadcastData->battery_voltage}V", $clientId);
                    // إرسال طلب لإيقاف الجهاز
                    $this->sendShutdownRequest($solarSystem->solar_sys_info_id);
                }

                // 2. التحقق من استهلاك الطاقة مقارنة بالطاقة المتاحة
                $totalAvailablePower = $broadcastData->solar_power_generation + ($broadcastData->battery_voltage * 100);
                if ($broadcastData->power_consumption > $totalAvailablePower) {
                    $this->sendAlert("Power consumption exceeds available power! Consumption: {$broadcastData->power_consumption}W, Available power: {$totalAvailablePower}W", $clientId);
                    // إرسال طلب لإيقاف الجهاز
                    $this->sendShutdownRequest($solarSystem->solar_sys_info_id);
                }

                // 3. التحقق من استهلاك الطاقة مقارنة بقدرة الانفرتر
                if ($broadcastData->power_consumption > $inverter->invert_mode_rated_power) {
                    $this->sendAlert("Power consumption exceeded inverter limit! Consumption: {$broadcastData->power_consumption}W, Inverter limit: {$inverter->invert_mode_rated_power}W", $clientId);
                    // إرسال طلب لإيقاف الجهاز
                    $this->sendShutdownRequest($solarSystem->solar_sys_info_id);
                }

                // 4. التحقق من الشحن الزائد للبطارية
                if ($broadcastData->battery_voltage > $Battery->float_stage_volts) {
                    $this->sendAlert("Battery overcharge detected! Voltage: {$broadcastData->battery_voltage}V", $clientId);
                }

                // 5. التحقق من مستوى البطارية
                if ($broadcastData->battery_percentage < 20) {
                    $this->sendAlert("Low battery level! Battery at {$broadcastData->battery_percentage}%", $clientId);
                }
            }
            sleep(6); // يمكن تعديل هذا الفاصل الزمني
        }
    }

    // دالة لإرسال الإنذارات باستخدام Pusher
    public function sendAlert($message, $clientId)
    {
        $data = [
            'message' => $message,
            'time' => now(),
        ];

        event(new ClientNotiEvent($data, $clientId));

        $this->info("Alert sent to client {$clientId}: {$message}");
    }



    // دالة لإرسال طلب إيقاف التشغيل إلى جميع المقابس المرتبطة بجهاز البث
    public function sendShutdownRequest($solarSystemId)
    {
        // جلب BroadcastDevice المرتبط بالـ SolarSystemInfo
        $broadcastDevice = BroadcastDevice::whereHas('SolarSystemInfo', function ($query) use ($solarSystemId) {
            $query->where('solar_sys_info_id', $solarSystemId);
        })->first();

        if (!$broadcastDevice) {
            $this->error("Failed to find BroadcastDevice for solar system {$solarSystemId}.");
            return;
        }

        // جلب جميع المقابس المرتبطة بهذا BroadcastDevice
        $sockets = $broadcastDevice->Socket()->get();

        // التحقق من وجود مقابس مرتبطة
        if ($sockets->isEmpty()) {
            $this->error("No sockets found for BroadcastDevice {$broadcastDevice->broadcast_device_id}.");
            return;
        }

        // إرسال أمر الإيقاف لكل مقبس مرتبط بهذا الجهاز
        foreach ($sockets as $socket) {
            $this->sendCommandToSocket('off', $socket->serial_number); // إرسال أمر الإيقاف لكل مقبس
        }

        $this->info("Shutdown command sent for all sockets in solar system {$solarSystemId}.");
    }

    // دالة لإرسال الأوامر إلى المقبس
    public function sendCommandToSocket($command, $serialNumberForSocket)
    {
        $url = "http://device-ip-address/control"; // قم بتغيير هذا إلى عنوان IP الخاص بالنظام
        $data = [
            'command' => $command,
            'serial_number' => $serialNumberForSocket
        ];

        $response = Http::post($url, $data);

        if ($response->successful()) {
            $this->info("Command '{$command}' sent to socket with serial number {$serialNumberForSocket}.");
            return true;
        } else {
            $this->error("Failed to send command '{$command}' to socket with serial number {$serialNumberForSocket}.");
            return false;
        }
    }
}
