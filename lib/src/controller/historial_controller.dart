import 'package:flutter/material.dart';
import 'package:flutter_application_3/src/model/historial_de_notas.dart';
import 'package:flutter_application_3/src/model/historial_de_tratamiento.dart';
import 'package:flutter_application_3/src/model/paciente.dart';
import 'package:flutter_application_3/src/model/user.dart';
import 'package:flutter_application_3/src/provider/historial_provider.dart';
import 'package:flutter_application_3/src/provider/notas_provider.dart';
import 'package:flutter_application_3/src/utils/shared_pref.dart';
import 'package:flutter_application_3/src/view/pages/historial/historial_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HistorialController {
  BuildContext? context;
  Function? refresh;

  ValueNotifier<String?> messageNotifier = ValueNotifier<String?>(null);

  final HistorialProvider _historialProvider = HistorialProvider();
  final NotasProvider _notasProvider = NotasProvider();
  User? user;
  SharedPref sharedPref = SharedPref();

  List<Historial> historial = [];
  List<HistorialNotas> historialNotas = [];

  Future<void> init(BuildContext context, void Function() refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await sharedPref.read('user') ?? {});
    await _historialProvider.init(context, user!);
  }

  void listarHistorialClien(Paciente paciente) async {
    if (refresh == null || context == null) {
      Fluttertoast.showToast(msg: 'No se puede refrescar o no hay contexto');
      return;
    }
    List<Historial> historial =
        await _historialProvider.listarHistorial(paciente);
    List<HistorialNotas> historialNotas = await _notasProvider.listarHistorial(paciente);
    seleccionarHistoriaClien(historial,historialNotas);
  }

  void seleccionarHistoriaClien(List<Historial> historial,List<HistorialNotas> historialNotas) {
    if (context == null) {
      Fluttertoast.showToast(msg: 'No hay contexto disponible');
      return;
    }
    Navigator.push(
      context!,
      MaterialPageRoute(
        builder: (context) => HistorialPage(historial: historial,historialNotas:historialNotas),
      ),
    );
  }
}
