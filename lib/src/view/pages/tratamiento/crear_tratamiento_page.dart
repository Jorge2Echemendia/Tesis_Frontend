import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_3/src/controller/tratamiento_controller.dart';
import 'package:flutter_application_3/src/utils/my_color.dart';


class CrearTratamientoPage extends StatefulWidget {
  const CrearTratamientoPage({super.key});

  @override
  State<CrearTratamientoPage> createState() => _CrearTratamientoPageState();
}

class _CrearTratamientoPageState extends State<CrearTratamientoPage> {
  final TratamientoController _con = TratamientoController();
  String? _selected;
  String? _selectedNombre;
  String?_selectedTreatmentOption;
  bool _showParcheForm = false;
  bool _showLenteForm = false;
      final List<String> _treatmentOptions = ['Parche', 'Lente'];
    final List<Map<String, dynamic>> _treatment = [
    {
      'stage': 'Diagnóstico Inicial',
      'description':
          'Se han realizado pruebas para determinar el grado de miopía y se han establecido las primeras recomendaciones.'
    },
    {
      'stage': 'Tratamiento Activo',
      'description':
          'Se están aplicando tratamientos específicos, como el uso de gafas o lentes de contacto, y se programan seguimientos regulares.'
    },
    {
      'stage': 'Mantenimiento',
      'description':
          'Se revisa periódicamente la visión y se ajustan las correcciones ópticas según sea necesario.'
    },
    {
      'stage': 'Intervención Quirúrgica',
      'description':
          'Se ha considerado o realizado una cirugía para corregir la miopía.'
    },
    {
      'stage': 'Rehabilitación Visual',
      'description':
          'Se están llevando a cabo terapias visuales para mejorar la función ocular.'
    },
  ];


  @override
  void initState() {
    super.initState();

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
        'Nuevo Tratamiento',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 26,
        ),
        textAlign: TextAlign.center
      ),
      centerTitle: true,
    ),
    body: SingleChildScrollView( // Solo un SingleChildScrollView aquí
      child: Padding( // Usar Padding para darle espacio al principio y al final
        padding: const EdgeInsets.all(16), // Ajusta el valor según sea necesario
        child: Column(
          children: [
            _texFieliNameTratamiento(),
            const SizedBox(height: 10),
            _texFielNameMedicamento(),
            const SizedBox(height: 10),
            _etapa(),
            const SizedBox(height: 10),
            _texFielDescripcion(),
            const SizedBox(height: 10),
            _frecuencia(),
            const SizedBox(height: 10),
            _tiempodelaMedicacion(),
            const SizedBox(height: 10),
            _selectTreatmentOption(),
            const SizedBox(height: 10),
            _buttonCrear(),
          ],
        ),
      ),
    ),
  );
  }

  Widget _texFieliNameTratamiento() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: MyColor.primaryOpacityColor,
            borderRadius: BorderRadius.circular(30)),
        child: SizedBox(
          // Usa SizedBox para controlar la altura
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 0), // Haz que el contenido sea desplazabl
              child: DropdownButtonFormField<String>(
                value: _selectedNombre,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedNombre = newValue;
                    _con.nombreTratamientoController.text = newValue!;
                  });
                },
                items: <String>[
                  'Tratamiento Miopia Simple',
                  'Tratamiento Miopia Patológica',
                  'Tratamiento Miopia Congenita',
                  'Tratamiento Miopia Funcional',
                  'Tratamiento Miopia Nocturna',
                  'Tratamiento Miopia Alta'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                      value: value, child: Text(value));
                }).toList(),
                decoration: InputDecoration(
                  hintText: 'Seleccione tipo de tratamiento',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: MyColor.primaryColorDark),
                  prefixIcon:
                      Icon(Icons.medical_services, color: MyColor.primaryColor),
                ),
              ),
            ),
          ),
        ));
  }

    Widget _texFielDescripcion() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
          color: MyColor.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        maxLines: 3,
        maxLength: 255,
        controller: _con.descripcionController,
        decoration: InputDecoration(
            hintText: 'Descripcion del Proceso',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
            hintStyle: TextStyle(color: MyColor.primaryColorDark),
            prefixIcon: Icon(Icons.person, color: MyColor.primaryColor)),
      ),
    );
  }

  Widget _texFielNameMedicamento() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
          color: MyColor.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _con.nombreMedicamentoController,
        decoration: InputDecoration(
            hintText: 'Nombre Mediacamento',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
            hintStyle: TextStyle(color: MyColor.primaryColorDark),
            prefixIcon: Icon(Icons.person, color: MyColor.primaryColor)),
      ),
    );
  }

Widget _frecuencia() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 30),
    decoration: BoxDecoration(
        color: MyColor.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30)),
    child: TextField(
      controller: _con.frecuenciaController,
      keyboardType:TextInputType.number,
      decoration: InputDecoration(
          hintText: 'Cada cuantos dias',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
          hintStyle: TextStyle(color: MyColor.primaryColorDark),
        prefixIcon: Icon(Icons.access_time, color: MyColor.primaryColor),
          ),
    ),
  );
}

  Widget _buttonCrear() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 70, vertical: 30),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: _con.crearTratamiento,
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColor.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            ),
            child: const Text(
              'Crear Tratamiento',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
  Widget  _tiempodelaMedicacion() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 30),
    decoration: BoxDecoration(
        color: MyColor.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30)),
    child: TextField(
      keyboardType:TextInputType.none,
      controller: _con.tiempoDeLaMedicacionController,
      decoration: InputDecoration(
          hintText: 'Intervalo del Medicamento',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
          hintStyle: TextStyle(color: MyColor.primaryColorDark),
          prefixIcon: Icon(Icons.access_time, color: MyColor.primaryColor),
          ),
          onTap: () async {
              final TimeOfDay?picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (picked != null) {
                setState(() {
                  _con.tiempoDeLaMedicacionController.text =
                      "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
                });
              }
            },
            ),
    );
  }
  Widget _etapa(){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: MyColor.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            value: _selected,
            onChanged: (String? newValue) {
              setState(() {
                _selected = newValue;
                _con.etapaController.text = newValue!;
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
              hintText: 'Seleccione Etapa ',
              prefixIcon: Icon(Icons.medical_information,color: MyColor.primaryColor,),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(10),
              hintStyle: TextStyle(color: MyColor.primaryColorDark),
            ),
          ),
          const SizedBox(height: 10),
          _selected != null
              ? Container(
                  constraints: const BoxConstraints(maxHeight: 80),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          _treatment.singleWhere((element) =>
                              element['stage'] ==
                              _selected)['description']!,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
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
            if (newValue == 'Parche') {
              _showParcheForm = true;
              _con.parcheController.text = 'true';
              _showLenteForm = false;
              _con.lenteController.text = 'false';
            } else if (newValue == 'Lente') {
              _showParcheForm = false;
              _con.parcheController.text = 'false';
              _showLenteForm = true;
              _con.lenteController.text = 'true';
            } else {
              _showParcheForm = false;
              _con.parcheController.text = 'false';
              _showLenteForm = false;
              _con.lenteController.text = 'false';
            }
          });
        },
        items: _treatmentOptions.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
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