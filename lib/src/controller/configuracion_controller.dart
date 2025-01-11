import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_3/src/model/configuracion.dart';
import 'package:flutter_application_3/src/model/paciente.dart';
import 'package:flutter_application_3/src/model/response_api.dart';
import 'package:flutter_application_3/src/model/user.dart';
import 'package:flutter_application_3/src/provider/configuracion_provider.dart';
import 'package:flutter_application_3/src/provider/push_notifications_provider.dart';
import 'package:flutter_application_3/src/provider/users_provider.dart';
import 'package:flutter_application_3/src/utils/my_snackbar.dart';
import 'package:flutter_application_3/src/utils/shared_pref.dart';
import 'package:flutter_application_3/src/view/pages/configuracion/configuracion_detalle_cliente_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ConfiguracionController {
  BuildContext? context;
  Function? refresh;
  TextEditingController afeccionController = TextEditingController();
  TextEditingController tiempomaximoController = TextEditingController();
  TextEditingController etapaController = TextEditingController();
  TextEditingController lenteController = TextEditingController();
  TextEditingController parcheController = TextEditingController();
  ValueNotifier<String?> messageNotifier = ValueNotifier<String?>(null);

  final ConfiguracionProvider _configuracionProvider =
      ConfiguracionProvider();
  User? user;
  SharedPref sharedPref = SharedPref();
  PushNotificationsProvider pushNotificationsProvider =
      PushNotificationsProvider();
  final UsersProvider _usersProvider = UsersProvider();

  List<Configuracion> configuracion = [];
  late Timer periodicTimer;

  Future<void> init(BuildContext context, void Function() refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await sharedPref.read('user') ?? {});
    print('QWER:$user');
    await _configuracionProvider.init(context, user!);
    await _usersProvider.init(context, useroriginal: user!);
    listarConfiguracion();
  }

  void gotoConfiguracion() {
    Navigator.pushNamed(context!, 'configuracion');
  }

  void gotoPaciente() {
    Navigator.pushNamed(context!, 'paciente');
  }

  void gotoTratamiento() {
    Navigator.pushNamed(context!, 'tratamiento');
  }

  void crear() async {
    String afeccion = afeccionController.text.trim();
    String etapa = etapaController.text.trim();
    bool parche = parcheController.text.trim().toLowerCase() == 'true';
    bool lente = lenteController.text.trim().toLowerCase() == 'true';
    String tiempoMaximoDia = tiempomaximoController.text.trim();

    Configuracion configuracion = Configuracion(
        tiempoMaximoDia: tiempoMaximoDia,
        afeccion: afeccion,
        etapa: etapa,
        lente: lente,
        parche: parche);

    if (tiempoMaximoDia.isEmpty || afeccion.isEmpty) {
      MySnackbar.show(context!, 'Debe ingresar todos los datos');
      return;
    }

    ResponseApi? responseApi =
        await _configuracionProvider.createConfiguracion(configuracion);
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
        gotoConfiguracion();
      } else {
        MySnackbar.show(context!, responseApi.msg!);
      }
    } // Muestra el mensaje de respuesta
  }

  void modificar(Configuracion configuracion) async {
    String afeccion = afeccionController.text.trim();
    String tiempoMaximoDia = tiempomaximoController.text.trim();
    String etapa = etapaController.text.trim();
    bool parche = parcheController.text.trim().toLowerCase() == 'true';
    bool lente = lenteController.text.trim().toLowerCase() == 'true';
    configuracion = Configuracion(
        idConfiguracion: configuracion.idConfiguracion,
        afeccion: afeccion.isNotEmpty ? afeccion : configuracion.afeccion,
        etapa: etapa.isNotEmpty ? etapa : configuracion.etapa,
        tiempoMaximoDia: tiempoMaximoDia.isNotEmpty
            ? tiempoMaximoDia
            : configuracion.tiempoMaximoDia,
        lente: lente,
        parche: parche,
        idPaciente: configuracion.idPaciente);

    print('Respuesta4:${configuracion.toJson()}');

    ResponseApi? responseApi =
        await _configuracionProvider.modificarConfiguracion(configuracion);
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
        gotoConfiguracion();
      } else {
        MySnackbar.show(context!, responseApi.msg!);
      }
    }
  }

  void removeAt(Configuracion configuracion) async {
    ResponseApi? responseApi =
        await _configuracionProvider.eliminarConfiguracion(configuracion);
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
        listarConfiguracion();
      } else {
        MySnackbar.show(context!, responseApi.msg!);
      }
    }
  }

  void listarConfiguracion() async {
    configuracion = await _configuracionProvider.listarConfiguracion();
    refresh!();
  }

  void listarConfiguracionCliente(Paciente paciente) async {
    List<Configuracion> configuracion =
        await _configuracionProvider.listarClienteConfiguracion(paciente);
    if (refresh == null) {
      Fluttertoast.showToast(msg: 'refresh no disponible');
      return; // Salir si no hay contexto
    }
    if(configuracion.isEmpty){
          return  MySnackbar.show(context!, 'Configuracion no encontrado para el paciente');
        }
    seleccionarConfiguracionClien(configuracion);
  }

  void seleccionarConfiguracionClien(List<Configuracion> configuracion) {
    if (context == null) {
      Fluttertoast.showToast(msg: 'Contexto no disponible');
      return; // Salir si no hay contexto
    }
    Navigator.push(
        context!,
        MaterialPageRoute(
          builder: (context) =>
              ConfiguracionDetalleClientePage(configuracion: configuracion),
        ));
  }

  Future<void> notificarPorFecha(List<Configuracion> configuracion) async {
    for (var item in configuracion) {
      // Iniciar la comprobación periódica
      _sendNotificationHistorial(item);
    }
  }

  Future<void> _sendNotificationHistorial(Configuracion item) async {
    User? myUser = await _usersProvider.getUser(user!.id!);
    print('Enviando notificación para el ID del paciente: ${myUser?.id}');

    DateTime maxTime = _parseTime(item.tiempoMaximoDia!);

    // Calcular la hora exacta en la que se debe enviar la notificación
    DateTime notificationTime = DateTime.now()
        .add(Duration(hours: maxTime.hour, minutes: maxTime.minute));

    // Esperar hasta que sea la hora de la notificación
    periodicTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      print('Noti:$notificationTime');
      if (DateTime.now().isAfter(notificationTime)) {
        periodicTimer
            .cancel(); // Cancelar el timer cuando se cumple la condición
        sendNotification(myUser!.notificationToken!, item.tiempoMaximoDia!);
      }
    });
  }

  DateTime _parseTime(String timeString) {
    final parts = timeString.split(':');
    final now = DateTime.now();
    
    // Asegurarse de que solo usamos horas y minutos
    int hours = parts.isNotEmpty ? int.parse(parts[0]) : 0;
    int minutes = parts.length > 1 ? int.parse(parts[1]) : 0;
    
    DateTime parsedTime = DateTime(
        now.year, 
        now.month, 
        now.day,
        hours,
        minutes,
        0  // Segundos fijos en 0
    );
    
    print('Parsed time: $parsedTime');
    return parsedTime;
  }

  void sendNotification(String token, String tiempoMaximoDia) async {
    Map<String, dynamic> data = {'click_action': 'FLUTTER_NOTIFICATION_CLICK'};
    print('Sending notification to token: $token');
    pushNotificationsProvider.sendMessage(
        token,
        data,
        'Hora de descansar del celular',
        'Descanse cuide sus ojos ya cumplio la hora recomendada: $tiempoMaximoDia');
    gotoPaciente();
  }
}
