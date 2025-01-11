import 'package:flutter/material.dart';
import 'package:flutter_application_3/src/model/response_api.dart';
import 'package:flutter_application_3/src/model/user.dart';
import 'package:flutter_application_3/src/provider/push_notifications_provider.dart';
import 'package:flutter_application_3/src/provider/users_provider.dart';
import 'package:flutter_application_3/src/utils/my_snackbar.dart';
import 'package:flutter_application_3/src/utils/shared_pref.dart';

class LoginController {
  BuildContext? context;
  TextEditingController nombreController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  UsersProvider usersProvider = UsersProvider();
  final SharedPref _sharedPref = SharedPref();
  User? user;
  PushNotificationsProvider pushNotificationsProvider =
      PushNotificationsProvider();

  Future<void>? init(BuildContext context) async {
    this.context = context;

    User user = User.fromJson(await _sharedPref.read('user') ?? {});
    await usersProvider.init(context,useroriginal: user);

    if (user.token != null) {
       pushNotificationsProvider.saveToken(context,user);
      if (user.tipoUsuario!.contains('doctor')) {
        gotoTratamientoPage();
      } else {
        gotoPacientePage();
      }
    }
  }

  void gotoRegisterPage() {
    Navigator.pushNamed(context!, 'register');
  }

  void gotoHomePage() {
    Navigator.pushNamed(context!, 'home');
  }

    void gotoOlvide() {
    Navigator.pushNamed(context!, 'olvidepassword');
  }

  void gotoPacientePage() {
    Navigator.pushNamedAndRemoveUntil(context!, 'paciente', (route) => false);
  }

  void gotoTratamientoPage() {
    Navigator.pushNamedAndRemoveUntil(
        context!, 'tratamiento', (route) => false);
  }

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      MySnackbar.show(context!, 'Debe ingresar todos los datos');
      return;
    }

    bool isValidEmail(String? email) {
      RegExp regex = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
      return regex.hasMatch(email ?? '');
    }

    if (!isValidEmail(email)) {
      MySnackbar.show(
        context!,
        'Por favor ingrese un email electrónico válido',
      );
      return;
    }

    if (password.length < 8) {
      MySnackbar.show(context!, 'Debe tener al menos 8 caracteres');
      return;
    }
    ResponseApi? responseApi = await usersProvider.login(email, password);
    if (responseApi != null) {
      if (responseApi.success == false) {
        MySnackbar.show(context!, responseApi.msg!);
      } else {
        String text = responseApi.msg!;
        FocusScope.of(context!).requestFocus(FocusNode());

        ScaffoldMessenger.of(context!).removeCurrentSnackBar();
        ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
          content: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ));

        if (responseApi.data != null) {
          User user = User.fromJson(responseApi.data);
          _sharedPref.save('user', user.toJson());
          pushNotificationsProvider.saveToken(context!,user);


          print(user.toJson());

          if (user.tipoUsuario!.contains('doctor')) {
            print('Token:${user.toJson()}');
            gotoTratamientoPage();
          } else {
            pushNotificationsProvider.saveToken(context!,user);
            FocusScope.of(context!).unfocus();
            gotoPacientePage();
          }
        } else {
          // Handle the case where data is null
          MySnackbar.show(context!, 'No data received from the server.');
        }
      } // Muestra el mensaje de respuesta
    }
  }

    void cambiarPassword() async {
    String nombre=nombreController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (nombre.isEmpty||email.isEmpty || password.isEmpty||confirmPassword.isEmpty) {
      MySnackbar.show(context!, 'Debe ingresar todos los datos');
      return;
    }

        if (password != confirmPassword) {
      MySnackbar.show(context!, 'Las contraseñas no coinciden');
      return;
    }

    bool isValidEmail(String? email) {
      RegExp regex = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
      return regex.hasMatch(email ?? '');
    }

    if (!isValidEmail(email)) {
      MySnackbar.show(
        context!,
        'Por favor ingrese un email electrónico válido',
      );
      return;
    }

    if (password.length < 8) {
      MySnackbar.show(context!, 'Debe tener al menos 8 caracteres');
      return;
    }
    ResponseApi? responseApi = await usersProvider.cambiarPassword(nombre,email, password);
    if (responseApi != null) {
      if (responseApi.success == false) {
        MySnackbar.show(context!, responseApi.msg!);
      } else {
        String text = responseApi.msg!;
        FocusScope.of(context!).requestFocus(FocusNode());

        ScaffoldMessenger.of(context!).removeCurrentSnackBar();
        ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
          content: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ));
        if (responseApi.data != null) {
            gotoHomePage();
        } else {
          // Handle the case where data is null
          MySnackbar.show(context!, 'No data received from the server.');
        }
      } // Muestra el mensaje de respuesta
    }
  }
}
