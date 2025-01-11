import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_3/connection_manager.dart';
import 'package:flutter_application_3/src/controller/configuracion_controller.dart';
import 'package:flutter_application_3/src/controller/historial_controller.dart';
import 'package:flutter_application_3/src/controller/notas_controller.dart';
import 'package:flutter_application_3/src/controller/paciente_controller.dart';
import 'package:flutter_application_3/src/controller/tratamiento_controller.dart';
import 'package:flutter_application_3/src/model/paciente.dart';
import 'package:flutter_application_3/src/utils/my_color.dart';
import 'package:flutter_application_3/src/view/pages/patient/crear_paciente_page.dart';
import 'package:flutter_application_3/src/view/pages/patient/editar_paciente_page.dart';

class PacientePage extends StatefulWidget {
  const PacientePage({super.key});
  @override
  State<PacientePage> createState() => _PacientePageState();
}

class _PacientePageState extends State<PacientePage> {
  final PacienteController _controller = PacienteController();
  final TratamientoController _con = TratamientoController();
  final HistorialController _contro = HistorialController();
  final ConfiguracionController _conf = ConfiguracionController();
  final NotasController _co = NotasController();

  @override
  void initState() {
    super.initState();
    refresh();
    ConnectionManager().checkAndShowAlert(context);
    refresh();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.init(context, refresh);
      _con.init(context, refresh);
      _contro.init(context, refresh);
      _conf.init(context, refresh);
      _co.init(context, refresh);
    });
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _controller.key,
      appBar: AppBar(
        leading: _menuDrawer(),
        backgroundColor: MyColor.primaryOpacityColor,
        title: const Text(
          'Gestión de Pacientes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      drawer: _drawer(),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final paciente = _controller.pacientes[index];
                    return _buildPacienteItem(paciente, index);
                  },
                  childCount: _controller.pacientes.length,
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20, // Ajusta esto según dónde quieras que aparezca el botón
            right: 20, // Ajusta esto según dónde quieras que aparezca el botón
            child: FloatingActionButton(
              heroTag: 'tagCrear',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CrearPacientePage(),
                    ));
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

Widget _buildPacienteItem(Paciente paciente, int index) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Card(
      color: MyColor.primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    paciente.nombre!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    '${paciente.apellido} ${paciente.apellidoSegundo}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    _controller.seleccionarPaciente(index);
                  },
                ),
                const SizedBox(height: 5), // Separador entre el ListTile y el contenido principal
                Row(
                  children: [
                     Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditarPacientePage(paciente: paciente),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _controller.removeAt(paciente);
                          refresh();
                        },
                      ),
                        ],
                      ),
                      ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.bookmark_add_outlined),
                            onPressed: () {
                              _co.listarNotas(paciente);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.medical_services),
                            onPressed: () {
                              _con.listarTratamientoCliente(paciente);
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.medical_information_outlined),
                            onPressed: () {
                              _contro.listarHistorialClien(paciente);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.medical_information),
                            onPressed: () {
                              _conf.listarConfiguracionCliente(paciente);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
  Widget _menuDrawer() {
    return GestureDetector(
      onTap: _controller.openDrawer,
      child: Container(
        margin: const EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        child: const Icon(Icons.menu_open),
        //Image.asset('assets/img/menu.png',width: 20,height: 20,),
      ),
    );
  }

  Widget _drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(color: MyColor.primaryColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_controller.user?.nombre ?? ''} ${_controller.user?.apellido ?? ''}',
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                  Text(
                    _controller.user?.email ?? '',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[200],
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                    maxLines: 1,
                  ),
                  Text(
                    _controller.user?.telefono ?? '',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[200],
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                    maxLines: 1,
                  ),
                  Container(
                    height: 55,
                    width: 50,
                    margin: const EdgeInsets.only(top: 10),
                    child: FadeInImage(
                      image: _controller.user?.imagen != null
                          ? NetworkImage(_controller.user?.imagen ?? '')
                          : const AssetImage('assets/img/he_profile.png'),
                      fit: BoxFit.contain,
                      fadeInDuration: const Duration(milliseconds: 50),
                      placeholder: const AssetImage('assets/img/he_profile.png'),
                    ),
                  )
                ],
              )),
          ListTile(
            onTap: _controller.gotoUpdatePage,
            title: const Text('Editar perfil'),
            trailing: const Icon(Icons.edit_outlined),
          ),
          ListTile(
            title: const Text(
              'Cerrar sesion',
            ),
            trailing: const Icon(Icons.edit_outlined),
            onTap: _controller.logout,
          ),
        ],
      ),
    );
  }
}
