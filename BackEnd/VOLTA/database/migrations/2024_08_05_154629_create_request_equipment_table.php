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
        Schema::create('request_equipment', function (Blueprint $table) {
            $table->bigIncrements('request_equipment_id');
            $table->unsignedBigInteger('technical_expert_id');
            $table->foreign('technical_expert_id')->references('technical_expert_id')->on('technical_experts');
            $table->integer('number_of_broadcast_device');
            $table->integer('number_of_port');
            $table->integer('number_of_socket');
            $table->string('socket_type');
            $table->unsignedBigInteger('panel_id');
            $table->foreign('panel_id')->references('panel_id')->on('panels');
            $table->integer('number_of_panel');
            $table->unsignedBigInteger('battery_id');
            $table->foreign('battery_id')->references('battery_id')->on('batteries');
            $table->integer('number_of_battery');
            $table->unsignedBigInteger('inverters_id');
            $table->foreign('inverters_id')->references('inverters_id')->on('inverters');
            $table->string('additional_equipment');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('request_equipment');
    }
};
