<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\EnvironmentalController;
use App\Http\Controllers\Api\ActivityController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

// Routes publiques (sans authentification)
Route::prefix('auth')->group(function () {
    Route::post('register', [AuthController::class, 'register']);
    Route::post('login', [AuthController::class, 'login']);
});

// Routes protégées (avec authentification Sanctum)
Route::middleware('auth:sanctum')->group(function () {
    // Authentification
    Route::prefix('auth')->group(function () {
        Route::post('logout', [AuthController::class, 'logout']);
        Route::get('me', [AuthController::class, 'me']);
        Route::post('refresh', [AuthController::class, 'refresh']);
    });

    // Profil utilisateur
    Route::get('user', function (Request $request) {
        return response()->json([
            'success' => true,
            'data' => $request->user()
        ]);
    });

    // Données environnementales
    Route::prefix('environmental')->group(function () {
        Route::get('current', [EnvironmentalController::class, 'current']);
        Route::get('history', [EnvironmentalController::class, 'history']);
    });

    // Activités utilisateur
    Route::prefix('activities')->group(function () {
        Route::get('current', [ActivityController::class, 'current']);
        Route::get('history', [ActivityController::class, 'history']);
    });

    // TODO: Ajouter les routes pour :
    // - Appareils IoT (/devices)
    // - Notifications (/notifications)
});