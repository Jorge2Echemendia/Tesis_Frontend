import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_3/src/controller/notas_controller.dart';
import 'package:flutter_application_3/src/model/paciente.dart';
import 'package:flutter_application_3/src/utils/my_color.dart';

class CrearNotas extends StatefulWidget {
  final Paciente paciente;
  const CrearNotas({super.key, required this.paciente});

  @override
  State<CrearNotas> createState() => _CrearNotasState();
}

class _CrearNotasState extends State<CrearNotas> {
  final NotasController _controller = NotasController();
  String? _selectedTreatmentOption;
  bool _showRecordatorioForm = false;
  bool _showContinuaForm = false;
  final List<String> _treatmentOptions = ['Notas', 'Recordatorio', 'Continua'];
  final List<Map<String, dynamic>> _treatment = [
    {
      'stage': 'Notas',
      'description':
          'Si desea almacenar alguna que otra informacion sobre el paciente .'
    },
    {
      'stage': 'Recordatorio',
      'description':
          'Alguna nota que contenga informacion que desea llevar a cabo en algun momento.'
    },
    {
      'stage': 'Continua',
      'description':
          'Alguna nota que contenga informacion que desea llevar en repetidos momentos.'
    },
  ];

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
    final Paciente paciente = widget.paciente;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.primaryColor,
        title: const Text('Nueva Nota',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 26,
            ),
            textAlign: TextAlign.center),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // Solo un SingleChildScrollView aquí
        child: Padding(
          // Usar Padding para darle espacio al principio y al final
          padding: const EdgeInsets.all(16), // Ajusta el valor según sea necesario
          child: Column(
            children: [
              _texFieliName(),
              const SizedBox(height: 10),
              _texFielMotivo(),
              const SizedBox(height: 10),
              _texFielContenido(),
              const SizedBox(height: 10),
              _selectTreatmentOption(),
              const SizedBox(height: 10),
              _horaProgramada(),
              const SizedBox(height: 10),
              _frecuencia(),
              const SizedBox(height: 10),
              _texFielTiempo(),
              _buttonCrear(paciente)
            ],
          ),
        ),
      ),
    );
  }

  Widget _texFieliName() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(
          color: MyColor.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _controller.nombreController,
        decoration: InputDecoration(
            hintText: 'Nombre o Referencia',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
            hintStyle: TextStyle(color: MyColor.primaryColorDark),
            prefixIcon: Icon(Icons.person, color: MyColor.primaryColor)),
      ),
    );
  }

  Widget _texFielMotivo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
          color: MyColor.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        maxLines: 3,
        maxLength: 255,
        controller: _controller.motivoController,
        decoration: InputDecoration(
            hintText: 'Motivo de la Nota',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
            hintStyle: TextStyle(color: MyColor.primaryColorDark),
            prefixIcon: Icon(Icons.person, color: MyColor.primaryColor)),
      ),
    );
  }

  Widget _texFielContenido() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
          color: MyColor.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        maxLines: 3,
        maxLength: 255,
        controller: _controller.contenidoController,
        decoration: InputDecoration(
            hintText: 'Contenido',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
            hintStyle: TextStyle(color: MyColor.primaryColorDark),
            prefixIcon: Icon(Icons.person, color: MyColor.primaryColor)),
      ),
    );
  }

  Widget _texFielTiempo() {
    if (!_showContinuaForm) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
          color: MyColor.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        keyboardType: TextInputType.none,
        controller: _controller.tiempoMaximoController,
        decoration: InputDecoration(
          hintText: 'Intervalo del Medicamento',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
          hintStyle: TextStyle(color: MyColor.primaryColorDark),
          prefixIcon: Icon(Icons.access_time, color: MyColor.primaryColor),
        ),
        onTap: () async {
          final TimeOfDay? picked = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (picked != null) {
            setState(() {
              _controller.tiempoMaximoController.text =
                  "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
            });
          }
        },
      ),
    );
  }

  Widget _frecuencia() {
    if (!_showContinuaForm) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
          color: MyColor.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _controller.frecuenciaController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'Cuantas veces',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
          hintStyle: TextStyle(color: MyColor.primaryColorDark),
          prefixIcon: Icon(Icons.access_time, color: MyColor.primaryColor),
        ),
      ),
    );
  }

Widget _horaProgramada() {
    if (!_showRecordatorioForm && !_showContinuaForm) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
          color: MyColor.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _controller.horaProgramadaController,
        readOnly: true,
        decoration: InputDecoration(
          hintText: 'Fecha y Hora',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
          hintStyle: const TextStyle(color: Colors.black),
          prefixIcon: Icon(Icons.calendar_today, color: MyColor.primaryColor),
        ),
        onTap: () async {
          final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );
          
          if (pickedDate != null) {
            // Mostramos el selector de hora fuera del setState
            TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );

            if (pickedTime != null) {
              // Creamos una nueva fecha con la hora seleccionada
              DateTime selectedDateTime = DateTime(
                pickedDate.year,
                pickedDate.month,
                pickedDate.day,
                pickedTime.hour,
                pickedTime.minute,
              );

              // Formatear la fecha y hora
              String formattedDate =
                  "${selectedDateTime.year}-${selectedDateTime.month.toString().padLeft(2, '0')}-${selectedDateTime.day.toString().padLeft(2, '0')} ${selectedDateTime.hour.toString().padLeft(2, '0')}:${selectedDateTime.minute.toString().padLeft(2, '0')}";

              // Actualizamos el estado de manera síncrona
              setState(() {
                _controller.horaProgramadaController.text = formattedDate;
              });
            }
          }
        },
      ),
    );
  }
  Widget _buttonCrear(Paciente paciente) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 70, vertical: 30),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              _controller.crearNota(paciente);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColor.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
            ),
            child: const Text(
              'Crear Nota',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectTreatmentOption() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(
          color: MyColor.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: DropdownButtonFormField<String>(
        value: _selectedTreatmentOption,
        onChanged: (String? newValue) {
          setState(() {
            _selectedTreatmentOption = newValue;
            if (newValue == 'Recordatorio') {
              _showRecordatorioForm = true;
              _controller.recordatorioController.text = 'true';
              _showContinuaForm = false;
              _controller.recordatorioContinuoController.text = 'false';
            } else if (newValue == 'Continua') {
              _showRecordatorioForm = false;
              _controller.recordatorioController.text = 'false';
              _showContinuaForm = true;
              _controller.recordatorioContinuoController.text = 'true';
            } else {
              _showRecordatorioForm = false;
              _controller.recordatorioController.text = 'false';
              _showContinuaForm = false;
              _controller.recordatorioContinuoController.text = 'false';
            }
          });
        },
        items: _treatment
            .map<DropdownMenuItem<String>>((Map<String, dynamic> stage) {
          return DropdownMenuItem<String>(
            value: stage['stage'],
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(stage['stage']),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(stage['stage']),
                          content: Text(stage['description']),
                          actions: [
                            TextButton(
                              child: const Text('Cerrar'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Icon(Icons.info_outline,
                      size: 18, color: MyColor.primaryColor),
                ),
              ],
            ),
          );
        }).toList(),
        decoration: InputDecoration(
          labelText: 'Seleccione una opción',
          prefixIcon:
              Icon(Icons.local_hospital, color: MyColor.primaryColorDark),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
          hintStyle: TextStyle(color: MyColor.primaryColorDark),
        ),
      ),
    );
  }
}
