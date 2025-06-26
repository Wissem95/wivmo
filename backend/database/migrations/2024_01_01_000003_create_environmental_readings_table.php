<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Exécuter les migrations.
     * Création de la table environmental_readings pour les données de capteurs
     * Optimisée pour TimescaleDB (time series)
     */
    public function up(): void
    {
        Schema::create('environmental_readings', function (Blueprint $table) {
            $table->id();
            $table->foreignId('device_id')->constrained()->onDelete('cascade');
            $table->foreignId('user_id')->constrained()->onDelete('cascade');

            // Timestamp précis pour time series
            $table->timestampTz('measured_at', precision: 3)->comment('Timestamp précis de la mesure');

            // Données environnementales
            $table->decimal('temperature', 5, 2)->nullable()->comment('Température en °C');
            $table->decimal('humidity', 5, 2)->nullable()->comment('Humidité relative en %');
            $table->decimal('pressure', 7, 2)->nullable()->comment('Pression atmosphérique en hPa');

            // Données d'accéléromètre (pour classification activité)
            $table->decimal('acceleration_x', 8, 5)->nullable()->comment('Accélération X en m/s²');
            $table->decimal('acceleration_y', 8, 5)->nullable()->comment('Accélération Y en m/s²');
            $table->decimal('acceleration_z', 8, 5)->nullable()->comment('Accélération Z en m/s²');
            $table->decimal('acceleration_magnitude', 8, 5)->nullable()->comment('Magnitude totale de l\'accélération');

            // Données calculées
            $table->decimal('comfort_score', 5, 2)->nullable()->comment('Score de confort calculé (0-100)');
            $table->string('activity_hint')->nullable()->comment('Indice d\'activité détectée');

            // Métadonnées
            $table->json('raw_data')->nullable()->comment('Données brutes du capteur');
            $table->integer('signal_strength')->nullable()->comment('Force du signal RSSI');
            $table->integer('battery_voltage')->nullable()->comment('Tension batterie en mV');

            // Géolocalisation (si disponible)
            $table->decimal('latitude', 10, 8)->nullable();
            $table->decimal('longitude', 11, 8)->nullable();
            $table->decimal('altitude', 8, 2)->nullable()->comment('Altitude en mètres');

            $table->timestamps();

            // Index optimisés pour time series
            $table->index(['user_id', 'measured_at']);
            $table->index(['device_id', 'measured_at']);
            $table->index('measured_at');
            $table->index(['user_id', 'device_id', 'measured_at']);
        });

        // Conversion en hypertable TimescaleDB si disponible
        try {
            DB::statement("SELECT create_hypertable('environmental_readings', 'measured_at');");
        } catch (Exception $e) {
            // TimescaleDB non disponible, utilisation PostgreSQL standard
            \Log::info('TimescaleDB non disponible, utilisation de PostgreSQL standard');
        }
    }

    /**
     * Annuler les migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('environmental_readings');
    }
};
