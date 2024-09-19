<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('broadcast_data', function (Blueprint $table) {
            $table->dropColumn([
                'inverter_output_voltage',
                'inverter_input_voltage',
                'battery_charging_power(w)',
                'battery_discharge_power',
                'load_percentage',
                'output_frequency(hz)',
                'error_code',
            ]);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('broadcast_data', function (Blueprint $table) {
            //
        });
    }
};
