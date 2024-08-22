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
        Schema::table('solar_system_infos', function (Blueprint $table) {
            $table->unsignedBigInteger('battery_id')->nullable()->change();
            $table->unsignedBigInteger('panel_id')->nullable()->change();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('solar_system_infos', function (Blueprint $table) {
            //
        });
    }
};
