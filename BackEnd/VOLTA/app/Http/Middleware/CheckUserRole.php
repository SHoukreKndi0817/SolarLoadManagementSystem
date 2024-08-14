<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class CheckUserRole
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @param  string[]  ...$roles
     * @return mixed
     */
    public function handle(Request $request, Closure $next, ...$roles)
    {
        // الحصول على المستخدم المتصل
        $user = Auth::user();

        // التحقق من أن المستخدم لديه واحد من الأدوار المطلوبة
        if (!in_array($user->role, $roles)) {
            return response()->json(['msg' => 'You are not authorized'], 403);
        }

        // إذا كان المستخدم لديه الصلاحية المناسبة، تابع العملية
        return $next($request);
    }
}
