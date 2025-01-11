import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_3/src/model/paciente.dart';
import 'package:flutter_application_3/src/model/tratamiento.dart';
import 'package:flutter_application_3/src/controller/tratamiento_controller.dart';
import 'package:flutter_application_3/src/utils/my_color.dart';
import 'package:flutter_application_3/src/view/pages/tratamiento/crear_tratamiento_page.dart';
import 'package:flutter_application_3/src/view/pages/tratamiento/tratamiento_editar_page.dart';

class TratamientoPage extends StatefulWidget {
  const TratamientoPage({super.key});

  @override
  State<TratamientoPage> createState() => _TratamientoPageState();
}

class _TratamientoPageState extends State<TratamientoPage> {
  final TratamientoController _controller = TratamientoController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.init(context, refresh);
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
          'Gestión de Tratamientos',
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
                    final tratamiento = _controller.tratamiento[index];
                    return _buildTratamientoItem(tratamiento, index, null,null);
                  },
                  childCount: _controller.tratamiento.length,
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
                      builder: (context) => const CrearTratamientoPage(),
                    ));
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTratamientoItem(Tratamiento tratamiento, int index,Paciente? paciente,List<Tratamiento>? tratamientos) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: MyColor.primaryColor, borderRadius: BorderRadius.circular(50)),
      child: ListTile(
        title: Text(
          tratamiento.nombreTratamiento!,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
        subtitle: Text(
          '${tratamiento.nombreMedicamento}',
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TratamientoEditarPage(tratamiento: tratamiento)));
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _controller.removeAt(tratamiento, Paciente(nombre: '', apellido: '', apellidoSegundo: '', fechaNacimiento: DateTime.now(), afeccion: '', etapaDeTratamiento: '', lente: false, parche: false, tipoLente: '', tipoParche: '', horasParche: '', observacionesParche: '', fechaParche:  DateTime.now(), graduacionLente: '', fechaLente:  DateTime.now(), fechaDiagnostico:  DateTime.now(), gradoMiopia: '', examenes: '', recomendaciones: '', correccionOptica: '', ejerciciosVisuales: '', cambioOptico: '', consejosHigiene: '', cirujia: '', cirujiaFecha:  DateTime.now(), cirujiaResultados: '', progreso: ''),tratamientos=[]);
                refresh();
              },
            ),
          ],
        ),
        onTap: () {
          _controller.seleccionarTratamiento(index);
        },
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
                          ? NetworkImage(_controller.user!.imagen!)
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
            onTap: _controller.gotoConfiguracion,
            title: const Text('Ver configuraciones'),
            trailing: const Icon(Icons.medical_information_outlined),
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
