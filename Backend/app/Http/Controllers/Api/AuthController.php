<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        $user = User::create([
            'name'       => $request->name,
            'email'      => $request->email,
            'password'   => Hash::make($request->password),
            'child_name' => $request->child_name,
            'child_age'  => $request->child_age,
        ]);

        return response()->json([
            'success' => true,
            'token'   => $user->createToken('auth_token')->plainTextToken,
        ], 201);
    }

    public function login(Request $request)
    {
        $user = User::where('email', $request->email)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json([
                'success' => false,
                'message' => 'Invalid credentials',
            ], 401);
        }

        return response()->json([
            'success' => true,
            'token'   => $user->createToken('auth_token')->plainTextToken,
            'user'    => $user,
        ]);
    }

    public function updateScreening(Request $request)
    {
        $request->user()->update(['has_completed_screening' => 1]);
        return response()->json(['success' => true]);
    }

    // ── ambil profil anak ──────────────────────────────────────────
    public function getProfilAnak(Request $request)
    {
        $user = $request->user();

        return response()->json([
            'success' => true,
            'data'    => [
                'child_name'   => $user->child_name,
                'child_age'    => $user->child_age,
                'child_gender' => $user->child_gender,
                'child_notes'  => $user->child_notes,
            ],
        ]);
    }

    // ── update profil anak ─────────────────────────────────────────
    public function updateProfilAnak(Request $request)
    {
        $request->validate([
            'child_name'   => 'nullable|string|max:100',
            'child_age'    => 'nullable|integer|min:0|max:18',
            'child_gender' => 'nullable|in:L,P',
            'child_notes'  => 'nullable|string|max:500',
        ]);

        $request->user()->update([
            'child_name'   => $request->child_name,
            'child_age'    => $request->child_age,
            'child_gender' => $request->child_gender,
            'child_notes'  => $request->child_notes,
        ]);

        return response()->json(['success' => true, 'message' => 'Profil berhasil diperbarui']);
    }
}
