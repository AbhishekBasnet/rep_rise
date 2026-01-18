import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/*
 * ARCHITECTURE & FLOW OVERVIEW
 * ----------------------------
 * Role: Local Security Interface
 * Layer: Core / Services
 *
 * This service manages the persistence of sensitive authentication data (JWTs and User IDs)
 * using platform-specific secure storage (Keychain on iOS, Keystore on Android).
 *
 * Data Flow:
 * 1. Login/Registration:
 * - The AuthRepository  receives tokens from the remote API.
 * - It invokes `saveTokens` to persist credentials locally.
 *
 * 2. API Requests:
 * - The ApiClient  or Interceptors request the Access Token via `getAccessToken`
 * - This token is injected into the Authorization header (Bearer token).
 *
 * 3. Session Termination (Logout/Expiry):
 * - `clearTokens` is invoked to wipe all sensitive data, ensuring the user
 * cannot access protected routes until re-authentication.
 */

/// A service dedicated to the secure local storage of authentication credentials.
///
/// This class wraps [FlutterSecureStorage] to provide a simplified, type-safe API
/// for handling:
/// * Access Tokens (short-lived)
/// * Refresh Tokens (long-lived)
/// * User Identification
///
/// Usage:
/// Inject this service into your repositories (e.g., [AuthRepositoryImpl]) or
/// API clients to manage session state.
class TokenService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';


  /// Persists authentication credentials to secure storage.
  ///
  /// This operation is asynchronous and ensures all three critical pieces of
  /// session data are written before completing.
  ///
  /// * [access] - The short-lived JWT used for authorizing API requests.
  /// * [refresh] - The long-lived token used to renew the session.
  /// * [userId] - The unique identifier for the currently authenticated user.
  Future<void> saveTokens({required String access, required String refresh, required String userId}) async {
    await _storage.write(key: _accessTokenKey, value: access);
    await _storage.write(key: _refreshTokenKey, value: refresh);
    await _storage.write(key: _userIdKey, value: userId);
  }

  Future<String?> getUserId() async => await _storage.read(key: _userIdKey);

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  Future<String?> getRefreshToken() async => await _storage.read(key: _refreshTokenKey);

  Future<void> clearTokens() async {
    debugPrint('    --- CLEARING TOKENS Logout/refresh token expired button Pressed---');
    debugPrint('    User Id: $_userIdKey');
    debugPrint('    Refresh Token: $_refreshTokenKey');
    debugPrint('    Access Token: $_accessTokenKey');
    final userId = await getUserId();
    debugPrint('    --- CLEARING TOKENS ---');
    debugPrint('    Deleting User Id from local storage: $userId');

    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
      _storage.delete(key: _userIdKey),
    ]);

    debugPrint('    --- TOKENS cleared from local storage ---');
  }
}
