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
        Schema::create('technical_experts', function (Blueprint $table) {
            $table->bigIncrements('technical_expert_id');
            $table->string('name');
            $table->string('phone_number');
            $table->string('home_address');
            $table->string('user_name')->unique();
            $table->string('password');
            $table->unsignedBigInteger('admin_id');
            $table->foreign('admin_id')->references('admin_id')->on('admins');
            $table->enum('role', ['technical_expert']);
            $table->boolean('is_active')->default(true);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('technical_experts');
    }
};
