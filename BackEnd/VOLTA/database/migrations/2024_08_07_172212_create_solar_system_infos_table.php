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
        Schema::create('solar_system_infos', function (Blueprint $table) {
            $table->bigIncrements('solar_sys_info_id');
            $table->unsignedBigInteger('client_id');
            $table->foreign('client_id')->references('client_id')->on('clients');
            $table->unsignedBigInteger('technical_expert_id');
            $table->foreign('technical_expert_id')->references('technical_expert_id')->on('technical_experts');
            $table->unsignedBigInteger('inverters_id');
            $table->foreign('inverters_id')->references('inverters_id')->on('inverters');
            $table->unsignedBigInteger('battery_id');
            $table->foreign('battery_id')->references('battery_id')->on('batteries');
            $table->string('number_of_battery');
            $table->unsignedBigInteger('panel_id');
            $table->foreign('panel_id')->references('panel_id')->on('panels');
            $table->string('number_of_panel');
            $table->string('number_of_panel_group');
            $table->string('panel_conection_typeone');
            $table->string('panel_conection_typetwo');
            $table->string('phase_type');
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
        Schema::dropIfExists('solar_system_infos');
    }
};
