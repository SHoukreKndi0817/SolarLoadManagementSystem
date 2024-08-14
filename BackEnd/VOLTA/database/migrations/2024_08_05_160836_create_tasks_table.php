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
        Schema::create('tasks', function (Blueprint $table) {
            $table->bigIncrements('task_id');
            $table->unsignedBigInteger('client_id');
            $table->foreign('client_id')->references('client_id')->on('clients');
            $table->unsignedBigInteger('home_device_id');
            $table->foreign('home_device_id')->references('home_device_id')->on('home_devices');
            $table->enum('task_type', ['on', 'off']);
            $table->string('start_time');
            $table->string('end_time');
            $table->enum('status', ['completed', 'in progress', 'pending']);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('tasks');
    }
};
