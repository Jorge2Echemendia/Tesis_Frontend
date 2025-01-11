import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_3/connection_manager.dart';
import 'package:flutter_application_3/src/controller/home_controller.dart';
import 'package:flutter_application_3/src/utils/my_color.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _con = HomeController();

  @override
  void initState() {
    super.initState();
    ConnectionManager().checkAndShowAlert(context);
    refresh();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context);
    });
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColor.primaryOpacityColor,
          title: const Text(
            'Bienvenido a su oftalmólogo',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              Positioned(top: -80, left: -100, child: _circleHome()),
              Positioned(top: 40, left: 20, child: _textHome()),
              SingleChildScrollView(
                child: Column(
                  children: [
                    _animaTion(),
                    _buttonLogin(),
                    const SizedBox(height: 10),
                    _buttonRegister(),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _animaTion() {
    return Container(
      margin: EdgeInsets.only(
          top: 54, left: 30, bottom: MediaQuery.of(context).size.height * 0.05),
      child: Lottie.asset('assets/json/normal.json',
          width: 330, height: 290, fit: BoxFit.fill),
    );
  }

  Widget _buttonLogin() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 70),
      child: ElevatedButton(
          onPressed: _con.gotoLoginPage,
          style: ElevatedButton.styleFrom(
            backgroundColor: MyColor.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
          child: const Text(
            'Iniciar Sesión',
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  Widget _buttonRegister() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 70),
      child: ElevatedButton(
          onPressed: _con.gotoRegisterPage,
          style: ElevatedButton.styleFrom(
            backgroundColor: MyColor.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
          child: const Text(
            'Registrar',
            style: TextStyle(color: Colors.white),
          )),
    );
  }
}

Widget _circleHome() {
  return Container(
    width: 230,
    height: 210,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(150),
      color: MyColor.primaryColor,
    ),
  );
}

Widget _textHome() {
  return Container(
    child: const Row(
      children: [
        Text(
          'HOME',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 26,
            fontFamily: 'NimbusSans',
          ),
        ),
      ],
    ),
  );
}
