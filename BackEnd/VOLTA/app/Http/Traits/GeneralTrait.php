<?php

namespace App\Http\Traits;

trait GeneralTrait
{


    public function returnError($errNum, $msg)
    {
        return response()->json([
            'status' => false,
            'msg' => $msg
        ]);
    }


    public function returnSuccessMessage($msg = "", $succNum = "200")
    {
        return response()->json([
            'status' => true,
            'sucNum' => $succNum,
            'msg' => $msg
        ]);
    }

    public function returnData($key, $value, $msg = "", $succNum = "200")
    {
        return response()->json([
            'status' => true,
            'sucNum' => $succNum,
            'msg' => $msg,
            $key => $value
        ]);
    }
}
