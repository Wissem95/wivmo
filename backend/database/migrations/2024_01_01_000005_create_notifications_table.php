<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Exécuter les migrations.
     * Création de la table notifications pour les notifications intelligentes
     */
    public function up(): void
    {
        Schema::create('notifications', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->foreignId('device_id')->nullable()->constrained()->onDelete('set null');

            // Informations de base
            $table->string('title')->comment('Titre de la notification');
            $table->text('message')->comment('Contenu de la notification');
            $table->enum('type', [
                'comfort_alert',      // Alerte de confort (temp/humidity)
                'activity_summary',   // Résumé d\'activité
                'health_tip',        // Conseil santé
                'environment_change', // Changement environnemental
                'device_status',     // Statut device
                'goal_achieved',     // Objectif atteint
                'reminder',          // Rappel
                'insight',           // Insight personnalisé
                'warning',           // Avertissement
                'system'             // Notification système
            ])->comment('Type de notification');

            $table->enum('priority', ['low', 'normal', 'high', 'urgent'])->default('normal');

            // État de la notification
            $table->enum('status', ['pending', 'sent', 'delivered', 'read', 'dismissed', 'failed'])
                ->default('pending');
            $table->timestamp('sent_at')->nullable();
            $table->timestamp('read_at')->nullable();
            $table->timestamp('dismissed_at')->nullable();

            // Paramètres de délivrance
            $table->json('delivery_channels')->comment('Canaux: push, email, sms, in_app');
            $table->json('delivery_settings')->nullable()->comment('Paramètres spécifiques par canal');
            $table->timestamp('scheduled_for')->nullable()->comment('Planification de la notification');

            // Contenu riche
            $table->json('data')->nullable()->comment('Données supplémentaires (actions, images, etc.)');
            $table->string('icon')->nullable()->comment('Icône de la notification');
            $table->string('image_url')->nullable()->comment('Image associée');
            $table->json('actions')->nullable()->comment('Actions disponibles (boutons)');

            // Contexte de génération
            $table->string('trigger_event')->nullable()->comment('Événement déclencheur');
            $table->json('trigger_data')->nullable()->comment('Données de contexte');
            $table->decimal('relevance_score', 5, 4)->nullable()->comment('Score de pertinence (0-1)');

            // Métadonnées de délivrance
            $table->json('delivery_results')->nullable()->comment('Résultats par canal');
            $table->integer('retry_count')->default(0)->comment('Nombre de tentatives');
            $table->timestamp('last_retry_at')->nullable();
            $table->text('error_message')->nullable()->comment('Message d\'erreur si échec');

            // Groupement et suppression
            $table->string('group_key')->nullable()->comment('Clé pour grouper les notifications');
            $table->boolean('is_persistent')->default(false)->comment('Notification persistante');
            $table->timestamp('expires_at')->nullable()->comment('Date d\'expiration');

            $table->timestamps();

            // Index pour les performances
            $table->index(['user_id', 'status', 'created_at']);
            $table->index(['user_id', 'type', 'status']);
            $table->index(['status', 'scheduled_for']);
            $table->index('sent_at');
            $table->index('expires_at');
            $table->index(['group_key', 'user_id']);
            $table->index(['trigger_event', 'created_at']);
        });
    }

    /**
     * Annuler les migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('notifications');
    }
};
