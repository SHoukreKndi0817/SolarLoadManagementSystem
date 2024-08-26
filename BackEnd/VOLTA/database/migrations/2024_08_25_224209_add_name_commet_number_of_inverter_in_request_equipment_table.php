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
        Schema::table('request_equipment', function (Blueprint $table) {
            $table->string('name')->after('technical_expert_id');
            $table->string('commet')->after('status');
            $table->string('number_of_inverter')->after('inverters_id');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('request_equipment', function (Blueprint $table) {
            //
        });
    }
};
