import 'package:flutter/material.dart';
import 'package:flutter_application_3/src/model/paciente.dart';
import 'package:flutter_application_3/src/model/response_api.dart';
import 'package:flutter_application_3/src/model/user.dart';
import 'package:flutter_application_3/src/provider/pacientes_provider.dart';
import 'package:flutter_application_3/src/utils/my_snackbar.dart';
import 'package:flutter_application_3/src/utils/shared_pref.dart';
import 'package:flutter_application_3/src/view/pages/patient/paciente_detalle_page.dart';

class PacienteController {
  BuildContext? context;
  Function? refresh;
  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidoController = TextEditingController();
  TextEditingController apellidoSegundoController = TextEditingController();
  TextEditingController afeccionController = TextEditingController();
  TextEditingController fechaNacimientoController = TextEditingController();
  TextEditingController etapaDeTratamientoController = TextEditingController();
  TextEditingController lenteController = TextEditingController();
  TextEditingController tipoLenteController = TextEditingController();
  TextEditingController graduacionLenteController = TextEditingController();
  TextEditingController fechaLenteController = TextEditingController();
  TextEditingController parcheController = TextEditingController();
  TextEditingController tipoParcheController = TextEditingController();
  TextEditingController horasParcheController = TextEditingController();
  TextEditingController observacionesParcheController = TextEditingController();
  TextEditingController fechaParcheController = TextEditingController();
  TextEditingController fechaDiagnosticoController = TextEditingController();
  TextEditingController gradoMiopiaController = TextEditingController();
  TextEditingController examenesController = TextEditingController();
  TextEditingController recomendacionesController = TextEditingController();
  TextEditingController correccionOpticaController = TextEditingController();
  TextEditingController ejerciciosVisualesController = TextEditingController();
  TextEditingController cambioOpticoController = TextEditingController();
  TextEditingController consejosHigieneController = TextEditingController();
  TextEditingController cirujiaController = TextEditingController();
  TextEditingController cirujiaFechaController = TextEditingController();
  TextEditingController cirujiaResultadosController = TextEditingController();
  TextEditingController progresoController = TextEditingController();

  ValueNotifier<String?> messageNotifier = ValueNotifier<String?>(null);

  final PacientesProvider _pacientesProvider = PacientesProvider();
  User? user;
  SharedPref sharedPref = SharedPref();
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  List<Paciente> pacientes = [];

  get selectedPatientIndex => null;

  Future<void> init(BuildContext context, void Function() refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await sharedPref.read('user') ?? {});
    print('aasasasasas ${user!.toJson()}');
    await _pacientesProvider.init(context, user!);
    listarPacientes();
  }

  void gotoPaciente() {
    Navigator.pushNamed(context!, 'paciente');
  }

  void crearPaciente() async {
    String nombre = nombreController.text.trim();
    String apellido = apellidoController.text.trim();
    String apellidoSegundo = apellidoSegundoController.text.trim();
    String afeccion = afeccionController.text.trim();
    String trimmedDate = fechaNacimientoController.text.trim();
    if (trimmedDate.isEmpty) {
      // Handle the case where the date is not provided, e.g., show an error message
      MySnackbar.show(context!, 'Debe ingresar la fecha de nacimiento');
      return;
    }
    DateTime fechaNacimiento = DateTime.parse(trimmedDate);
    print('Fecha12: $fechaNacimiento');
    String etapaDeTratamiento = etapaDeTratamientoController.text.trim();
    bool parche = parcheController.text.trim().toLowerCase() == 'true';
    bool lente = lenteController.text.trim().toLowerCase() == 'true';
    String tipoLente = tipoLenteController.text.trim();
    String graduacionLente = graduacionLenteController.text.trim();
    String tipoParche = tipoParcheController.text.trim();
    String horasParche = horasParcheController.text.trim();
    if (horasParche.isEmpty) {
      TimeOfDay picked = TimeOfDay.now();
      horasParche =
          "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
    }
    String observacionesParche = observacionesParcheController.text.trim();
    String trimmedaDate = fechaLenteController.text.trim();
    DateTime fechaLente;
    if (trimmedaDate.isEmpty) {
      fechaLente = DateTime.now();
    } else {
      fechaLente = DateTime.parse(trimmedaDate);
    }
    String trimmedeDate = fechaParcheController.text.trim();
    DateTime fechaParche;
    if (trimmedeDate.isEmpty) {
      fechaParche = DateTime.now();
    } else {
      fechaParche = DateTime.parse(trimmedeDate);
    }
    String trimmeduDate = fechaDiagnosticoController.text.trim();
    DateTime fechaDiagnostico;
    if (trimmeduDate.isEmpty) {
      fechaDiagnostico = DateTime.now();
    } else {
      fechaDiagnostico = DateTime.parse(trimmeduDate);
    }
    String gradoMiopia = gradoMiopiaController.text.trim();
    String examenes = examenesController.text.trim();
    String recomendaciones = recomendacionesController.text.trim();
    String correcionOptica = correccionOpticaController.text.trim();
    String ejerciciosVisuales = ejerciciosVisualesController.text.trim();
    String cambioOptico = cambioOpticoController.text.trim();
    String consejosHigiene = consejosHigieneController.text.trim();
    String cirujia = cirujiaController.text.trim();
    String trimmudDate = cirujiaFechaController.text.trim();
    DateTime cirujiaFecha;
    if (trimmudDate.isEmpty) {
      cirujiaFecha = DateTime.now();
    } else {
      cirujiaFecha = DateTime.parse(trimmudDate);
    }
    String cirujiaResultado = cirujiaResultadosController.text.trim();
    String progreso = progresoController.text.trim();

    Paciente paciente = Paciente(
        nombre: nombre,
        apellido: apellido,
        apellidoSegundo: apellidoSegundo,
        fechaNacimiento: fechaNacimiento,
        afeccion: afeccion,
        etapaDeTratamiento: etapaDeTratamiento,
        parche: parche,
        lente: lente,
        tipoParche: tipoParche,
        tipoLente: tipoLente,
        graduacionLente: graduacionLente,
        horasParche: horasParche,
        observacionesParche: observacionesParche,
        fechaLente: fechaLente,
        fechaParche: fechaParche,
        fechaDiagnostico: fechaDiagnostico,
        gradoMiopia: gradoMiopia,
        examenes: examenes,
        recomendaciones: recomendaciones,
        correccionOptica: correcionOptica,
        ejerciciosVisuales: ejerciciosVisuales,
        cambioOptico: cambioOptico,
        consejosHigiene: consejosHigiene,
        cirujia: cirujia,
        cirujiaFecha: cirujiaFecha,
        cirujiaResultados: cirujiaResultado,
        progreso: progreso);

    if (nombre.isEmpty ||
        apellido.isEmpty ||
        apellidoSegundo.isEmpty ||
        etapaDeTratamiento.isEmpty ||
        afeccion.isEmpty) {
      MySnackbar.show(context!, 'Debe ingresar todos los datos iniciales');
      return;
    }

    switch (etapaDeTratamiento) {
      case 'Diagnóstico Inicial':
        refresh!();
        if (fechaDiagnosticoController.text.isEmpty ||
            gradoMiopia.isEmpty ||
            examenes.isEmpty ||
            recomendaciones.isEmpty) {
          MySnackbar.show(
              context!, 'Debe ingresar todos los datos de Diagnóstico Inicial');
          return;
        }
        refresh!();
        break;
      case 'Tratamiento Activo':
        refresh!();
        if (correcionOptica.isEmpty || ejerciciosVisuales.isEmpty) {
          MySnackbar.show(
              context!, 'Debe ingresar todos los datos de Tratamiento Activo');
              return;
        }
        refresh!();
        break;
      case 'Mantenimiento':
        refresh!();
        if (cambioOptico.isEmpty || consejosHigiene.isEmpty) {
          MySnackbar.show(
              context!, 'Debe ingresar todos los datos de Mantenimiento');
              return;
        }
        refresh!();
        break;
      case 'Intervención Quirúrgica':
        if (cirujia.isEmpty ||
            cirujiaResultado.isEmpty ||
            cirujiaFechaController.text.isEmpty) {
          MySnackbar.show(context!,
              'Debe ingresar todos los datos de Intervención Quirúrgica');
              return;
        }
        break;
      case 'Rehabilitación Visual':
        if (progreso.isEmpty) {
          MySnackbar.show(context!,
              'Debe ingresar todos los datos se Rehabilitación Visual');
              return;
        }
        break;
    }

    if(lente==true){
      if(tipoLente.isEmpty||fechaLenteController.text.isEmpty|| graduacionLente.isEmpty){
        MySnackbar.show(context!,
              'Debe ingresar todos los datos de los Lente');
              return;
      }
    } else if(parche==true){
      if(tipoParche.isEmpty|| horasParche.isEmpty ||observacionesParche.isEmpty||fechaParcheController.text.isEmpty){
        MySnackbar.show(context!,
              'Debe ingresar todos los datos del Parche');
              return;
      }
    }else{
      MySnackbar.show(context!,
              'Debe especificar si el paciente utiliza Parche o Lente');
              return;
    }

    ResponseApi? responseApi = await _pacientesProvider.create(paciente);
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
        gotoPaciente();
      } else {
        MySnackbar.show(context!, responseApi.msg!);
      }
    } // Muestra el mensaje de respuesta
  }

  void modificar(Paciente paciente) async {
    String nombre = nombreController.text.trim();
    String apellido = apellidoController.text.trim();
    String apellidoSegundo = apellidoSegundoController.text.trim();
    String afeccion = afeccionController.text.trim();
    String trimmedDate = fechaNacimientoController.text.trim();
    if (trimmedDate.isEmpty) {
      // Handle the case where the date is not provided, e.g., show an error message
      trimmedDate = paciente.fechaNacimiento!.toIso8601String();
    }
    DateTime fechaNacimiento = DateTime.parse(trimmedDate);
    String etapaDeTratamiento = etapaDeTratamientoController.text.trim();
    bool parche = parcheController.text.trim().toLowerCase() == 'true';
    bool lente = lenteController.text.trim().toLowerCase() == 'true';
    String tipoLente = tipoLenteController.text.trim();
    String graduacionLente = graduacionLenteController.text.trim();
    String tipoParche = tipoParcheController.text.trim();
    String horasParche = horasParcheController.text.trim();
    String observacionesParche = observacionesParcheController.text.trim();
    String trimmedaDate = fechaLenteController.text.trim();
    if (trimmedaDate.isEmpty) {
      // Handle the case where the date is not provided, e.g., show an error message
      trimmedaDate = paciente.fechaLente!.toIso8601String();
    }
    DateTime fechaLente = DateTime.parse(trimmedaDate);
    String trimmedeDate = fechaParcheController.text.trim();
    if (trimmedeDate.isEmpty) {
      // Handle the case where the date is not provided, e.g., show an error message
      trimmedeDate = paciente.fechaParche!.toIso8601String();
    }
    DateTime fechaParche = DateTime.parse(trimmedeDate);
    String trimmeduDate = fechaDiagnosticoController.text.trim();
    if (trimmeduDate.isEmpty) {
      // Handle the case where the date is not provided, e.g., show an error message
      trimmeduDate = paciente.fechaDiagnostico!.toIso8601String();
    }
    DateTime fechaDiagnostico = DateTime.parse(trimmeduDate);
    String gradoMiopia = gradoMiopiaController.text.trim();
    String examenes = examenesController.text.trim();
    String recomendaciones = recomendacionesController.text.trim();
    String correcionOptica = correccionOpticaController.text.trim();
    String ejerciciosVisuales = ejerciciosVisualesController.text.trim();
    String cambioOptico = cambioOpticoController.text.trim();
    String consejosHigiene = consejosHigieneController.text.trim();
    String cirujia = cirujiaController.text.trim();
    String trimmudDate = cirujiaFechaController.text.trim();
    if (trimmudDate.isEmpty) {
      // Handle the case where the date is not provided, e.g., show an error message
      trimmudDate = paciente.cirujiaFecha!.toIso8601String();
    }
    DateTime cirujiaFecha = DateTime.parse(trimmudDate);
    String cirujiaResultado = cirujiaResultadosController.text.trim();
    String progreso = progresoController.text.trim();

    print('Respuesta3:${paciente.toJson()}');

    paciente = Paciente(
      idPaciente: paciente.idPaciente,
      nombre: nombre.isNotEmpty ? nombre : paciente.nombre,
      apellido: apellido.isNotEmpty ? apellido : paciente.apellido,
      apellidoSegundo: apellidoSegundo.isNotEmpty
          ? apellidoSegundo
          : paciente.apellidoSegundo,
      fechaNacimiento: fechaNacimiento,
      afeccion: afeccion.isNotEmpty ? afeccion : paciente.afeccion,
      etapaDeTratamiento: etapaDeTratamiento.isNotEmpty
          ? etapaDeTratamiento
          : paciente.etapaDeTratamiento,
      idUsuario: paciente.idUsuario,
      lente: lente,
      parche: parche,
      tipoLente: tipoLente.isNotEmpty ? tipoLente : paciente.tipoLente,
      tipoParche: tipoParche.isNotEmpty ? tipoParche : paciente.tipoParche,
      horasParche: horasParche.isNotEmpty ? horasParche : paciente.horasParche,
      observacionesParche: observacionesParche.isNotEmpty
          ? observacionesParche
          : paciente.observacionesParche,
      fechaParche: fechaParche,
      graduacionLente: graduacionLente.isNotEmpty
          ? graduacionLente
          : paciente.graduacionLente,
      fechaLente: fechaLente,
      fechaDiagnostico: fechaDiagnostico,
      gradoMiopia: gradoMiopia.isNotEmpty ? gradoMiopia : paciente.gradoMiopia,
      examenes: examenes.isNotEmpty ? examenes : paciente.examenes,
      recomendaciones: recomendaciones.isNotEmpty
          ? recomendaciones
          : paciente.recomendaciones,
      correccionOptica: correcionOptica.isNotEmpty
          ? correcionOptica
          : paciente.correccionOptica,
      ejerciciosVisuales: ejerciciosVisuales.isNotEmpty
          ? ejerciciosVisuales
          : paciente.ejerciciosVisuales,
      cambioOptico:
          cambioOptico.isNotEmpty ? cambioOptico : paciente.cambioOptico,
      consejosHigiene: consejosHigiene.isNotEmpty
          ? consejosHigiene
          : paciente.consejosHigiene,
      cirujia: cirujia.isNotEmpty ? cirujia : paciente.cirujia,
      cirujiaFecha: cirujiaFecha,
      cirujiaResultados: cirujiaResultado.isNotEmpty
          ? cirujiaResultado
          : paciente.cirujiaResultados,
      progreso: progreso.isNotEmpty ? progreso : paciente.progreso,
    );

    print('Respuesta4:${paciente.toJson()}');

    ResponseApi? responseApi = await _pacientesProvider.modificar(paciente);
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
        gotoPaciente();
      } else {
        MySnackbar.show(context!, responseApi.msg!);
      }
    }
  }

  void removeAt(Paciente paciente) async {
    ResponseApi? responseApi = await _pacientesProvider.eliminar(paciente);
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
        listarPacientes();
      } else {
        MySnackbar.show(context!, responseApi.msg!);
      }
    }
  }

  void listarPacientes() async {
    pacientes = await _pacientesProvider.listar();
    refresh!();
  }

  void seleccionarPaciente(int index) {
    final pacienteSeleccionado = pacientes[index];
    Navigator.push(
      context!,
      MaterialPageRoute(
          builder: (context) =>
              PacienteDetallePage(paciente: pacienteSeleccionado)),
    ).then((value) {
      // Si necesitas refrescar la lista después de cerrar la pantalla de detalles
      listarPacientes();
    });
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
