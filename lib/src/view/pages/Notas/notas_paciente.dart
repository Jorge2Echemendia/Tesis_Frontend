import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_3/connection_manager.dart';
import 'package:flutter_application_3/src/controller/notas_controller.dart';
import 'package:flutter_application_3/src/model/notas.dart';
import 'package:flutter_application_3/src/model/paciente.dart';
import 'package:flutter_application_3/src/utils/my_color.dart';
import 'package:flutter_application_3/src/view/pages/notas/crear_notas.dart';
import 'package:flutter_application_3/src/view/pages/notas/modificar_notas.dart';

class NotasPaciente extends StatefulWidget {
  final List<Notas> notas;
  final Paciente paciente;
  const NotasPaciente({super.key, required this.notas, required this.paciente});

  @override
  State<NotasPaciente> createState() => _NotasPacienteState();
}

class _NotasPacienteState extends State<NotasPaciente> {
  final NotasController _con = NotasController();

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
  final Paciente paciente = widget.paciente;
  return Scaffold(
    appBar: AppBar(
      leading: _iconBack(),
      backgroundColor: MyColor.primaryColor,
      title: const Text(
        'Notas o Recordatorios',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
      ),
      centerTitle: true,
    ),
    body: Stack(
      children: [
        ListView.builder(
          itemCount: widget.notas.length,
          itemBuilder: (context, index) {
            final notas = widget.notas[index];
            return Card(
              elevation: 10,
              shadowColor: Colors.black.withOpacity(0.5),
              color: MyColor.primaryOpacityColor,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nota #${index + 1}:',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    const Text('Nombre Nota:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    Text(
                      notas.nombreDeNotas ?? 'No disponible',
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    const Text('Motivo:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    Text(notas.motivo ?? 'No disponible',
                        style: const TextStyle(fontSize: 18, color: Colors.black)),
                    const SizedBox(height: 8),
                    const Text('Descripción de la nota o Contenido:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    Text(notas.contenido ?? 'No disponible',
                        style: const TextStyle(fontSize: 18, color: Colors.black)),
                    const SizedBox(height: 8),
                    _renderConditionals(notas),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: _crearBotonModificar(notas,paciente)),
                        const SizedBox(width: 8),
                        _crearBotonEliminar(notas, paciente),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            heroTag: 'tagCrear',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CrearNotas(paciente: paciente),
                  ));
            },
            child: const Icon(Icons.add),
          ),
        ),
      ],
    ),
  );
}

  Widget _crearBotonModificar(Notas notas, Paciente paciente) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45,
      height: 50,
      child: ElevatedButton(
        onPressed: (){
          Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ModificarNotas(notas:notas,paciente: paciente,),
                  ));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orangeAccent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Modificar',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget _crearBotonEliminar(Notas notas, Paciente paciente) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45,
      height: 50,
      child: ElevatedButton(
        onPressed: () => {
          _con.remove(notas, paciente),
          refresh(),
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Eliminar',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget _renderConditionals(Notas notas) {
    List<Widget> conditionals = [];

    if (notas.recordatorio == true || notas.recordatorioContinuo == true) {
      conditionals.add(const Text('  Hora y Fecha programada:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)));
      conditionals.add(Text(
          notas.horaProgramada?.toString() ?? 'No disponible',
          style: const TextStyle(fontSize: 18, color: Colors.black)));
    }

    if (notas.recordatorioContinuo == true) {
      conditionals.add(const Text('Cantidad de veces:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)));
      conditionals.add(Text('${notas.frecuencia ?? 'No disponible'}',
          style: const TextStyle(fontSize: 18, color: Colors.black)));
      conditionals.add(const SizedBox(height: 8));
      conditionals.add(const Text('Tiempo de intervalo:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)));
      conditionals.add(
        Text(notas.tiempoMaximoDia ?? 'No disponible',
            style: const TextStyle(fontSize: 18, color: Colors.black)),
      );
    }

    return Column(children: conditionals);
  }
  Widget _iconBack() {
    return IconButton(
        onPressed: _con.gotoPaciente,
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black));
  }
}
