import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_3/src/controller/register_controller.dart';
import 'package:flutter_application_3/src/utils/my_color.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final RegisterController _con = RegisterController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Stack(children: [
          Positioned(top: -60, left: -100, child: _circle()),
          Positioned(
            top: 60,
            left: 18,
            child: _textRegister(),
          ),
          Positioned(
            top: 47,
            left: -10,
            child: _iconBack(),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 80),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _imageUser(),
                  const SizedBox(
                    height: 30,
                  ),
                  _texFieliEmail(),
                  const SizedBox(
                    height: 10,
                  ),
                  _texFieliName(),
                  const SizedBox(
                    height: 10,
                  ),
                  _texFielApellido(),
                  const SizedBox(
                    height: 10,
                  ),
                  _texFielTelefono(),
                  const SizedBox(
                    height: 10,
                  ),
                  _texFielContrase(),
                  const SizedBox(
                    height: 10,
                  ),
                  _texFielConfirmar(),
                  const SizedBox(
                    height: 10,
                  ),
                  _buttonRegistrar(),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _imageUser() {
    return GestureDetector(
      onTap: _con.showAlerDialog,
      child: CircleAvatar(
        backgroundImage: _con.imageFile != null
            ? FileImage(File(_con.imageFile!.path))
            : const AssetImage('assets/img/user_profile.jfif'),
        radius: 60,
      ),
    );
  }

  Widget _circle() {
    return Container(
      width: 230,
      height: 210,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(150),
        color: MyColor.primaryColor,
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
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            hintText: 'email Elecctronico',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
            hintStyle: TextStyle(color: MyColor.primaryColorDark),
            prefixIcon: Icon(Icons.email, color: MyColor.primaryColor)),
      ),
    );
  }

  Widget _texFieliName() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(
          color: MyColor.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _con.nameController,
        decoration: InputDecoration(
            hintText: 'Nombre',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
            hintStyle: TextStyle(color: MyColor.primaryColorDark),
            prefixIcon: Icon(Icons.person, color: MyColor.primaryColor)),
      ),
    );
  }

  Widget _texFielApellido() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(
          color: MyColor.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _con.lastnameController,
        decoration: InputDecoration(
            hintText: 'Apellido',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
            hintStyle: TextStyle(color: MyColor.primaryColorDark),
            prefixIcon:
                Icon(Icons.person_outlined, color: MyColor.primaryColor)),
      ),
    );
  }

  Widget _texFielTelefono() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(
          color: MyColor.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _con.phoneController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            hintText: 'Telefono',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
            hintStyle: TextStyle(color: MyColor.primaryColorDark),
            prefixIcon: Icon(Icons.phone, color: MyColor.primaryColor)),
      ),
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
        obscureText: true,
        decoration: InputDecoration(
            hintText: 'Contraseña',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
            hintStyle: TextStyle(color: MyColor.primaryColorDark),
            prefixIcon: Icon(Icons.lock, color: MyColor.primaryColor)),
      ),
    );
  }

  Widget _texFielConfirmar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(
          color: MyColor.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _con.confirmPasswordController,
        obscureText: true,
        decoration: InputDecoration(
            hintText: 'Confirmar',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
            hintStyle: TextStyle(color: MyColor.primaryColorDark),
            prefixIcon: Icon(Icons.lock_outline, color: MyColor.primaryColor)),
      ),
    );
  }

  Widget _buttonRegistrar() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 70, vertical: 30),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: _con.isEnable ? _con.register : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColor.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: const Text(
              'Registrarse',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }


  Widget _iconBack() {
    return IconButton(
        onPressed: _con.gotoHomePage,
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white));
  }

  Widget _textRegister() {
    return const Row(
      children: [
        Text(
          'REGISTRO',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 19,
            fontFamily: 'NimbusSans',
          ),
        ),
      ],
    );
  }

  void refresh() {
    setState(() {});
  }
}
