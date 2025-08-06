<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Carbon\Carbon;

/**
 * Contrôleur API des activités utilisateur
 * Classification et historique des activités
 */
class ActivityController extends Controller
{
    /**
     * Activité actuelle de l'utilisateur
     * 
     * @return JsonResponse
     */
    public function current(): JsonResponse
    {
        try {
            $activities = ['resting', 'walking', 'working', 'sleeping', 'exercising', 'cooking'];
            $currentActivity = $activities[array_rand($activities)];
            
            $currentData = [
                'activity' => $currentActivity,
                'confidence' => round(rand(75, 98) / 100, 2), // 0.75-0.98
                'duration_minutes' => rand(5, 120),
                'calories_burned' => $this->calculateCalories($currentActivity),
                'steps_count' => $currentActivity === 'walking' ? rand(500, 2000) : rand(0, 100),
                'heart_rate' => $this->getHeartRate($currentActivity),
                'location' => $this->getLocation($currentActivity),
                'timestamp' => now()->toISOString(),
                'device_id' => 'lifecompanion_activity_tracker',
                'wellness_score' => rand(65, 95),
                'recommendations' => $this->getActivityRecommendations($currentActivity),
            ];

            return response()->json([
                'success' => true,
                'message' => 'Activité actuelle de l\'utilisateur',
                'data' => $currentData
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'error' => [
                    'code' => 'ACTIVITY_ERROR',
                    'message' => 'Erreur lors de la récupération de l\'activité',
                    'details' => config('app.debug') ? $e->getMessage() : null
                ]
            ], 500);
        }
    }

    /**
     * Historique des activités
     * 
     * @param Request $request
     * @return JsonResponse
     */
    public function history(Request $request): JsonResponse
    {
        try {
            $startDate = $request->get('start_date', now()->subDay()->toISOString());
            $endDate = $request->get('end_date', now()->toISOString());
            
            $activities = ['resting', 'walking', 'working', 'sleeping', 'exercising', 'cooking'];
            $history = [];
            
            $start = Carbon::parse($startDate);
            $end = Carbon::parse($endDate);
            
            // Générer des activités par blocs de 30 minutes à 2 heures
            while ($start < $end) {
                $activity = $activities[array_rand($activities)];
                $duration = rand(30, 120); // 30 min à 2h
                
                $activityEnd = $start->copy()->addMinutes($duration);
                if ($activityEnd > $end) {
                    $activityEnd = $end;
                    $duration = $start->diffInMinutes($activityEnd);
                }
                
                $history[] = [
                    'activity' => $activity,
                    'confidence' => round(rand(75, 98) / 100, 2),
                    'duration_minutes' => $duration,
                    'calories_burned' => $this->calculateCalories($activity, $duration),
                    'steps_count' => $activity === 'walking' ? rand(500, 2000) : rand(0, 100),
                    'start_time' => $start->toISOString(),
                    'end_time' => $activityEnd->toISOString(),
                    'location' => $this->getLocation($activity),
                    'device_id' => 'lifecompanion_activity_tracker',
                ];
                
                $start = $activityEnd;
                
                // Pause aléatoire entre les activités
                if ($start < $end) {
                    $start->addMinutes(rand(5, 15));
                }
            }

            return response()->json([
                'success' => true,
                'message' => 'Historique des activités',
                'data' => [
                    'activities' => $history,
                    'summary' => [
                        'total_activities' => count($history),
                        'period' => [
                            'start' => $startDate,
                            'end' => $endDate,
                        ],
                        'stats' => $this->calculateActivityStats($history),
                    ]
                ]
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'error' => [
                    'code' => 'ACTIVITY_HISTORY_ERROR',
                    'message' => 'Erreur lors de la récupération de l\'historique',
                    'details' => config('app.debug') ? $e->getMessage() : null
                ]
            ], 500);
        }
    }

    /**
     * Calculer les calories brûlées selon l'activité
     * 
     * @param string $activity
     * @param int $duration
     * @return int
     */
    private function calculateCalories(string $activity, int $duration = 60): int
    {
        $caloriesPerHour = [
            'resting' => 70,
            'walking' => 280,
            'working' => 120,
            'sleeping' => 50,
            'exercising' => 450,
            'cooking' => 180,
        ];

        $rate = $caloriesPerHour[$activity] ?? 100;
        return (int) round(($rate / 60) * $duration);
    }

    /**
     * Obtenir la fréquence cardiaque selon l'activité
     * 
     * @param string $activity
     * @return int
     */
    private function getHeartRate(string $activity): int
    {
        $heartRates = [
            'resting' => [60, 80],
            'walking' => [90, 120],
            'working' => [70, 90],
            'sleeping' => [50, 70],
            'exercising' => [120, 160],
            'cooking' => [80, 100],
        ];

        $range = $heartRates[$activity] ?? [70, 90];
        return rand($range[0], $range[1]);
    }

    /**
     * Obtenir la localisation selon l'activité
     * 
     * @param string $activity
     * @return string
     */
    private function getLocation(string $activity): string
    {
        $locations = [
            'resting' => 'Salon',
            'walking' => 'Extérieur',
            'working' => 'Bureau',
            'sleeping' => 'Chambre',
            'exercising' => 'Salle de sport',
            'cooking' => 'Cuisine',
        ];

        return $locations[$activity] ?? 'Maison';
    }

    /**
     * Recommandations selon l'activité
     * 
     * @param string $activity
     * @return array
     */
    private function getActivityRecommendations(string $activity): array
    {
        $recommendations = [
            'resting' => ['Profitez de ce moment de détente', 'Hydratez-vous régulièrement'],
            'walking' => ['Maintenez un rythme régulier', 'Attention à votre posture'],
            'working' => ['Pensez à faire des pauses', 'Étirez-vous toutes les heures'],
            'sleeping' => ['Maintenez un environnement calme', 'Évitez les écrans'],
            'exercising' => ['Restez hydraté', 'Écoutez votre corps'],
            'cooking' => ['Attention à la sécurité', 'Privilégiez les ingrédients sains'],
        ];

        return $recommendations[$activity] ?? ['Continuez vos bonnes habitudes'];
    }

    /**
     * Calculer les statistiques des activités
     * 
     * @param array $activities
     * @return array
     */
    private function calculateActivityStats(array $activities): array
    {
        if (empty($activities)) {
            return [];
        }

        $stats = [
            'total_duration' => 0,
            'total_calories' => 0,
            'total_steps' => 0,
            'activity_breakdown' => [],
        ];

        foreach ($activities as $activity) {
            $stats['total_duration'] += $activity['duration_minutes'];
            $stats['total_calories'] += $activity['calories_burned'];
            $stats['total_steps'] += $activity['steps_count'];
            
            $activityType = $activity['activity'];
            if (!isset($stats['activity_breakdown'][$activityType])) {
                $stats['activity_breakdown'][$activityType] = [
                    'count' => 0,
                    'total_duration' => 0,
                ];
            }
            
            $stats['activity_breakdown'][$activityType]['count']++;
            $stats['activity_breakdown'][$activityType]['total_duration'] += $activity['duration_minutes'];
        }

        return $stats;
    }
}