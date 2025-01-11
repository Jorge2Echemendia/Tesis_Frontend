import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_3/connection_manager.dart';
import 'package:flutter_application_3/src/controller/configuracion_controller.dart';
import 'package:flutter_application_3/src/model/configuracion.dart';
import 'package:flutter_application_3/src/utils/my_color.dart';

class ConfiguracionDetalleClientePage extends StatefulWidget {
  final List<Configuracion> configuracion;
  const ConfiguracionDetalleClientePage(
      {super.key, required this.configuracion});

  @override
  State<ConfiguracionDetalleClientePage> createState() =>
      _ConfiguracionDetalleClientePageState();
}

class _ConfiguracionDetalleClientePageState
    extends State<ConfiguracionDetalleClientePage> {
  final ConfiguracionController _con = ConfiguracionController();
  @override
  void initState() {
    super.initState();
    ConnectionManager().checkAndShowAlert(context);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _con.init(context, refresh);
    });
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.primaryColor,
        title: const Text(
          'Tiempo recomendado',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: Card(
            color: MyColor.primaryOpacityColor,
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                color: MyColor.primaryColorDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ...widget.configuracion.map((configuracion) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Nombre Tratamiento:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 26)),
                          Text(
                            configuracion.afeccion ?? 'No disponible',
                            style: const TextStyle(
                                fontSize: 26, color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          const Text('Tiempo:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 26)),
                          Text(configuracion.tiempoMaximoDia ?? 'No disponible',
                              style: const TextStyle(
                                  fontSize: 26,
                                  color: Colors
                                      .white)),
                          const SizedBox(height: 8),
                    const Text('Etapa de tratamiento:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 26)),
                    Text(configuracion.etapa!,
                        style:
                            const TextStyle(fontSize: 26, color: Colors.white)), // Espacio entre tratamientos
                        ],
                      );
                    }),
                  _buttonCrear(widget.configuracion)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonCrear(List<Configuracion> configuracion) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 70, vertical: 30),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              _con.notificarPorFecha(configuracion);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColor.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            ),
            child: const Text(
              'Empezemos',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
