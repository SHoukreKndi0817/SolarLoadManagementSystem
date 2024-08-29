<?php

namespace App\Http\Controllers\Application\Client;

use App\Models\Rating;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Validation\ValidationException;

class RateTechnicalExpert extends Controller
{
    public function RateTechnicalExpert(Request $request)
    {
        // التحقق من صحة البيانات المدخلة
        try {
            $validatedData = $request->validate([
                'client_id' => 'required|exists:clients,client_id',
                'technical_expert_id' => 'required|exists:technical_experts,technical_expert_id',
                'rate' => 'required|integer|min:1|max:5', // التقييم يجب أن يكون بين 1 و 5
                'commet' => 'nullable|string|max:255',
            ]);
        } catch (ValidationException $e) {
            return response()->json(["msg" => $e->validator->errors()->first()], 422, [], JSON_PRETTY_PRINT);
        }

        try {
            // التأكد من أن العميل لم يقم بتقييم هذا الخبير من قبل
            $existingRating = Rating::where('client_id', $validatedData['client_id'])
                ->where('technical_expert_id', $validatedData['technical_expert_id'])
                ->first();

            if ($existingRating) {
                return response()->json(["msg" => "You have already rated this expert"], 409, [], JSON_PRETTY_PRINT);
            }

            // إنشاء تقييم جديد
            $rating = Rating::create($validatedData);

            return response()->json([
                "msg" => "Rating added successfully",
                "Rating Data" => $rating,
            ], 201, [], JSON_PRETTY_PRINT);
        } catch (\Exception $e) {
            return response()->json(["msg" => $e->getMessage()], 500, [], JSON_PRETTY_PRINT);
        }
    }
}
