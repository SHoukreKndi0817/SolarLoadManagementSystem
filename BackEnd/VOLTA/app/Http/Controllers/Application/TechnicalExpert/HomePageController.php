<?php

namespace App\Http\Controllers\Application\TechnicalExpert;

use App\Models\Client;
use Illuminate\Http\Request;
use App\Models\TechnicalExpert;
use App\Models\RequestEquipment;
use App\Http\Controllers\Controller;
use Illuminate\Validation\ValidationException;

class HomePageController extends Controller
{

    public function TechnicalExpertHomePage(Request $request)
    {
        try {
            // التحقق من صحة البيانات المدخلة
            $validatedData = $request->validate([
                'technical_expert_id' => 'required|exists:technical_experts,technical_expert_id',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], 422, [], JSON_PRETTY_PRINT);
        }

        try {
            // جلب كائن الخبير باستخدام الـID
            $technicalExpert = TechnicalExpert::find($validatedData['technical_expert_id']);

            // جلب عدد العملاء التابعين لهذا الخبير
            $clients = Client::where('technical_expert_id', $technicalExpert->technical_expert_id)->get();
            $clientCount = $clients->count();
            // جلب عدد المنظومات الشمسية لجميع العملاء التابعين لهذا الخبير
            $totalSolarSystems = $clients->sum('total_solar_systems');


            // جلب عدد الطلبات التابعين لهذا الخبير
            $requestCount = RequestEquipment::where('technical_expert_id', $technicalExpert->technical_expert_id)->count();

            // جلب عدد أيام العمل للخبير
            $daysWorked = $technicalExpert->days_worked;
            // حساب متوسط التقييم
            $averageRating = round($technicalExpert->Rating()->avg('rate'), 2);


            return response()->json([
                "msg" => "Successfully",
                "Client Count" => $clientCount,
                "Total Solar Systems" => $totalSolarSystems,
                "Request Equipment Count" => $requestCount,
                "Days Worked" => $daysWorked,
                "The Rate" => $averageRating,
            ], 200, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }
}
