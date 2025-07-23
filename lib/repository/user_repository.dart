import 'dart:async';

import 'package:jampa_flutter/data/dao/user_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/user.dart';

class UserRepository {
  UserEntity? _userEntity;

  Future<UserEntity?> getCurrentUser() async {
    if (_userEntity != null) return _userEntity;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? currentUserId = prefs.getInt('CURRENT_USER_ID');

    if(currentUserId != null){
      return await UserDao.getUserById(currentUserId);
    }
    return null;
  }

  Future<void> disconnectCurrentUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('CURRENT_USER_ID');
    _userEntity = null;
  }
}