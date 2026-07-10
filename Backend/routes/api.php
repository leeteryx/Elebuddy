<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\GameController;

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/update-screening', [AuthController::class, 'updateScreening']);

    // Profil Anak
    Route::get('/profil-anak', [AuthController::class, 'getProfilAnak']);
    Route::post('/profil-anak', [AuthController::class, 'updateProfilAnak']);

    // Perkembangan
    Route::get('/perkembangan', [GameController::class, 'getPerkembangan']);
});

Route::post('/save-score', [GameController::class, 'saveScore']);
Route::post('/get-game-results', [GameController::class, 'getGameResults']);
