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
        Schema::create('clients', function (Blueprint $table) {
            $table->bigIncrements('client_id');
            $table->string('name');
            $table->string('phone_number');
            $table->string('home_address');
            $table->string('user_name')->unique();
            $table->string('password');
            $table->string('connection_code');
            $table->unsignedBigInteger('technical_expert_id');
            $table->foreign('technical_expert_id')->references('technical_expert_id')->on('technical_experts');
            $table->enum('role', ['client']);
            $table->boolean('is_active')->default(true);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('clients');
    }
};
