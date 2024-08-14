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
        Schema::create('ratings', function (Blueprint $table) {
            $table->bigIncrements('rating_id');
            $table->unsignedBigInteger('technical_expert_id');
            $table->foreign('technical_expert_id')->references('technical_expert_id')->on('technical_experts');
            $table->unsignedBigInteger('client_id');
            $table->foreign('client_id')->references('client_id')->on('clients');
            $table->integer('rate');
            $table->string('commet');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('ratings');
    }
};
