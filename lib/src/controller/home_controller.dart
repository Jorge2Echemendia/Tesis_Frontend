import 'package:flutter/material.dart';

class HomeController {
  BuildContext? context;

  Future<void>? init(BuildContext context) {
    this.context = context;
    return null;
  }

  void gotoLoginPage() {
    Navigator.pushNamed(context!, 'login');
  }

  void gotoRegisterPage() {
    Navigator.pushNamed(context!, 'register');
  }
}
