import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_3/connection_manager.dart';
import 'package:flutter_application_3/src/controller/tratamiento_controller.dart';
import 'package:flutter_application_3/src/model/paciente.dart';
import 'package:flutter_application_3/src/model/tratamiento.dart';
import 'package:flutter_application_3/src/utils/my_color.dart';

class TratamientoDetalleClientePage extends StatefulWidget {
  final List<Tratamiento> tratamientos;
  final Paciente paciente;
  const TratamientoDetalleClientePage(
      {super.key, required this.tratamientos, required this.paciente});

  @override
  State<TratamientoDetalleClientePage> createState() =>
      _TratamientoDetalleClientePageState();
}

class _TratamientoDetalleClientePageState
    extends State<TratamientoDetalleClientePage> {
  final TratamientoController _con = TratamientoController();
  final bool _visible = false;
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
    final List<Tratamiento> tratamientos = widget.tratamientos;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.primaryColor,
        title: const Text(
          'Tratamientos',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ...widget.tratamientos.asMap().entries.map((entry) {
                final tratamiento = entry.value;
                return Card(
                  elevation: 10,
                  shadowColor: Colors.black.withOpacity(0.5),
                  color: MyColor.primaryOpacityColor,
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tratamiento #${entry.key + 1}:',
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        const Text('Nombre Tratamiento:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        Text(
                          tratamiento.nombreTratamiento ?? 'No disponible',
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black),
                        ),
                        const SizedBox(height: 8),
                        const Text('Nombre Medicamento:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        Text(tratamiento.nombreMedicamento ?? 'No disponible',
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black)),
                        const SizedBox(height: 8),
                        const Text('Descripción del tratamiento:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        Text(tratamiento.descripcion ?? 'No disponible',
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black)),
                        const SizedBox(height: 8),
                        const Text('Frecuencia:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        Text('${tratamiento.frecuencia ?? 'No disponible'}',
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black)),
                        const SizedBox(height: 8),
                        const Text('Tiempo:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        Text(
                            tratamiento.tiempoDeLaMedicacion ?? 'No disponible',
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black)),
                        const SizedBox(height: 8),
                        _horaProgramada(tratamiento),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: _crearBotonModificar(
                                    tratamiento, paciente)),
                            const SizedBox(
                                width: 8), // Espacio entre los botones
                            _crearBotonEliminar(
                                tratamiento, paciente, tratamientos),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }),
              _tratamientosNuevos(paciente),
            ],
          ),
        ),
      ),
    );
  }

  Widget _crearBotonModificar(Tratamiento tratamiento, Paciente paciente) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45,
      height: 50,
      child: ElevatedButton(
        onPressed: () => _con.modificar(paciente, tratamiento),
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColor.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Empezar',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget _crearBotonEliminar(Tratamiento tratamiento, Paciente paciente,
      List<Tratamiento> tratamientos) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45,
      height: 50,
      child: ElevatedButton(
        onPressed: () => {
          _con.removeAt(tratamiento, paciente, tratamientos),
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

  Widget _horaProgramada(Tratamiento tratamiento) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(30)),
      child: TextField(
        keyboardType: TextInputType.none,
        controller: _con.horaProgramadaController,
        decoration: InputDecoration(
          hintText: 'Hora Programada',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
          hintStyle: const TextStyle(color: Colors.black),
          prefixIcon: Icon(Icons.access_time, color: MyColor.primaryColor),
        ),
        onTap: () async {
          final TimeOfDay? picked = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (picked != null) {
            setState(() {
              // Obtenemos la fecha actual
              DateTime now = DateTime.now();
              // Crear un objeto DateTime con la hora seleccionada
              DateTime selectedTime = DateTime(
                now.year,
                now.month,
                now.day,
                picked.hour,
                picked.minute,
              );

              // Si deseas convertir a UTC, puedes hacerlo así:
              DateTime utcTime = selectedTime.toLocal();

              // Formatear la fecha y hora
              String formattedDate =
                  "${utcTime.year}-${utcTime.month.toString().padLeft(2, '0')}-${utcTime.day.toString().padLeft(2, '0')} ${utcTime.hour.toString().padLeft(2, '0')}:${utcTime.minute.toString().padLeft(2, '0')}";

              // Actualizamos el texto del controller con la fecha y hora
              _con.horaProgramadaController.text = formattedDate;
            });
          }
        },
      ),
    );
  }

  Widget _tratamientosNuevos(Paciente paciente) {
    return Column(
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.refresh),
          label: const Text('Nuevos tratamientos'),
          onPressed: () {
            _con.listarTratamientoNuevos(paciente);
            refresh();
          },
        ),
        const SizedBox(height: 16),
        if (_con.tratamientoActualizado.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            itemCount: _con.tratamientoActualizado.length,
            itemBuilder: (context, index) {
              final tratamiento = _con.tratamientoActualizado[index];
              return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Card(
                    elevation: 5,
                    color: MyColor.primaryOpacityColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tratamiento #${index + 1}',
                            style: const TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Nombre Medicamento: ${tratamiento.nombreMedicamento}',
                            style: const TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Descripcion: ${tratamiento.descripcion}',
                            style: const TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.touch_app),
                                onPressed: () {
                                  _con.ponerIDpaciente(paciente, tratamiento);
                                  _con.listarTratamientoCliente(paciente);
                                  refresh();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ));
            },
          )
        else
          const Center(child: Text('No hay tratamientos nuevos')),
      ],
    );
  }
}
