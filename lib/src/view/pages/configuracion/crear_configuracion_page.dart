import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_3/src/controller/configuracion_controller.dart';
import 'package:flutter_application_3/src/utils/my_color.dart';

class CrearConfiguracionPage extends StatefulWidget {
  const CrearConfiguracionPage({super.key});

  @override
  State<CrearConfiguracionPage> createState() => _CrearConfiguracionPageState();
}

class _CrearConfiguracionPageState extends State<CrearConfiguracionPage> {
  final ConfiguracionController _controller = ConfiguracionController();
      String? _selectedStage;
      String? _selectedAfeccion;
      String?_selectedTreatmentOption;
      bool _showParcheForm = false;
      bool _showLenteForm = false;
      final List<String> _treatmentOptions = ['Parche', 'Lente'];
      final List<Map<String, dynamic>> _treatmentStages = [
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
      backgroundColor: MyColor.primaryColor,
      title: const Text(
        'Nuevo Tiempo Recomendable',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        textAlign: TextAlign.center
      ),
      centerTitle: true,
    ),
    body:Center(
      child:  SingleChildScrollView( // Solo un SingleChildScrollView aquí
      child: Padding( // Usar Padding para darle espacio al principio y al final
        padding: const EdgeInsets.all(16), // Ajusta el valor según sea necesario
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          _afeccion(),
          const SizedBox(height: 10),
          _tiempoMaximo(),
          const SizedBox(height: 10),
          _etapaDeratamiento(),
          const SizedBox(height: 10),
          _selectTreatmentOption(),
          _buttonCrear(),
          ],),
          
        ),
      ),
    ),)
  );
  }
  Widget _afeccion() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 50),
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
                value: _selectedAfeccion,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedAfeccion = newValue;
                    _controller.afeccionController.text = newValue!;
                  });
                },
                items: <String>[
                  'Simple',
                  'Patológica',
                  'Congenita',
                  'Funcional',
                  'Nocturna',
                  'Alta'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                      value: value, child: Text(value));
                }).toList(),
                decoration: InputDecoration(
                  hintText: 'Seleccione la afección',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(
                      15), // Ajusta el relleno del contenido según sea necesario
                  hintStyle: TextStyle(color: MyColor.primaryColorDark),
                  prefixIcon:
                      Icon(Icons.medical_services, color: MyColor.primaryColor),
                ),
              ),
            ),
          ),
        ));
  }

Widget _tiempoMaximo() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 50),
    decoration: BoxDecoration(
      color: MyColor.primaryOpacityColor,
      borderRadius: BorderRadius.circular(30),
    ),
    child: TextField(
      readOnly: true, // Hacer el TextField de solo lectura
      controller: _controller.tiempomaximoController,
      decoration: InputDecoration(
        hintText: 'Tiempo Recomendado',
        border: InputBorder.none,
        contentPadding: const EdgeInsets.all(15),
        hintStyle: TextStyle(color: MyColor.primaryColorDark),
        prefixIcon: Icon(Icons.access_time, color: MyColor.primaryColor),
      ),
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), // Forzar formato de 24 horas
              child: child!,
            );
          },
        );
        if (picked != null) {
          setState(() {
            _controller.tiempomaximoController.text =
                "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
          });
        }
      },
    ),
  );
}

  Widget _etapaDeratamiento() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: MyColor.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            value: _selectedStage,
            onChanged: (String? newValue) {
              setState(() {
                _selectedStage = newValue;
                _controller.etapaController.text = newValue!;
              });
            },
            items: _treatmentStages
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
              prefixIcon: Icon(
                Icons.medical_information,
                color: MyColor.primaryColor,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(10),
              hintStyle: TextStyle(color: MyColor.primaryColorDark),
            ),
          ),
          const SizedBox(height: 10),
          _selectedStage != null
              ? Container(
                  constraints: const BoxConstraints(maxHeight: 80),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          _treatmentStages.singleWhere((element) =>
                              element['stage'] ==
                              _selectedStage)['description']!,
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
              _controller.parcheController.text = 'true';
              _showLenteForm = false;
              _controller.lenteController.text = 'false';
            } else if (newValue == 'Lente') {
              _showParcheForm = false;
              _controller.parcheController.text = 'false';
              _showLenteForm = true;
              _controller.lenteController.text = 'true';
            } else {
              _showParcheForm = false;
              _controller.parcheController.text = 'false';
              _showLenteForm = false;
              _controller.lenteController.text = 'false';
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


  Widget _buttonCrear() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 70, vertical: 30),
      child: Column(
        children: [
          ElevatedButton(
            onPressed:_controller.crear,
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColor.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            ),
            child: const Text(
              ' Listo',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
