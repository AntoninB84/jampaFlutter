import 'dart:async';

import 'package:jampa_flutter/data/dao/user_dao.dart';
import 'package:jampa_flutter/utils/storage/secure_storage_service.dart';

import '../data/models/user/user.dart';

/// Repository class for managing user data and session.
class UserRepository {
  final SecureStorageService _secureStorage;
  UserEntity? _userEntity;

  UserRepository({SecureStorageService? secureStorage})
      : _secureStorage = secureStorage ?? SecureStorageService();

  /// Gets the current user from cache or database
  Future<UserEntity?> getCurrentUser() async {
    if (_userEntity != null) return _userEntity;

    final String? currentUserId = await _secureStorage.getUserId();

    if (currentUserId != null) {
      // Fetch user from the database using the stored user ID.
      _userEntity = await UserDao.getUserById(currentUserId);
      return _userEntity;
    }
    return null;
  }

  /// Saves the current user to the database and cache
  Future<void> saveCurrentUser(UserEntity user) async {
    await UserDao.saveSingleUser(user);
    await _secureStorage.saveUserId(user.id);
    _userEntity = user;
  }

  /// Disconnects the current user by removing the user ID from secure storage.
  Future<void> disconnectCurrentUser() async {
    _userEntity = null;
    // Note: User ID will be cleared by AuthRepository's clearAuthData
  }
}