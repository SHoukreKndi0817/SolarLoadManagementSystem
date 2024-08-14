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
        Schema::create('home_devices', function (Blueprint $table) {
            $table->bigIncrements('home_device_id');
            $table->string('device_name');
            //appliance(براد),hvac(مكيفات),..
            $table->enum('device_type', ['appliance', 'lighting', 'hvac', 'entertainment']);
            $table->enum('device_operation_type', ['inrush', 'continuous']);
            $table->string('operation_max_voltage');
            $table->unsignedBigInteger('socket_id');
            $table->foreign('socket_id')->references('socket_id')->on('sockets');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('home_devices');
    }
};
