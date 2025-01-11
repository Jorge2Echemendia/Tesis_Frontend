import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_3/src/controller/login_controller.dart';
import 'package:flutter_application_3/src/utils/my_color.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController _con = LoginController();

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
          top: -60,
          left: -100,
          child: _circleLogin()
          ),
          Positioned(
            top: 60,
            left: 20,
            child: _textLoging(),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _animaTion(),
                  const SizedBox(height: 1),
                  _texFieliEmail(),
                  const SizedBox(height: 20),
                  _texFielContrase(),
                  _buttonLogin(),
                  _textOlvidoPassword(),
                  const SizedBox(height: 5),
                  _textDontHavenAccount(),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }


  Widget _animaTion() {
    return Container(
      margin: EdgeInsets.only(
          top: 104,
          left: 80,
          bottom: MediaQuery.of(context).size.height * 0.05),
      child: Lottie.asset('assets/json/login.json',
          width: 270, height: 290, fit: BoxFit.fill),
    );
  }

  Widget _textLoging() {
    return const Text(
      'LOGIN',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 22,
        fontFamily: 'NimbusSans',
      ),
    );
  }

  Widget _textDontHavenAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'No tienes cuenta?',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: MyColor.primaryColor),
        ),
        const SizedBox(height: 7, width: 7),
        const Icon(Icons.arrow_forward),
        GestureDetector(
          onTap: _con.gotoRegisterPage,
          child: Text(
            'Registrate',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: MyColor.primaryColor),
          ),
        ),
      ],
    );
  }

    Widget _textOlvidoPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Olvido su contraseña?',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: MyColor.primaryColor),
        ),
        const SizedBox(height: 7, width: 7),
        const Icon(Icons.arrow_forward),
        GestureDetector(
          onTap: _con.gotoOlvide,
          child: Text(
            'Cambiela',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: MyColor.primaryColor),
          ),
        ),
      ],
    );
  }

  Widget _buttonLogin() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 70, vertical: 30),
      child: ElevatedButton(
          onPressed:_con.login,
          style: ElevatedButton.styleFrom(
            backgroundColor: MyColor.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
          child: const Text(
            'Ingresar',
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  Widget _texFielContrase() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(
          color: MyColor.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _con.passwordController,
        obscureText:true,
        decoration: InputDecoration(
            hintText: 'Contraseña',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
            hintStyle: TextStyle(color: MyColor.primaryColorDark),
            prefixIcon: Icon(Icons.lock, color: MyColor.primaryColor)),
      ),
    );
  }

  Widget _texFieliEmail() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(
          color: MyColor.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _con.emailController,
        keyboardType:TextInputType.emailAddress ,
        decoration: InputDecoration(
            hintText: 'email Elecctronico',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
            hintStyle: TextStyle(color: MyColor.primaryColorDark),
            prefixIcon: Icon(Icons.email, color: MyColor.primaryColor)),
      ),
    );
  }

  Widget _circleLogin() {
    return Container(
      width: 230,
      height: 210,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(150),
        color: MyColor.primaryColor,
      ),
    );
  }
}
