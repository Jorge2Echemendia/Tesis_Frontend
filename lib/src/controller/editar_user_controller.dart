import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_3/src/model/response_api.dart';
import 'package:flutter_application_3/src/model/user.dart';
import 'package:flutter_application_3/src/provider/users_provider.dart';
import 'package:flutter_application_3/src/utils/my_snackbar.dart';
import 'package:flutter_application_3/src/utils/shared_pref.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class EditarUserController {
  BuildContext? context;
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  UsersProvider usersProvider = UsersProvider();
  PickedFile? pickedFile;
  File? imageFile;
  Function? refresh;
  ProgressDialog? _progressDialog;
  bool isEnable = true;
  User? user;
  final SharedPref _sharedPref = SharedPref();
  String? emailoriginal;

  Future<void>? init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    User user = User.fromJson(await _sharedPref.read('user') ?? {});
    print('ID:${user.toJson()}');
    await usersProvider.init(context, useroriginal: user);
    _progressDialog = ProgressDialog(context: context);
    user = User.fromJson(await _sharedPref.read('user'));
    nameController.text = user.nombre!;
    lastnameController.text = user.apellido!;
    phoneController.text = user.telefono!;
    emailController.text = user.email!;
    refresh();
  }

  

  void actualizar() async {
    String email = emailController.text.trim();
    String name = nameController.text.trim();
    String lastname = lastnameController.text.trim();
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();

    if (!RegExp(r'^\d+$').hasMatch(phone)) {
      MySnackbar.show(context!, 'El teléfono debe contener solo números');
      return;
    }

    if (phone.length != 8) {
      MySnackbar.show(context!, 'El teléfono debe tener exactamente 8 dígitos');
      return;
    }

    _progressDialog?.show(max: 100, msg: 'Espere un momento...');
    isEnable = false;
    user = User.fromJson(await _sharedPref.read('user'));

    User myUser = User(
        id: user?.id,
        nombre: name,
        apellido: lastname,
        email: email,
        password: password,
        telefono: phone,
        imagen: imageFile == null ? user?.imagen : null,
        token: '',
        tipoUsuario: '');

    try {
      final response = await Provider.of<UsersProvider>(context!, listen: false)
          .update(myUser, imageFile);
      ResponseApi? responseApi;
      String? token;

      response.listen((data) async {
        _progressDialog?.close();
        token = data['token'];
        if (data['responseApi'] is ResponseApi) {
          responseApi = data['responseApi'];
        } else {
          // Manejar el caso donde no es un Map
          MySnackbar.show(
              context!, 'Error:responseApi no es del tipo esperado');
          return;
        }

        if (responseApi != null && responseApi!.success == true) {
          String text = responseApi!.msg!;
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
          if (myUser.email == user!.email) {
            user = await usersProvider.getUser(myUser.id!);
            _sharedPref.save('user', user?.toJson());

            gotoLogin();
            refresh!();
          } else {
            user = await usersProvider.getUser(myUser.id!);
            _sharedPref.save('user', user?.toJson());
            gotoConfirmar();
          }
        } else {
          MySnackbar.show(
              context!, responseApi?.msg ?? 'An unknown error occurred');
          isEnable = true;
        }
      });
        } catch (e) {
      _progressDialog?.close();
      MySnackbar.show(context!, 'Error al actualizar el usuario: $e');
      isEnable = true;
    }
  }

// Muestra el mensaje de respuesta

  Future selectImage(ImageSource imageSource) async {
    var pickedFile = await ImagePicker().pickImage(source: imageSource);

    if (pickedFile != null) {
      pickedFile = pickedFile as XFile?;
      imageFile = File(pickedFile!.path);
    }
    Navigator.pop(context!);
    refresh!();
  }

  void showAlerDialog() {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.gallery);
        },
        child: const Text('Galeria'));

    Widget cameraButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.camera);
        },
        child: const Text('Camara'));

    AlertDialog alertDialog = AlertDialog(
      title: const Text('Selecciona tu imagen'),
      actions: [galleryButton, cameraButton],
    );
    showDialog(
        context: context!,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  void back() {
    Navigator.pop(context!);
  }

  void gotoConfirmar() {
    Navigator.pushNamed(context!, 'confirmar');
  }

  void gotoLogin() {
    Navigator.pushNamed(context!, 'login');
  }
}
