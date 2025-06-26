<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Exécuter les migrations.
     * Création de la table activity_classifications pour les activités détectées
     */
    public function up(): void
    {
        Schema::create('activity_classifications', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->foreignId('device_id')->constrained()->onDelete('cascade');

            // Période d'activité
            $table->timestampTz('started_at', precision: 3);
            $table->timestampTz('ended_at', precision: 3)->nullable();
            $table->integer('duration_seconds')->nullable()->comment('Durée en secondes');

            // Classification de l\'activité
            $table->enum('activity_type', [
                'stationary',    // Stationnaire (travail, repos)
                'walking',       // Marche
                'running',       // Course
                'cycling',       // Vélo
                'transport',     // Transport (bus, voiture, train)
                'intense',       // Activité intense
                'sleeping',      // Sommeil
                'unknown'        // Non déterminé
            ])->comment('Type d\'activité détectée');

            $table->decimal('confidence_score', 5, 4)->comment('Score de confiance (0-1)');

            // Contexte environnemental durant l\'activité
            $table->decimal('avg_temperature', 5, 2)->nullable();
            $table->decimal('avg_humidity', 5, 2)->nullable();
            $table->decimal('avg_pressure', 7, 2)->nullable();
            $table->decimal('avg_comfort_score', 5, 2)->nullable();

            // Métriques d\'activité
            $table->integer('step_count')->nullable()->comment('Nombre de pas estimés');
            $table->decimal('distance_meters', 8, 2)->nullable()->comment('Distance parcourue en mètres');
            $table->decimal('calories_burned', 6, 2)->nullable()->comment('Calories brûlées estimées');
            $table->decimal('avg_intensity', 5, 4)->nullable()->comment('Intensité moyenne (0-1)');

            // Données d\'entraînement ML
            $table->json('feature_vector')->nullable()->comment('Vecteur de caractéristiques pour ML');
            $table->boolean('is_manually_verified')->default(false)->comment('Vérifié manuellement par l\'utilisateur');
            $table->string('verification_source')->nullable()->comment('Source de vérification');

            // Localisation
            $table->string('location_name')->nullable()->comment('Nom du lieu');
            $table->decimal('start_latitude', 10, 8)->nullable();
            $table->decimal('start_longitude', 11, 8)->nullable();
            $table->decimal('end_latitude', 10, 8)->nullable();
            $table->decimal('end_longitude', 11, 8)->nullable();

            // Métadonnées
            $table->json('metadata')->nullable()->comment('Données supplémentaires');
            $table->string('classification_model')->nullable()->comment('Modèle ML utilisé');
            $table->string('model_version')->nullable()->comment('Version du modèle');

            $table->timestamps();

            // Index pour les performances
            $table->index(['user_id', 'started_at']);
            $table->index(['user_id', 'activity_type', 'started_at']);
            $table->index(['device_id', 'started_at']);
            $table->index('started_at');
            $table->index(['activity_type', 'confidence_score']);
            $table->index('is_manually_verified');
        });

        // Conversion en hypertable TimescaleDB si disponible
        try {
            DB::statement("SELECT create_hypertable('activity_classifications', 'started_at');");
        } catch (Exception $e) {
            // TimescaleDB non disponible, utilisation PostgreSQL standard
            \Log::info('TimescaleDB non disponible pour activity_classifications');
        }
    }

    /**
     * Annuler les migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('activity_classifications');
    }
};
