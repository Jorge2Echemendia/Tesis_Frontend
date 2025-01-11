import 'package:flutter/material.dart';
import 'package:flutter_application_3/src/model/historial_de_tratamiento.dart';
import 'package:flutter_application_3/src/model/paciente.dart';
import 'package:flutter_application_3/src/model/response_api.dart';
import 'package:flutter_application_3/src/model/tratamiento.dart';
import 'package:flutter_application_3/src/model/user.dart';
import 'package:flutter_application_3/src/provider/historial_provider.dart';
import 'package:flutter_application_3/src/provider/push_notifications_provider.dart';
import 'package:flutter_application_3/src/provider/tratamiento_provider.dart';
import 'package:flutter_application_3/src/provider/users_provider.dart';
import 'package:flutter_application_3/src/utils/my_snackbar.dart';
import 'package:flutter_application_3/src/utils/shared_pref.dart';
import 'package:flutter_application_3/src/view/pages/tratamiento/tratamiento_detalle_cliente_page.dart';
import 'package:flutter_application_3/src/view/pages/tratamiento/tratamiento_detalle_page.dart';

class TratamientoController {
  BuildContext? context;
  Function? refresh;
  TextEditingController nombreTratamientoController =
      TextEditingController();
  TextEditingController nombreMedicamentoController =
      TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  TextEditingController frecuenciaController = TextEditingController();
  TextEditingController horaProgramadaController = TextEditingController();
  TextEditingController tiempoDeLaMedicacionController =
      TextEditingController();
  TextEditingController etapaController = TextEditingController();
  TextEditingController lenteController = TextEditingController();
  TextEditingController parcheController = TextEditingController();

  final TratamientoProvider _tratamientoProvider = TratamientoProvider();
  User? user;
  Historial? historial;
  final HistorialProvider _historialProvider = HistorialProvider();
  PushNotificationsProvider pushNotificationsProvider =
      PushNotificationsProvider();
  final UsersProvider _usersProvider = UsersProvider();
  SharedPref sharedPref = SharedPref();
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  List<Tratamiento> tratamiento = [];
  List<Tratamiento> tratamientoActualizado = [];

  Future<void> init(BuildContext context, void Function() refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await sharedPref.read('user') ?? {});
    await _tratamientoProvider.init(context, user!);
    await _historialProvider.init(context, user!);
    await _usersProvider.init(context, useroriginal: user!);
    pushNotificationsProvider.initNotification();
    listarTratamientoAdmin();
  }

  void gotoTratamiento() {
    Navigator.pushNamed(context!, 'tratamiento');
    listarTratamientoAdmin();
  }

  void gotoConfiguracion() {
    Navigator.pushNamed(context!, 'configuracion');
  }

  void gotoPaciente() {
    Navigator.pushNamed(context!, 'paciente');
  }

  void crearTratamiento() async {
    String nombreTratamiento = nombreTratamientoController.text.trim();
    String nombreMedicamento = nombreMedicamentoController.text.trim();
    String descripcion = descripcionController.text.trim();
    int frecuencia = int.parse(frecuenciaController.text.trim());
    String tiempoDeLaMedicacion = tiempoDeLaMedicacionController.text.trim();
    DateTime horaProgramada = DateTime.now();
    String etapa = etapaController.text.trim();
    bool lente = lenteController.text.trim().toLowerCase() == 'true';
    bool parche = parcheController.text.trim().toLowerCase() == 'true';

    Tratamiento tratamiento = Tratamiento(
        nombreTratamiento: nombreTratamiento,
        nombreMedicamento: nombreMedicamento,
        descripcion: descripcion,
        frecuencia: frecuencia,
        horaProgramada: horaProgramada,
        tiempoDeLaMedicacion: tiempoDeLaMedicacion,
        etapa: etapa,
        lente: lente,
        parche: parche);

    if (nombreTratamiento.isEmpty ||
        nombreMedicamento.isEmpty ||
        descripcion.isEmpty ||
        frecuencia.toString().isEmpty) {
      MySnackbar.show(context!, 'Debe ingresar todos los datos');
      return;
    }

    ResponseApi? responseApi = await _tratamientoProvider.create(tratamiento);
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
        gotoTratamiento();
      } else {
        MySnackbar.show(context!, responseApi.msg!);
      }
    } // Muestra el mensaje de respuesta
  }

  void removeAt(Tratamiento tratamiento, Paciente paciente,
      List<Tratamiento> tratamientos) async {
    ResponseApi? responseApi = await _tratamientoProvider.eliminar(tratamiento);
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
        if (user?.tipoUsuario == 'doctor') {
          listarTratamientoAdmin();
        } else {
          if (tratamientos.length == 1) {
            gotoPaciente();
          } else {
            listarTratamientoCliente(paciente);
          }
        }
      } else {
        MySnackbar.show(context!, responseApi.msg!);
      }
    }
  }

  void modificar(Paciente paciente, Tratamiento tratamiento) async {
    String nombreTratamiento = nombreTratamientoController.text.trim();
    String nombreMedicamento = nombreMedicamentoController.text.trim();
    String descripcion = descripcionController.text.trim();
    int frecuencia = int.tryParse(frecuenciaController.text.trim()) ?? 0;
    String trimmedDate = horaProgramadaController.text.trim();
    String tiempoDeLaMedicacion = tiempoDeLaMedicacionController.text.trim();
    DateTime horaProgramada;
    if (trimmedDate.isEmpty) {
      // Handle the case where the date is not provided, e.g., show an error message
      if (user?.tipoUsuario == 'cliente') {
        MySnackbar.show(
            context!, 'Debe ingresar la hora programada para poder empezar');
        return;
      }
      if (user?.tipoUsuario == 'doctor') {
        trimmedDate = DateTime.now().toIso8601String();
      }
    }
    horaProgramada = DateTime.parse(trimmedDate);
    String etapa = etapaController.text.trim();
    bool lente = lenteController.text.trim().toLowerCase() == 'true';
    bool parche = parcheController.text.trim().toLowerCase() == 'true';

    tratamiento = Tratamiento(
      idTratamiento: tratamiento.idTratamiento,
      nombreTratamiento: nombreTratamiento.isNotEmpty
          ? nombreTratamiento
          : tratamiento.nombreTratamiento,
      nombreMedicamento: nombreMedicamento.isNotEmpty
          ? nombreMedicamento
          : tratamiento.nombreMedicamento,
      descripcion:
          descripcion.isNotEmpty ? descripcion : tratamiento.descripcion,
      frecuencia: frecuencia.toString().isNotEmpty
          ? frecuencia
          : tratamiento.frecuencia,
      tiempoDeLaMedicacion: tiempoDeLaMedicacion.toString().isNotEmpty
          ? tiempoDeLaMedicacion
          : tratamiento.tiempoDeLaMedicacion,
      horaProgramada: horaProgramada,
      etapa: etapa.isNotEmpty ? etapa : tratamiento.etapa,
      lente: lente,
      parche: parche,
      idPaciente: tratamiento.idPaciente,
      idUsuario: tratamiento.idUsuario,
    );

    ResponseApi? responseApi =
        await _tratamientoProvider.modificar(tratamiento);
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
        if (user!.tipoUsuario!.contains('doctor')) {
          gotoTratamiento();
        }
      } else {
        MySnackbar.show(context!, responseApi.msg!);
      }
    }
  }

  void listarTratamientoCliente(Paciente paciente) async {
    List<Tratamiento> tratamientos = await _tratamientoProvider.listarCliente(paciente);
    refresh!();

    if(tratamientos.isEmpty) {
        MySnackbar.show(context!, 'Tratamiento no encontrado para el paciente');
        return;
    }

    seleccionarTratamientoClien(tratamientos, paciente);
  }

  void seleccionarTratamientoClien(
    List<Tratamiento> tratamientos,
    Paciente paciente,
  ) {
    Navigator.push(
        context!,
        MaterialPageRoute(
            builder: (context) => TratamientoDetalleClientePage(
                tratamientos: tratamientos,
                paciente: paciente,
            ),
        )
    );
  }

  void listarTratamientoAdmin() async {
    tratamiento = await _tratamientoProvider.listar();
    refresh!();
  }

  void seleccionarTratamiento(int index) {
    final tratamientoSeleccionado = tratamiento[index];
    Navigator.push(
      context!,
      MaterialPageRoute(
          builder: (context) =>
              TratamientoDetallePage(tratamiento: tratamientoSeleccionado)),
    ).then((value) {
      // Si necesitas refrescar la lista después de cerrar la pantalla de detalles
      listarTratamientoAdmin();
    });
  }

  void listarTratamientoNuevos(Paciente paciente) async {
    tratamientoActualizado =
        await _tratamientoProvider.listarClienteFaltante(paciente);
    refresh!();
  }

  void ponerIDpaciente(Paciente paciente, Tratamiento tratamiento) async {
    ResponseApi? responseApi =
        await _tratamientoProvider.asignarIDPaciente(paciente, tratamiento);
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
      } else {
        MySnackbar.show(context!, responseApi.msg!);
      }
    }
  }

  void openDrawer() {
    key.currentState?.openDrawer();
  }

  void gotoUpdatePage() {
    Navigator.pushNamed(context!, 'editaruser');
  }

  void logout() {
    sharedPref.login(context!);
  }
}
