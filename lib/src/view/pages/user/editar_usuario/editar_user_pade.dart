import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_3/src/controller/editar_user_controller.dart';
import 'package:flutter_application_3/src/utils/my_color.dart';

class EditarUserPade extends StatefulWidget {
  const EditarUserPade({super.key});

  @override
  State<EditarUserPade> createState() => _EditarUserPadeState();
}

class _EditarUserPadeState extends State<EditarUserPade> {
  final EditarUserController _con = EditarUserController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context,refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:MyColor.primaryColor,
        title:const Text('Editar Perfil',
        style: TextStyle(
          color: Colors.white
        ),)
      ),
      body: SizedBox(
            width: double.infinity,
            //margin: EdgeInsets.only(top: 80),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
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
                    height: 20,
                  ),
                  // _texFielContrase(),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // _texFielConfirmar(),
                  _buttonRegistrar(),
                ],
              ),
            ),
      ),
    );
  }

  Widget _imageUser() {
    return GestureDetector(
      onTap:_con.showAlerDialog,
      child: CircleAvatar(
        backgroundImage: _con.imageFile != null
          ? FileImage(File(_con.imageFile!.path))
          :_con.user?.imagen !=null ?NetworkImage(_con.user!.imagen!)
          :const AssetImage('assets/img/user_profile.jfif'),
        radius: 60,
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

  Widget _buttonRegistrar() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 40,),
      child: Column(
        children: [
          ElevatedButton(
            onPressed:_con.isEnable? _con.actualizar:null,
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColor.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 50 ,vertical: 15),
            ),
            child: const Text('Actualizar Perfil',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void refresh(){
    setState(() {
      
    });
  }
}
