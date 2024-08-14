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
        Schema::create('batteries', function (Blueprint $table) {
            $table->bigIncrements('battery_id');
            $table->string('battery_type');
            $table->decimal('absorb_stage_volts');
            $table->decimal('float_stage_volts');
            $table->decimal('equalize_stage_volts');
            $table->string('equalize_interval_days');
            $table->string('seting_switches');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('batteries');
    }
};
