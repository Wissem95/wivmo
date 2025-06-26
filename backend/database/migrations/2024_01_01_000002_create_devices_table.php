<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Exécuter les migrations.
     * Création de la table devices pour les appareils IoT
     */
    public function up(): void
    {
        Schema::create('devices', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');

            // Informations de base du device
            $table->string('name')->comment('Nom personnalisé du device');
            $table->string('device_type')->comment('Type: ruuvi_sensor, phone, raspberry_pi');
            $table->string('mac_address')->unique()->comment('Adresse MAC unique');
            $table->string('hardware_version')->nullable();
            $table->string('firmware_version')->nullable();

            // Configuration MQTT
            $table->string('mqtt_topic')->unique()->comment('Topic MQTT du device');
            $table->json('mqtt_config')->nullable()->comment('Configuration MQTT spécifique');

            // Capacités du device
            $table->json('capabilities')->comment('Capteurs disponibles: temperature, humidity, pressure, accelerometer');
            $table->json('settings')->nullable()->comment('Paramètres de configuration');

            // État et santé
            $table->enum('status', ['active', 'inactive', 'offline', 'error'])->default('inactive');
            $table->timestamp('last_seen_at')->nullable();
            $table->integer('battery_level')->nullable()->comment('Niveau batterie en %');
            $table->json('health_metrics')->nullable()->comment('Métriques de santé du device');

            // Localisation (optionnelle)
            $table->string('location_name')->nullable()->comment('Nom du lieu (ex: chambre, bureau)');
            $table->decimal('latitude', 10, 8)->nullable();
            $table->decimal('longitude', 11, 8)->nullable();

            $table->timestamps();

            // Index pour les performances
            $table->index(['user_id', 'status']);
            $table->index(['device_type', 'status']);
            $table->index('mqtt_topic');
            $table->index('last_seen_at');
        });
    }

    /**
     * Annuler les migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('devices');
    }
};
