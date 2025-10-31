import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? user;
  String? token;
  bool loading = false;

  Future<Map<String, dynamic>> login(String email, String password) async {
    loading = true;
    notifyListeners();

    final res = await ApiService.login(email, password);

    loading = false;
    if (res['success']) {
      token = res['data']['token'];
      user = UserModel.fromJson(res['data']['user']);
      notifyListeners();
    }
    notifyListeners();
    return res;
  }

  void logout() {
    token = null;
    user = null;
    notifyListeners();
  }
}
