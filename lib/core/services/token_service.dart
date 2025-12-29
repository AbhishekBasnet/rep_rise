import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';

  Future<void> saveTokens({required String access, required String refresh,required String userId}) async {
    await _storage.write(key: _accessTokenKey, value: access);
    await _storage.write(key: _accessTokenKey, value: refresh);
    await _storage.write(key: _userIdKey, value: userId);
  }

  Future<String?> getUserId() async => await _storage.read(key: _userIdKey);

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  Future<String?> getRefreshToken() async => await _storage.read(key: _refreshTokenKey);

  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _userIdKey);
  }


}