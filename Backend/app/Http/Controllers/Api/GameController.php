<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\GameResult;

class GameController extends Controller
{
    // --- FUNGSI 1: Untuk MENYIMPAN skor dari Flutter ke Database ---
    public function saveScore(Request $request)
    {
        // 1. Pastikan data yang dikirim dari Flutter valid
        $request->validate([
            'user_id' => 'required|exists:users,id',
            'game_name' => 'required|string',
            'score' => 'required|integer',
        ]);

        // 2. Simpan ke database
        $gameResult = GameResult::create([
            'user_id' => $request->user_id,
            'game_name' => $request->game_name,
            'score' => $request->score,
        ]);

        // 3. Beri jawaban sukses ke Flutter
        return response()->json([
            'success' => true,
            'message' => 'Skor berhasil disimpan dan dihubungkan ke user!',
            'data' => $gameResult
        ], 201);
    }

    // --- FUNGSI 2: Untuk MENGIRIM daftar skor dari Database ke Flutter ---
    public function getGameResults(Request $request)
    {
        // Validasi user_id yang dikirim dari Flutter
        $request->validate([
            'user_id' => 'required|exists:users,id',
        ]);

        // Mengambil skor berdasarkan user_id, diurutkan dari yang terbaru
        $results = GameResult::where('user_id', $request->user_id)
            ->orderBy('created_at', 'desc')
            ->get()
            // Filter agar setiap game hanya muncul 1 kali (diambil skor terbarunya saja)
            ->unique('game_name')
            ->values();

        return response()->json([
            'success' => true,
            'data' => $results
        ], 200);
    }
}
