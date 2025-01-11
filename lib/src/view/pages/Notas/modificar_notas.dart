import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_3/connection_manager.dart';
import 'package:flutter_application_3/src/controller/notas_controller.dart';
import 'package:flutter_application_3/src/model/notas.dart';
import 'package:flutter_application_3/src/model/paciente.dart';
import 'package:flutter_application_3/src/utils/my_color.dart';

class ModificarNotas extends StatefulWidget {
  final Notas notas;
  final Paciente paciente;
  const ModificarNotas(
      {super.key, required this.notas, required this.paciente});

  @override
  State<ModificarNotas> createState() => _ModificarNotasState();
}

class _ModificarNotasState extends State<ModificarNotas> {
  final NotasController _con = NotasController();
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
    final Notas notas = widget.notas;
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
                    const Text('Nombre de la Nota:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 26)),
                    Text(
                      notas.nombreDeNotas!,
                      style: const TextStyle(fontSize: 26, color: Colors.white),
                    ),
                    const SizedBox(height: 8), // Espacio entre elementos
                    const Text('Motivo:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 26)),
                    Text(notas.motivo!,
                        style:
                            const TextStyle(fontSize: 26, color: Colors.white)),
                    const SizedBox(height: 8),
                    const Text('Descripción de la nota o Contenido:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 26)),
                    Text(notas.contenido!,
                        style:
                            const TextStyle(fontSize: 26, color: Colors.white)),
                    const SizedBox(height: 8),
                    _renderConditionals(notas),
                    Column(
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
                        _buttonModificar(notas,paciente)
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _texFieliName() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: MyColor.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _con.nombreController,
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
        controller: _con.motivoController,
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
        controller: _con.contenidoController,
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
        controller: _con.tiempoMaximoController,
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
              _con.tiempoMaximoController.text =
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
        controller: _con.frecuenciaController,
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
        controller: _con.horaProgramadaController,
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
                _con.horaProgramadaController.text = formattedDate;
              });
            }
          }
        },
      ),
    );
  }

  Widget _buttonModificar(Notas nota, Paciente paciente) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              _con.modificar(nota, paciente);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColor.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
            ),
            child: const Text(
              'Modificar Nota',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectTreatmentOption() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
              _con.recordatorioController.text = 'true';
              _showContinuaForm = false;
              _con.recordatorioContinuoController.text = 'false';
            } else if (newValue == 'Continua') {
              _showRecordatorioForm = false;
              _con.recordatorioController.text = 'false';
              _showContinuaForm = true;
              _con.recordatorioContinuoController.text = 'true';
            } else {
              _showRecordatorioForm = false;
              _con.recordatorioController.text = 'false';
              _showContinuaForm = false;
              _con.recordatorioContinuoController.text = 'false';
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

  Widget _renderConditionals(Notas notas) {
    List<Widget> conditionals = [];

    if (notas.recordatorio == true || notas.recordatorioContinuo == true) {
      conditionals.add(const Text('  Hora y Fecha programada:',
          style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 26)));
      conditionals.add(Text(
          notas.horaProgramada?.toString() ?? 'No disponible',
          style:  const TextStyle(fontSize: 26, color: Colors.white)));
    }

    if (notas.recordatorioContinuo == true) {
      conditionals.add(const Text('Cantidad de veces:',
          style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 26)));
      conditionals.add(Text('${notas.frecuencia ?? 'No disponible'}',
          style: const TextStyle(fontSize: 26, color: Colors.white)));
      conditionals.add(const SizedBox(height: 8));
      conditionals.add(const Text('Tiempo de intervalo:',
          style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 26)));
      conditionals.add(
        Text(notas.tiempoMaximoDia ?? 'No disponible',
            style: const TextStyle(fontSize: 26, color: Colors.white)),
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
