<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

/**
 * Contrôleur API des données environnementales
 * Gestion des capteurs et données temps réel
 */
class EnvironmentalController extends Controller
{
    /**
     * Données environnementales actuelles
     * 
     * @return JsonResponse
     */
    public function current(): JsonResponse
    {
        try {
            // Simulation de données environnementales actuelles
            // En production, ceci viendrait de la base de données
            $currentData = [
                'temperature' => round(18 + (rand(0, 120) / 10), 1), // 18-30°C
                'humidity' => round(35 + (rand(0, 300) / 10), 1),    // 35-65%
                'pressure' => round(1000 + (rand(0, 300) / 10), 1), // 1000-1030 hPa
                'co2' => round(400 + rand(0, 800), 0),               // 400-1200 ppm
                'light' => round(rand(100, 2000), 0),                // 100-2000 lux
                'noise' => round(25 + (rand(0, 400) / 10), 1),      // 25-65 dB
                'air_quality_index' => rand(25, 150),               // 25-150 AQI
                'timestamp' => now()->toISOString(),
                'device_id' => 'lifecompanion_main_sensor',
                'location' => 'Salon principal',
                'comfort_status' => $this->getComfortStatus(),
            ];

            return response()->json([
                'success' => true,
                'message' => 'Données environnementales actuelles',
                'data' => $currentData
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'error' => [
                    'code' => 'ENVIRONMENTAL_ERROR',
                    'message' => 'Erreur lors de la récupération des données',
                    'details' => config('app.debug') ? $e->getMessage() : null
                ]
            ], 500);
        }
    }

    /**
     * Historique des données environnementales
     * 
     * @param Request $request
     * @return JsonResponse
     */
    public function history(Request $request): JsonResponse
    {
        try {
            $startDate = $request->get('start_date', now()->subHour()->toISOString());
            $endDate = $request->get('end_date', now()->toISOString());
            
            // Simulation d'un historique de données
            $history = [];
            $start = Carbon::parse($startDate);
            $end = Carbon::parse($endDate);
            
            $interval = $start->diffInMinutes($end) > 60 ? 10 : 5; // Intervalle en minutes
            
            while ($start <= $end) {
                $history[] = [
                    'temperature' => round(18 + (rand(0, 120) / 10), 1),
                    'humidity' => round(35 + (rand(0, 300) / 10), 1),
                    'pressure' => round(1000 + (rand(0, 300) / 10), 1),
                    'co2' => round(400 + rand(0, 800), 0),
                    'light' => round(rand(100, 2000), 0),
                    'noise' => round(25 + (rand(0, 400) / 10), 1),
                    'air_quality_index' => rand(25, 150),
                    'timestamp' => $start->toISOString(),
                    'device_id' => 'lifecompanion_main_sensor',
                ];
                
                $start->addMinutes($interval);
            }

            return response()->json([
                'success' => true,
                'message' => 'Historique des données environnementales',
                'data' => [
                    'readings' => $history,
                    'summary' => [
                        'total_readings' => count($history),
                        'period' => [
                            'start' => $startDate,
                            'end' => $endDate,
                        ],
                        'averages' => $this->calculateAverages($history),
                    ]
                ]
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'error' => [
                    'code' => 'ENVIRONMENTAL_HISTORY_ERROR',
                    'message' => 'Erreur lors de la récupération de l\'historique',
                    'details' => config('app.debug') ? $e->getMessage() : null
                ]
            ], 500);
        }
    }

    /**
     * Statut de confort basé sur les données environnementales
     * 
     * @return array
     */
    private function getComfortStatus(): array
    {
        $status = ['good', 'moderate', 'poor'][rand(0, 2)];
        $recommendations = [];

        switch ($status) {
            case 'good':
                $recommendations = ['Conditions optimales maintenues'];
                break;
            case 'moderate':
                $recommendations = ['Vérifier la ventilation', 'Ajuster la température'];
                break;
            case 'poor':
                $recommendations = ['Aérer la pièce', 'Vérifier les sources de CO2', 'Ajuster le chauffage/climatisation'];
                break;
        }

        return [
            'level' => $status,
            'score' => rand(60, 95),
            'recommendations' => $recommendations,
        ];
    }

    /**
     * Calculer les moyennes des données historiques
     * 
     * @param array $readings
     * @return array
     */
    private function calculateAverages(array $readings): array
    {
        if (empty($readings)) {
            return [];
        }

        $totals = [
            'temperature' => 0,
            'humidity' => 0,
            'pressure' => 0,
            'co2' => 0,
            'light' => 0,
            'noise' => 0,
            'air_quality_index' => 0,
        ];

        foreach ($readings as $reading) {
            foreach ($totals as $key => $value) {
                $totals[$key] += $reading[$key] ?? 0;
            }
        }

        $count = count($readings);
        $averages = [];

        foreach ($totals as $key => $total) {
            $averages[$key] = round($total / $count, 2);
        }

        return $averages;
    }
}