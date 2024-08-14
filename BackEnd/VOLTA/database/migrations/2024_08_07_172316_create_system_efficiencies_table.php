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
        Schema::create('system_efficiencies', function (Blueprint $table) {
            $table->bigIncrements('system_efficiency_id');
            $table->unsignedBigInteger('solar_sys_info_id');
            $table->foreign('solar_sys_info_id')->references('solar_sys_info_id')->on('solar_system_infos');
            $table->string('power_generation(w)');
            $table->string('power_consumption(w)');;
            $table->decimal('efficiency');
            $table->date('date');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('system_efficiencies');
    }
};
