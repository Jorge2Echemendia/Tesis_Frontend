import 'package:flutter/material.dart';
import 'package:flutter_application_3/src/model/response_api.dart';
import 'package:flutter_application_3/src/model/user.dart';
import 'package:flutter_application_3/src/provider/users_provider.dart';
import 'package:flutter_application_3/src/utils/my_snackbar.dart';
import 'package:flutter_application_3/src/utils/shared_pref.dart';
import 'package:provider/provider.dart';

class ConfirmarController {
  BuildContext? context;
  User? user;

  ValueNotifier<String?> messageNotifier = ValueNotifier<String?>(null);

  UsersProvider usersProvider = UsersProvider();
  Future<void>? init(BuildContext context) async {
    this.context = context;
    SharedPref sharedPref = SharedPref();
    User user = User.fromJson(await sharedPref.read('user') ?? {});
    await usersProvider.init(context,useroriginal: user);
  }

  void gotoHomePage() {
    Navigator.pushNamed(context!, 'home');
  }

  void confirmar() async {
    final usersProvider = Provider.of<UsersProvider>(context!, listen: false);
    ResponseApi? responseApi = await usersProvider.getConfirmar();
    if (responseApi != null) {
      if (responseApi.success == true) {
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
        gotoHomePage();
      } else {
        MySnackbar.show(context!, responseApi.msg!);
      }
    }
    print('Respuesta:${responseApi?.toJson()}');
    //gotoHomePage();
  }
}
