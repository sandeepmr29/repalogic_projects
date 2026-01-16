import 'package:flutter/material.dart';
import 'package:repalogic_loginapp/model/user.dart';
import '../data/user_repository.dart';


class AuthViewModel extends ChangeNotifier {
  final UserRepository _repo = UserRepository();

  bool isLoading = false;
  String? message;

  Future<void> register(String name, String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      await _repo.register(
        User(name: name, email: email, password: password),
      );

      message = 'Registration successful';
    } catch (e) {
      message = 'User already exists';
    }

    isLoading = false;
    notifyListeners();
  }


  Future<bool> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

   bool result = await _repo.login(email, password);
if(result)
  {
    message = 'Login successful';
  }
else{
  message = 'Login Failed';
}
    isLoading = false;
    notifyListeners();

    return result;
  }
}
