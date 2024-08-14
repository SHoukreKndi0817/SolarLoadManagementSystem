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
        Schema::create('sockets', function (Blueprint $table) {
            $table->bigIncrements('socket_id');
            $table->unsignedBigInteger('broadcast_device_id');
            $table->foreign('broadcast_device_id')->references('broadcast_device_id')->on('broadcast_devices');
            $table->string('socket_model');
            $table->string('socket_version');
            $table->string('socket_name');
            $table->string('socket_connection_type');
            $table->boolean('status');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('sockets');
    }
};
