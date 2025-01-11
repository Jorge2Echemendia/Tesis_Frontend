import 'package:flutter/material.dart';
import 'package:flutter_application_3/src/model/paciente.dart';
import 'package:flutter_application_3/src/utils/my_color.dart';
import 'package:intl/intl.dart';

class PacienteDetallePage extends StatelessWidget {
  final Paciente paciente;

  const PacienteDetallePage({super.key, required this.paciente});

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final String fechaFormateada = formatter.format(paciente.fechaNacimiento!);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.primaryColor,
        title: const Text(
          'Detalles del Paciente',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // Utiliza SingleChildScrollView para permitir desplazamiento si los datos son demasiado largos
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
                    const Text('Nombre:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 26)),
                    Text(
                      paciente.nombre!,
                      style: const TextStyle(fontSize: 26, color: Colors.white),
                    ),
                    const SizedBox(height: 8), // Espacio entre elementos
                    const Text('Apellido:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 26)),
                    Text(paciente.apellido!,
                        style:
                            const TextStyle(fontSize: 26, color: Colors.white)),
                    const SizedBox(height: 8),
                    const Text('Apellido Secundario:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 26)),
                    Text(paciente.apellidoSegundo!,
                        style:
                            const TextStyle(fontSize: 26, color: Colors.white)),
                    const SizedBox(height: 8),
                    const Text('Afección:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 26)),
                    Text(paciente.afeccion!,
                        style:
                            const TextStyle(fontSize: 26, color: Colors.white)),
                    const SizedBox(height: 8),
                    const Text('Fecha Nacimiento:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 26)),
                    Text(fechaFormateada,
                        style:
                            const TextStyle(fontSize: 26, color: Colors.white)),
                    const SizedBox(height: 8),
                    const Text('Etapa de Tratamiento:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 26)),
                    Text(paciente.etapaDeTratamiento!,
                        style:
                            const TextStyle(fontSize: 26, color: Colors.white)),
                    const SizedBox(height: 8),
                    _primeraEtapa(),
                    _segundaEtapa(),
                    _terceraEtapa(),
                    _cuartaEtapa(),
                    _quintaEtapa(),
                    const SizedBox(height: 8),
                    _parcheeOlente()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _primeraEtapa() {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final String fechaFormateada1 =
        formatter.format(paciente.fechaDiagnostico!);
    if (paciente.etapaDeTratamiento! != 'Diagnóstico Inicial') {
      return const SizedBox.shrink();
    }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Fecha del diagnóstico:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
          Text(fechaFormateada1,
              style: const TextStyle(fontSize: 26, color: Colors.white)),
          const SizedBox(height: 8),
          const Text('Grado de miopía:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
          Text(paciente.gradoMiopia!,
              style: const TextStyle(fontSize: 26, color: Colors.white)),
          const SizedBox(height: 8),
          const Text('Exámenes realizados:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
          Text(paciente.examenes!,
              style: const TextStyle(fontSize: 26, color: Colors.white)),
          const SizedBox(height: 8),
          const Text('Recomendaciones iniciales:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
          Text(paciente.recomendaciones!,
              style: const TextStyle(fontSize: 26, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _segundaEtapa() {
    if (paciente.etapaDeTratamiento! != 'Tratamiento Activo') {
      return const SizedBox.shrink();
    }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Tipo de corrección óptica:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
          Text(paciente.correccionOptica!,
              style: const TextStyle(fontSize: 26, color: Colors.white)),
          const SizedBox(height: 8),
          const Text('Ejercicios visuales recomendados:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
          Text(paciente.ejerciciosVisuales!,
              style: const TextStyle(fontSize: 26, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _terceraEtapa() {
    if (paciente.etapaDeTratamiento! != 'Mantenimiento') {
      return const SizedBox.shrink();
    }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Cambios en la corrección óptica:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
          Text(paciente.cambioOptico!,
              style: const TextStyle(fontSize: 26, color: Colors.white)),
          const SizedBox(height: 8),
          const Text('Consejos de higiene visual:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
          Text(paciente.consejosHigiene!,
              style: const TextStyle(fontSize: 26, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _cuartaEtapa() {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final String fechaFormateada2 = formatter.format(paciente.cirujiaFecha!);
    if (paciente.etapaDeTratamiento! != 'Intervención Quirúrgica') {
      return  const SizedBox.shrink();
    }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Tipo de cirugía:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
          Text(paciente.cirujia!,
              style: const TextStyle(fontSize: 26, color: Colors.white)),
          const SizedBox(height: 8),
          const Text('Fecha de la cirugía:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
          Text(fechaFormateada2,
              style: const TextStyle(fontSize: 26, color: Colors.white)),
          const SizedBox(height: 8),
          const Text('Resultados postoperatorios:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
          Text(paciente.cirujiaResultados!,
              style: const TextStyle(fontSize: 26, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _quintaEtapa() {
    if (paciente.etapaDeTratamiento! != 'Rehabilitación Visual') {
      return const SizedBox.shrink();
    }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Progreso en habilidades visuales:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
          Text(paciente.progreso!,
              style: const TextStyle(fontSize: 26, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _parcheeOlente() {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final String fechaFormateada3 = formatter.format(paciente.fechaParche!);
    final String fechaFormateada4 = formatter.format(paciente.fechaLente!);
    if (paciente.parche! == true) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Tipo de parche:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
            Text(paciente.tipoParche!,
                style: const TextStyle(fontSize: 26, color: Colors.white)),
            const SizedBox(height: 8),
            const Text('Horas recomendadas:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
            Text(paciente.horasParche!,
                style: const TextStyle(fontSize: 26, color: Colors.white)),
            const SizedBox(height: 8),
            const Text('Observaciones del parche:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
            Text(paciente.observacionesParche!,
                style: const TextStyle(fontSize: 26, color: Colors.white)),
            const SizedBox(height: 8),
            const Text('Fecha de prescripcio del parche:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
            Text(fechaFormateada3,
                style: const TextStyle(fontSize: 26, color: Colors.white)),
          ],
        ),
      );
    } else {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Tipo de lente:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
            Text(paciente.tipoLente!,
                style: const TextStyle(fontSize: 26, color: Colors.white)),
                const SizedBox(height: 8),
            const Text('Graduacion del lente:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
            Text(paciente.graduacionLente!,
                style: const TextStyle(fontSize: 26, color: Colors.white)),
            const SizedBox(height: 8),
            const Text('Fecha de prescripcion del lente:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
            Text(fechaFormateada4,
                style: const TextStyle(fontSize: 26, color: Colors.white)),
          ],
        ),
      );
    }
  }
}
