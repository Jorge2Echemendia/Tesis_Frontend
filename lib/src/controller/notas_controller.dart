import 'package:flutter/material.dart';
import 'package:flutter_application_3/src/model/notas.dart';
import 'package:flutter_application_3/src/model/paciente.dart';
import 'package:flutter_application_3/src/model/response_api.dart';
import 'package:flutter_application_3/src/provider/notas_provider.dart';
import 'package:flutter_application_3/src/utils/my_snackbar.dart';
import 'package:flutter_application_3/src/view/pages/notas/notas_paciente.dart';

import '../model/user.dart';
import '../utils/shared_pref.dart';

class NotasController {
  BuildContext? context;
  Function? refresh;

  TextEditingController nombreController = TextEditingController();
  TextEditingController motivoController = TextEditingController();
  TextEditingController contenidoController = TextEditingController();
  TextEditingController frecuenciaController = TextEditingController();
  TextEditingController horaProgramadaController = TextEditingController();
  TextEditingController tiempoMaximoController = TextEditingController();
  TextEditingController recordatorioController = TextEditingController();
  TextEditingController recordatorioContinuoController =
      TextEditingController();

  ValueNotifier<String?> messageNotifier = ValueNotifier<String?>(null);

  final NotasProvider _notasProvider = NotasProvider();
  User? user;
  SharedPref sharedPref = SharedPref();
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  List<Notas> notas = [];

  Future<void> init(BuildContext context, void Function() refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await sharedPref.read('user') ?? {});
    await _notasProvider.init(context, user!);
  }

  void gotoNotas() {
    Navigator.pushNamed(context!, 'notas');
  }

  void gotoPaciente() {
    Navigator.pushNamed(context!, 'paciente');
  }

  void crearNota(Paciente paciente) async {
    String nombreDeNotas = nombreController.text.trim();
    String motivo = motivoController.text.trim();
    String contenido = contenidoController.text.trim();
    String frecuenciaStr = frecuenciaController.text.trim();
    int frecuencia = frecuenciaStr.isEmpty ? 1 : int.parse(frecuenciaStr);
    String? tiempoMaximoDia = tiempoMaximoController.text.isEmpty
        ? null
        : tiempoMaximoController.text.trim();
    String trimmedDate = horaProgramadaController.text.trim();
    DateTime horaProgramada;
    if (trimmedDate.isEmpty) {
      trimmedDate = DateTime.now().toIso8601String();
    }
    horaProgramada = DateTime.parse(trimmedDate);
    bool recordatorio =
        recordatorioController.text.trim().toLowerCase() == 'true';
    bool recordatorioContinuo =
        recordatorioContinuoController.text.trim().toLowerCase() == 'true';

    Notas notas = Notas(
        nombreDeNotas: nombreDeNotas,
        motivo: motivo,
        contenido: contenido,
        frecuencia: frecuencia,
        horaProgramada: horaProgramada,
        tiempoMaximoDia: tiempoMaximoDia,
        recordatorio: recordatorio,
        recordatorioContinuo: recordatorioContinuo);

    ResponseApi? responseApi = await _notasProvider.create(notas, paciente);
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
        listarNotas(paciente);
        gotoNotas();
      } else {
        MySnackbar.show(context!, responseApi.msg!);
      }
    } // Muestra el mensaje de respuesta
  }

  void remove(Notas notas, Paciente paciente) async {
    ResponseApi? responseApi = await _notasProvider.eliminar(notas);
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
        listarNotas(paciente);
      } else {
        MySnackbar.show(context!, responseApi.msg!);
      }
    }
  }

  void modificar(Notas notas,Paciente paciente) async {
    String nombreDeNotas = nombreController.text.trim();
    String motivo = motivoController.text.trim();
    String contenido = contenidoController.text.trim();
    String frecuenciaStr = frecuenciaController.text.trim();
    int frecuencia = frecuenciaStr.isEmpty ? 1 : int.parse(frecuenciaStr);
    String tiempoMaximoDia = tiempoMaximoController.text.trim();
    String trimmedDate = horaProgramadaController.text.trim();
    DateTime horaProgramada;
    if (trimmedDate.isEmpty) {
      trimmedDate = DateTime.now().toIso8601String();
    }
    horaProgramada = DateTime.parse(trimmedDate);
    bool recordatorio =
        recordatorioController.text.trim().toLowerCase() == 'true';
    bool recordatorioContinuo =
        recordatorioContinuoController.text.trim().toLowerCase() == 'true';

    notas = Notas(
      idNotas: notas.idNotas,
      nombreDeNotas:
          nombreDeNotas.isNotEmpty ? nombreDeNotas : notas.nombreDeNotas,
      motivo: motivo.isNotEmpty ? motivo : notas.motivo,
      contenido: contenido.isNotEmpty ? contenido : notas.contenido,
      frecuencia:
          frecuencia.toString().isNotEmpty ? frecuencia : notas.frecuencia,
      horaProgramada: horaProgramada,
      tiempoMaximoDia: tiempoMaximoDia.toString().isNotEmpty
          ? tiempoMaximoDia
          : notas.tiempoMaximoDia,
      recordatorio: recordatorio,
      recordatorioContinuo: recordatorioContinuo,
      idPaciente: notas.idPaciente,
      idUsuario: notas.idUsuario,
    );

    ResponseApi? responseApi = await _notasProvider.modificar(notas);
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
        listarNotas(paciente);
        gotoNotas();
      } else {
        MySnackbar.show(context!, responseApi.msg!);
      }
    }
  }

  void listarNotas(Paciente paciente) async {
    notas = await _notasProvider.listar(paciente);
    refresh!();
    seleccionarNotas(notas, paciente);
  }

  void seleccionarNotas(
    List<Notas> notas,
    Paciente paciente,
  ) {
    Navigator.push(
        context!,
        MaterialPageRoute(
          builder: (context) => NotasPaciente(
            notas: notas,
            paciente: paciente,
          ),
        ));
  }
}
