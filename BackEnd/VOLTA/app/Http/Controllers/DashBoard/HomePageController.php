<?php

namespace App\Http\Controllers\DashBoard;

use App\Models\Panel;
use App\Models\Client;
use App\Models\Battery;
use App\Models\Inverter;
use Illuminate\Http\Request;
use App\Models\BroadcastDevice;
use App\Models\SolarSystemInfo;
use App\Models\TechnicalExpert;
use App\Models\RequestEquipment;
use App\Http\Controllers\Controller;

class HomePageController extends Controller
{

    // تابع يعرض البيانات لصفحة الHome Dashboard
    public function getDashboardData()
    {
        try {
            // جلب عدد أنواع البطاريات
            $batteryCount = Battery::count();

            // جلب عدد أنواع الانفرترات
            $inverterCount = Inverter::count();

            // جلب عدد أنواع الألواح الشمسية
            $panelCount = Panel::count();

            // جلب عدد العملاء
            $clientCount = Client::count();

            // جلب عدد الفنيين (technical experts)
            $technicalExpertCount = TechnicalExpert::count();

            // جلب عدد طلبات المعدات
            $requestEquipmentCount = RequestEquipment::count();

            // جلب عدد أجهزة البث (Broadcast Devices)
            $broadcastDeviceCount = BroadcastDevice::count();

            // جلب عدد الأنظمة الشمسية
            $solarSystemCount = SolarSystemInfo::count();

            // إعادة البيانات للواجهة
            return response()->json([
                'msg' => 'Success',
                'Home Page Data' => [
                    'battery_count' => $batteryCount,
                    'inverter_count' => $inverterCount,
                    'panel_count' => $panelCount,
                    'client_count' => $clientCount,
                    'technical_expert_count' => $technicalExpertCount,
                    'request_equipment_count' => $requestEquipmentCount,
                    'broadcast_device_count' => $broadcastDeviceCount,
                    'solar_system_count' => $solarSystemCount
                ]
            ], 200, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500);
        }
    }
}
