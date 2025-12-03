import 'dart:async';

import 'package:jampa_flutter/data/dao/user_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/user/user.dart';

/// Repository class for managing user data and session.
class UserRepository {
  UserEntity? _userEntity;

  /// Saves the current user and persists the user ID in shared preferences.
  Future<UserEntity?> getCurrentUser() async {
    if (_userEntity != null) return _userEntity;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? currentUserId = prefs.getString('CURRENT_USER_ID');

    if(currentUserId != null){
      // Fetch user from the database using the stored user ID.
      return await UserDao.getUserById(currentUserId);
    }
    return null;
  }

  /// Disconnects the current user by removing the user ID from shared preferences.
  Future<void> disconnectCurrentUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('CURRENT_USER_ID');
    _userEntity = null;
  }
}