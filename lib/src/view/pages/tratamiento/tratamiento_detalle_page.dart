import 'package:flutter/material.dart';
import 'package:flutter_application_3/src/model/tratamiento.dart';
import 'package:flutter_application_3/src/utils/my_color.dart';

class TratamientoDetallePage extends StatelessWidget {
  final Tratamiento tratamiento;

  const TratamientoDetallePage({super.key, required this.tratamiento});

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.primaryColor,
        title: const Text(
          'Detalles del Tratamiento',
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
                    const Text('Nombre Tratamiento:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 26)),
                    Text(
                      tratamiento.nombreTratamiento!,
                      style: const TextStyle(fontSize: 26, color: Colors.white),
                    ),
                    const SizedBox(height: 8), // Espacio entre elementos
                    const Text('Nombre Medicamento:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 26)),
                    Text(tratamiento.nombreMedicamento!,
                        style:
                            const TextStyle(fontSize: 26, color: Colors.white)),
                    const SizedBox(height: 8), // Espacio entre elementos
                    const Text('Etapa del tratamiento:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 26)),
                    Text(tratamiento.etapa!,
                        style:
                            const TextStyle(fontSize: 26, color: Colors.white)),
                    const SizedBox(height: 8),
                    const Text('Descripcion del tratamiento :',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 26)),
                    Text(tratamiento.descripcion!,
                        style:
                            const TextStyle(fontSize: 26, color: Colors.white)),
                    const SizedBox(height: 8),
                    const Text('Frecuencia:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 26)),
                    Text('${tratamiento.frecuencia!}',
                        style:
                            const TextStyle(fontSize: 26, color: Colors.white)),
                            const Text('Tiempo:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 26)),
                    Text(tratamiento.tiempoDeLaMedicacion!,
                        style:
                            const TextStyle(fontSize: 26, color: Colors.white)),
                    const SizedBox(height: 8),
                    const Text('Parche o Lente:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 26)),
                    Text(tratamiento.lente! ==true
                          ?'Lente':'Parche',
                        style:
                            const TextStyle(fontSize: 26, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
