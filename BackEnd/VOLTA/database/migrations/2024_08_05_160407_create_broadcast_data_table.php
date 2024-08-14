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
        Schema::create('broadcast_data', function (Blueprint $table) {
            $table->bigIncrements('broadcast_data_id');
            $table->decimal('inverter_output_voltage');
            $table->decimal('inverter_input_voltage');
            $table->decimal('battery_voltage');
            $table->integer('solar_power_generation(w)');
            $table->integer('power_consumption(w)');
            $table->string('load_percentage');
            $table->string('output_frequency(hz)');
            $table->integer('battery_charging_power(w)');
            $table->string('battery_percentage');
            $table->string('battery_discharge_power');
            $table->boolean('electric');
            $table->boolean('status');
            $table->string('error_code');
            $table->unsignedBigInteger('broadcast_device_id');
            $table->foreign('broadcast_device_id')->references('broadcast_device_id')->on('broadcast_devices');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('broadcast_data');
    }
};
