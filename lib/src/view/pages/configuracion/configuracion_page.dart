import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_3/src/controller/configuracion_controller.dart';
import 'package:flutter_application_3/src/model/configuracion.dart';
import 'package:flutter_application_3/src/utils/my_color.dart';
import 'package:flutter_application_3/src/view/pages/configuracion/configuracion_editar_page.dart';
import 'package:flutter_application_3/src/view/pages/configuracion/crear_configuracion_page.dart';

class ConfiguracionPage extends StatefulWidget {
  const ConfiguracionPage({super.key});

  @override
  State<ConfiguracionPage> createState() => _ConfiguracionPageState();
}

class _ConfiguracionPageState extends State<ConfiguracionPage> {
  final ConfiguracionController _controller = ConfiguracionController();

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
      appBar: AppBar(
        leading: _iconBack(),
        backgroundColor: MyColor.primaryOpacityColor,
        title: const Text(
          'Gestión del Tiempo',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final configuracion = _controller.configuracion[index];
                    return _buildConfiguracionItem(configuracion, index);
                  },
                  childCount: _controller.configuracion.length,
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
                      builder: (context) => const CrearConfiguracionPage(),
                    ));
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfiguracionItem(Configuracion configuracion, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: MyColor.primaryColor, borderRadius: BorderRadius.circular(50)),
      child: ListTile(
        title: Text(
          configuracion.afeccion!,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
        subtitle: Text(
  '${configuracion.tiempoMaximoDia} ${configuracion.etapa} ${configuracion.lente! ? 'Lente' : 'Parche'} ',
  textAlign: TextAlign.center,
  style: const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: Colors.white,
  ),
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
                            ConfiguracionEditarPage(configuracion: configuracion)));
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _controller.removeAt(configuracion);
                refresh();
              },
            ),
          ],
        ),
      ),
    );
  }
  Widget _iconBack() {
    return IconButton(
        onPressed: _controller.gotoTratamiento,
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black));
  }
}