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
        Schema::create('inverters', function (Blueprint $table) {
            $table->bigIncrements('inverters_id');
            $table->string('model_name');
            $table->string('operating_temperature');
            $table->string('invert_mode_rated_power');
            $table->string('invert_mode_dc_input');
            $table->string('invert_mode_ac_output');
            $table->string('ac_charger_mode_ac_input');
            $table->string('ac_charger_mode_ac_output');
            $table->string('ac_charger_mode_dc_output');
            $table->string('ac_charger_mode_max_charger');
            $table->string('solar_charger_mode_rated_power');
            $table->string('solar_charger_mode_system_voltage');
            $table->string('solar_charger_mode_mppt_voltage_range');
            $table->string('solar_charger_mode_max_solar_voltage');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('inverters');
    }
};
