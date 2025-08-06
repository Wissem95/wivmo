<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\LoginRequest;
use App\Http\Requests\Auth\RegisterRequest;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

/**
 * Contrôleur d'authentification API
 * Gestion inscription, connexion, déconnexion avec Laravel Sanctum
 */
class AuthController extends Controller
{
    /**
     * Inscription nouvel utilisateur
     * 
     * @param RegisterRequest $request
     * @return JsonResponse
     */
    public function register(RegisterRequest $request): JsonResponse
    {
        try {
            // Création utilisateur avec données validées
            $user = User::create([
                'name' => $request->validated('name'),
                'email' => $request->validated('email'),
                'password' => Hash::make($request->validated('password')),
            ]);

            // Génération token Sanctum
            $token = $user->createToken('auth-token', ['*'], now()->addDay());

            return response()->json([
                'success' => true,
                'message' => 'User registered successfully',
                'data' => [
                    'user' => [
                        'id' => $user->id,
                        'name' => $user->name,
                        'email' => $user->email,
                        'email_verified_at' => $user->email_verified_at,
                        'created_at' => $user->created_at,
                        'updated_at' => $user->updated_at,
                    ],
                    'token' => $token->plainTextToken,
                    'expires_at' => $token->accessToken->expires_at,
                ]
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'error' => [
                    'code' => 'REGISTRATION_ERROR',
                    'message' => 'Registration failed',
                    'details' => config('app.debug') ? $e->getMessage() : null
                ]
            ], 500);
        }
    }

    /**
     * Connexion utilisateur existant
     * 
     * @param LoginRequest $request
     * @return JsonResponse
     * @throws ValidationException
     */
    public function login(LoginRequest $request): JsonResponse
    {
        // Tentative d'authentification
        if (!Auth::attempt($request->only('email', 'password'))) {
            throw ValidationException::withMessages([
                'email' => ['The provided credentials are incorrect.'],
            ]);
        }

        $user = Auth::user();

        // Révocation anciens tokens (optionnel - sécurité renforcée)
        // $user->tokens()->delete();

        // Génération nouveau token
        $token = $user->createToken('auth-token', ['*'], now()->addDay());

        return response()->json([
            'success' => true,
            'message' => 'Login successful',
            'data' => [
                'user' => [
                    'id' => $user->id,
                    'name' => $user->name,
                    'email' => $user->email,
                    'profile' => [
                        'timezone' => $user->timezone ?? 'Europe/Paris',
                        'language' => $user->language ?? 'fr',
                        'notifications_enabled' => $user->notifications_enabled ?? true,
                    ]
                ],
                'token' => $token->plainTextToken,
                'expires_at' => $token->accessToken->expires_at,
            ]
        ]);
    }

    /**
     * Déconnexion - révoque le token actuel
     * 
     * @param Request $request
     * @return JsonResponse
     */
    public function logout(Request $request): JsonResponse
    {
        // Révocation du token utilisé pour cette requête
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'success' => true,
            'message' => 'Logged out successfully'
        ]);
    }

    /**
     * Informations utilisateur authentifié
     * 
     * @param Request $request
     * @return JsonResponse
     */
    public function me(Request $request): JsonResponse
    {
        $user = $request->user();

        return response()->json([
            'success' => true,
            'data' => [
                'user' => [
                    'id' => $user->id,
                    'name' => $user->name,
                    'email' => $user->email,
                    'email_verified_at' => $user->email_verified_at,
                    'profile' => [
                        'timezone' => $user->timezone ?? 'Europe/Paris',
                        'language' => $user->language ?? 'fr',
                        'notifications_enabled' => $user->notifications_enabled ?? true,
                    ],
                    'created_at' => $user->created_at,
                    'updated_at' => $user->updated_at,
                ]
            ]
        ]);
    }

    /**
     * Rafraîchissement token (optionnel)
     * 
     * @param Request $request
     * @return JsonResponse
     */
    public function refresh(Request $request): JsonResponse
    {
        $user = $request->user();

        // Révocation token actuel
        $request->user()->currentAccessToken()->delete();

        // Génération nouveau token
        $token = $user->createToken('auth-token', ['*'], now()->addDay());

        return response()->json([
            'success' => true,
            'message' => 'Token refreshed successfully',
            'data' => [
                'token' => $token->plainTextToken,
                'expires_at' => $token->accessToken->expires_at,
            ]
        ]);
    }
}
