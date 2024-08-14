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
        Schema::create('broadcast_devices', function (Blueprint $table) {
            $table->bigIncrements('broadcast_device_id');
            $table->string('model');
            $table->string('version');
            $table->string('number_of_wired_port');
            $table->string('number_of_wireless_port');
            $table->string('status');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('broadcast_devices');
    }
};
