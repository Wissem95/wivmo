<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Exécuter les migrations.
     * Création de la table users pour LifeCompanion
     */
    public function up(): void
    {
        Schema::create('users', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('email')->unique();
            $table->timestamp('email_verified_at')->nullable();
            $table->string('password');

            // Champs spécifiques LifeCompanion
            $table->string('timezone')->default('Europe/Paris');
            $table->json('comfort_preferences')->nullable()->comment('Préférences de confort utilisateur');
            $table->json('notification_settings')->nullable()->comment('Paramètres de notifications');
            $table->boolean('is_active')->default(true);
            $table->timestamp('last_activity_at')->nullable();

            // Champs de profil
            $table->string('avatar')->nullable();
            $table->date('birth_date')->nullable();
            $table->enum('gender', ['male', 'female', 'other', 'prefer_not_to_say'])->nullable();
            $table->decimal('height', 5, 2)->nullable()->comment('Taille en cm');
            $table->decimal('weight', 5, 2)->nullable()->comment('Poids en kg');

            $table->rememberToken();
            $table->timestamps();

            // Index pour les performances
            $table->index(['email', 'is_active']);
            $table->index('last_activity_at');
        });
    }

    /**
     * Annuler les migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('users');
    }
};
