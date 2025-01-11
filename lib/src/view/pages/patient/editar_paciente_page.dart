import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_3/src/controller/paciente_controller.dart';
import 'package:flutter_application_3/src/model/paciente.dart';
import 'package:flutter_application_3/src/utils/my_color.dart';
import 'package:intl/intl.dart';

class EditarPacientePage extends StatefulWidget {
  final Paciente paciente;
  const EditarPacientePage({super.key, required this.paciente});

  @override
  State<EditarPacientePage> createState() => _EditarPacientePageState();
}

class _EditarPacientePageState extends State<EditarPacientePage> {
  final PacienteController _con = PacienteController();
  String? _selectedStage;
  String? _selectedAfeccion;
  String? _selectedTreatmentOption;
  String? _selectedCirujia;
  bool _showParcheForm = false;
  bool _showLenteForm = false;
  bool _showInicialForm = false;
  bool _showTratamientoForm = false;
  bool _showMantenimientoForm = false;
  bool _showIntervencionForm = false;
  bool _showRehabilitacionForm = false;

  final List<String> _treatmentOptions = ['Parche', 'Lente'];
  final List<String> _parcheTypes = ['"Parche oclusor', 'Parche terapéutico'];
  final List<String> _lenteTypes = ['Lentes correctivos', 'Lentes de contacto'];
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
    print("Inicializando PacientePage");
    SchedulerBinding.instance.addPostFrameCallback((_) {
      print("Llamada a init del controlador");
      _con.init(context, refresh);
    });
  }

  void refresh() {
    print("Actualizando UI");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Paciente paciente = widget.paciente;
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final String fechaFormateada = formatter.format(paciente.fechaNacimiento!);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.primaryColor,
        title: const Text(
          'Actualize su Paciente',
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
                            fontWeight: FontWeight.bold, fontSize: 18)),
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
                    _primeraEtapa(paciente),
                    _segundaEtapa(paciente),
                    _terceraEtapa(paciente),
                    _cuartaEtapa(paciente),
                    _quintaEtapa(paciente),
                    const SizedBox(height: 8),
                    _parcheeOlente(paciente),
                    Column(
                      children: [
                        _texFieliName(),
                        const SizedBox(height: 10),
                        _texFielApellido(),
                        const SizedBox(height: 10),
                        _texFielApellidoSegundo(),
                        const SizedBox(height: 10),
                        _afeccion(),
                        const SizedBox(height: 10),
                        _fechaNacimiento(),
                        const SizedBox(height: 10),
                        _etapaDeratamiento(),
                        const SizedBox(height: 10),
                        _buildDiagnosticoInicialForm(),
                        _buildTratamientoActivoForm(),
                        _buildMantenimientoForm(),
                        _buildIntervencionQuirurgicaForm(),
                        _buildRehabilitacionVisualForm(),
                        const SizedBox(height: 10),
                        _selectTreatmentOption(),
                        const SizedBox(height: 10),
                        _formBuilderParche(),
                        _formBuilderLente(),
                        _buttonCrear(paciente),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _primeraEtapa(Paciente paciente) {
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

  Widget _segundaEtapa(Paciente paciente) {
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

  Widget _terceraEtapa(Paciente paciente) {
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

  Widget _cuartaEtapa(Paciente paciente) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final String fechaFormateada2 = formatter.format(paciente.cirujiaFecha!);
    if (paciente.etapaDeTratamiento! != 'Intervención Quirúrgica') {
      return const SizedBox.shrink();
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

  Widget _quintaEtapa(Paciente paciente) {
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

  Widget _parcheeOlente(Paciente paciente) {
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

  Widget _texFieliName() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(
          color: MyColor.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _con.nombreController,
        decoration: InputDecoration(
            hintText: 'Nombre',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
            hintStyle: TextStyle(color: MyColor.primaryColorDark),
            prefixIcon: Icon(Icons.person, color: MyColor.primaryColor)),
      ),
    );
  }

  Widget _texFielApellido() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(
          color: MyColor.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _con.apellidoController,
        decoration: InputDecoration(
            hintText: 'Apellido',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
            hintStyle: TextStyle(color: MyColor.primaryColorDark),
            prefixIcon:
                Icon(Icons.person_outlined, color: MyColor.primaryColor)),
      ),
    );
  }

  Widget _texFielApellidoSegundo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(
          color: MyColor.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _con.apellidoSegundoController,
        decoration: InputDecoration(
            hintText: 'Apellido Segundo',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
            hintStyle: TextStyle(color: MyColor.primaryColorDark),
            prefixIcon:
                Icon(Icons.person_3_outlined, color: MyColor.primaryColor)),
      ),
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
                    _con.afeccionController.text = newValue!;
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

  Widget _fechaNacimiento() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(
          color: MyColor.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _con.fechaNacimientoController,
        decoration: InputDecoration(
            hintText: 'Fecha de Nacimiento',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
            hintStyle: TextStyle(color: MyColor.primaryColorDark),
            prefixIcon:
                Icon(Icons.calendar_today, color: MyColor.primaryColor)),
        keyboardType:
            TextInputType.none, // Especifica el tipo de teclado para fechas
        onTap: () async {
          DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(), // Fecha inicial predeterminada
            firstDate: DateTime(2010), // Fecha mínima permitida
            lastDate: DateTime.now(), // Fecha máxima permitida
          );
          if (picked != null && picked != DateTime.now()) {
            setState(() {
              _con.fechaNacimientoController.text =
                  DateFormat("yyyy-MM-dd").format(picked);
              print('Fecha:${_con.fechaNacimientoController}');
            });
          }
        },
      ),
    );
  }

  Widget _etapaDeratamiento() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
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
                _con.etapaDeTratamientoController.text = newValue!;
                _updateFormFields(_selectedStage!);
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

  void _updateFormFields(String selectedStage) {
    setState(() {
      _showInicialForm = false;
      _showTratamientoForm = false;
      _showMantenimientoForm = false;
      _showIntervencionForm = false;
      _showRehabilitacionForm = false;
      switch (selectedStage) {
        case 'Diagnóstico Inicial':
          _showInicialForm = true;
          break;
        case 'Tratamiento Activo':
          _showTratamientoForm = true;
          break;
        case 'Mantenimiento':
          _showMantenimientoForm = true;
          break;
        case 'Intervención Quirúrgica':
          _showIntervencionForm = true;
          break;
        case 'Rehabilitación Visual':
          _showRehabilitacionForm = true;
          break;
      }
    });
  }

  Widget _buildDiagnosticoInicialForm() {
    if (!_showInicialForm) return const SizedBox.shrink();
    refresh();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
          color: MyColor.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _con.fechaDiagnosticoController,
            decoration: InputDecoration(
                labelText: 'Fecha del diagnóstico:',
                hintText: 'Ingrese la fecha del diagnóstico',
                hintStyle: TextStyle(color: MyColor.primaryColorDark),
                prefixIcon:
                    Icon(Icons.calendar_today, color: MyColor.primaryColor),
                border: const OutlineInputBorder()),
            keyboardType:
                TextInputType.none, // Especifica el tipo de teclado para fechas
            onTap: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(), // Fecha inicial predeterminada
                firstDate: DateTime(2010), // Fecha mínima permitida
                lastDate: DateTime.now(), // Fecha máxima permitida
              );
              if (picked != null && picked != DateTime.now()) {
                setState(() {
                  _con.fechaDiagnosticoController.text =
                      DateFormat("yyyy-MM-dd").format(picked);
                });
              }
            },
            onChanged: (text) => (),
          ),
          const SizedBox(height: 10),
          TextField(
            maxLines: 3,
            maxLength: 255,
            controller: TextEditingController.fromValue(
                TextEditingValue(text: _con.gradoMiopiaController.text)),
            decoration: InputDecoration(
              labelText: 'Grado de miopía:',
              hintText: 'Ingrese el grado de miopía',
              hintStyle: TextStyle(color: MyColor.primaryColorDark),
              prefixIcon: Icon(
                Icons.visibility,
                color: MyColor.primaryColor,
              ),
              border: const OutlineInputBorder(),
            ),
            onChanged: (text) => _con.gradoMiopiaController.text = text,
          ),
          const SizedBox(height: 10),
          TextField(
            maxLines: 3,
            maxLength: 255,
            controller: TextEditingController.fromValue(
                TextEditingValue(text: _con.examenesController.text)),
            decoration: InputDecoration(
              labelText: 'Exámenes realizados:',
              hintText: 'Ingrese los exámenes realizados',
              hintStyle: TextStyle(color: MyColor.primaryColorDark),
              border: const OutlineInputBorder(),
            ),
            onChanged: (text) => _con.examenesController.text = text,
          ),
          const SizedBox(height: 10),
          TextField(
            maxLines: 3,
            maxLength: 255,
            controller: TextEditingController.fromValue(
                TextEditingValue(text: _con.recomendacionesController.text)),
            decoration: InputDecoration(
              labelText: 'Recomendaciones iniciales:',
              hintText: 'Ingrese las recomendaciones',
              hintStyle: TextStyle(color: MyColor.primaryColorDark),
              border: const OutlineInputBorder(),
            ),
            onChanged: (text) => _con.recomendacionesController.text = text,
          ),
        ],
      ),
    );
  }

  Widget _buildTratamientoActivoForm() {
    if (!_showTratamientoForm) return const SizedBox.shrink();
    refresh();
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
            color: MyColor.primaryOpacityColor,
            borderRadius: BorderRadius.circular(30)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          TextField(
            maxLines: 3,
            maxLength: 255,
            controller: TextEditingController.fromValue(
                TextEditingValue(text: _con.correccionOpticaController.text)),
            decoration: InputDecoration(
              labelText: 'Tipo de corrección óptica:',
              hintText: 'Gafas, lentes de contacto o ambos',
              hintStyle: TextStyle(color: MyColor.primaryColorDark),
              //  prefixIcon: Icon(Icons.eye),
              border: const OutlineInputBorder(),
            ),
            onChanged: (text) => _con.correccionOpticaController.text = text,
          ),
          const SizedBox(height: 10),
          TextField(
            maxLines: 3,
            maxLength: 255,
            controller: TextEditingController.fromValue(
                TextEditingValue(text: _con.ejerciciosVisualesController.text)),
            decoration: InputDecoration(
              labelText: 'Ejercicios visuales recomendados:',
              hintText: 'Detalles sobre ejercicios oculares a realizar en casa',
              hintStyle: TextStyle(color: MyColor.primaryColorDark),
              prefixIcon: Icon(
                Icons.visibility,
                color: MyColor.primaryColor,
              ),
              border: const OutlineInputBorder(),
            ),
            onChanged: (text) => _con.ejerciciosVisualesController.text = text,
          ),
        ]));
  }

  Widget _buildMantenimientoForm() {
    if (!_showMantenimientoForm) return const SizedBox.shrink();
    refresh();
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
            color: MyColor.primaryOpacityColor,
            borderRadius: BorderRadius.circular(30)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          TextField(
            maxLines: 3,
            maxLength: 255,
            controller: TextEditingController.fromValue(
                TextEditingValue(text: _con.cambioOpticoController.text)),
            decoration: InputDecoration(
              labelText: 'Cambios en la corrección óptica:',
              hintText: 'Registro de ajustes en la graduación de lentes',
              hintStyle: TextStyle(color: MyColor.primaryColorDark),
              prefixIcon: Icon(
                Icons.tune,
                color: MyColor.primaryColor,
              ),
              border: const OutlineInputBorder(),
            ),
            onChanged: (text) => _con.cambioOpticoController.text = text,
          ),
          const SizedBox(height: 10),
          TextField(
            maxLines: 3,
            maxLength: 255,
            controller: TextEditingController.fromValue(
                TextEditingValue(text: _con.consejosHigieneController.text)),
            decoration: InputDecoration(
              labelText: 'Consejos de higiene visual:',
              hintText:
                  'Recuerdos sobre hábitos saludables para proteger la vista',
              hintStyle: TextStyle(color: MyColor.primaryColorDark),
              prefixIcon: Icon(Icons.warning_amber_outlined,
                  color: MyColor.primaryColor),
              border: const OutlineInputBorder(),
            ),
            onChanged: (text) => _con.consejosHigieneController.text = text,
          ),
        ]));
  }

  Widget _buildIntervencionQuirurgicaForm() {
    if (!_showIntervencionForm) return const SizedBox.shrink();
    refresh();
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
            color: MyColor.primaryOpacityColor,
            borderRadius: BorderRadius.circular(30)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          DropdownButtonFormField<String>(
            value: _selectedCirujia,
            onChanged: (String? newValue) {
              setState(() {
                _selectedCirujia = newValue;
                _con.cirujiaController.text = newValue!;
              });
            },
            items: <String>[
              'LASIK',
              'Ortoqueratología',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            decoration: InputDecoration(
              labelText: 'Tipo de cirugía:',
              hintText: 'Seleccione el tipo de cirugía',
              hintStyle: TextStyle(color: MyColor.primaryColorDark),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _con.cirujiaFechaController,
            decoration: InputDecoration(
              labelText: 'Fecha de la cirugía:',
              hintText: 'Ingrese la fecha de la intervención',
              hintStyle: TextStyle(color: MyColor.primaryColorDark),
              prefixIcon: Icon(
                Icons.date_range,
                color: MyColor.primaryColor,
              ),
              border: const OutlineInputBorder(),
            ),
            keyboardType:
                TextInputType.none, // Especifica el tipo de teclado para fechas
            onTap: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(), // Fecha inicial predeterminada
                firstDate: DateTime(2010), // Fecha mínima permitida
                lastDate: DateTime.now(), // Fecha máxima permitida
              );
              if (picked != null && picked != DateTime.now()) {
                setState(() {
                  _con.cirujiaFechaController.text =
                      DateFormat("yyyy-MM-dd").format(picked);
                });
              }
            },
            onChanged: (text) => (),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: TextEditingController.fromValue(
                TextEditingValue(text: _con.cirujiaResultadosController.text)),
            decoration: InputDecoration(
              labelText: 'Resultados postoperatorios:',
              hintText:
                  'Describe los resultados obtenidos después de la cirugía',
              hintStyle: TextStyle(color: MyColor.primaryColorDark),
              prefixIcon:
                  Icon(Icons.check_circle_outline, color: MyColor.primaryColor),
              border: const OutlineInputBorder(),
            ),
            onChanged: (text) => _con.cirujiaResultadosController.text = text,
          ),
        ]));
  }

  Widget _buildRehabilitacionVisualForm() {
    if (!_showRehabilitacionForm) return const SizedBox.shrink();
    refresh();
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
            color: MyColor.primaryOpacityColor,
            borderRadius: BorderRadius.circular(30)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          TextField(
            maxLines: 3,
            maxLength: 255,
            controller: TextEditingController.fromValue(
                TextEditingValue(text: _con.progresoController.text)),
            decoration: InputDecoration(
              labelText: 'Progreso en habilidades visuales:',
              hintText: 'Evaluaciones periódicas sobre el avance',
              hintStyle: TextStyle(color: MyColor.primaryColorDark),
              prefixIcon: const Icon(Icons.trending_up),
              border: const OutlineInputBorder(),
            ),
            onChanged: (text) => _con.progresoController.text = text,
          ),
        ]));
  }

  Widget _buttonCrear(Paciente paciente) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              _con.modificar(paciente);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColor.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            ),
            child: const Text(
              'Actualizar Paciente',
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

  Widget _formBuilderParche() {
    if (!_showParcheForm) return const SizedBox.shrink();
    refresh();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: MyColor.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            value: _con.tipoParcheController.text.isEmpty
                ? _parcheTypes.first
                : _con.tipoParcheController.text,
            onChanged: (String? newValue) {
              setState(() {
                _con.tipoParcheController.text = newValue!;
              });
            },
            items: _parcheTypes.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: 'Tipo de parche. seleccione primero ',
              prefixIcon:
                  Icon(Icons.medication, color: MyColor.primaryColorDark),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(15),
              hintStyle: TextStyle(color: MyColor.primaryColorDark),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            keyboardType: TextInputType.none,
            controller: _con.horasParcheController,
            decoration: InputDecoration(
              labelText: 'Horas recomendadas',
              hintText: 'Selecciones la hora',
              prefixIcon: Icon(
                Icons.access_time,
                color: MyColor.primaryColor,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(15),
              hintStyle: TextStyle(color: MyColor.primaryColorDark),
            ),
            onTap: () async {
              final TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (picked != null) {
                setState(() {
                  _con.horasParcheController.text =
                      "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
                });
              }
            },
          ),
          const SizedBox(height: 10),
          TextField(
            maxLines: 3,
            maxLength: 255,
            controller: TextEditingController.fromValue(TextEditingValue(
              text: _con.observacionesParcheController.text,
              selection: TextSelection.collapsed(
                  offset: _con.observacionesParcheController.text.length),
            )),
            decoration: InputDecoration(
              labelText: 'Observaciones del parche',
              hintText: 'Diga cuales son',
              prefixIcon: Icon(
                Icons.bookmark,
                color: MyColor.primaryColor,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(15),
              hintStyle: TextStyle(color: MyColor.primaryColorDark),
            ),
            onChanged: (text) {
              _con.observacionesParcheController.text = text;
            },
          ),
          TextField(
            controller: _con.fechaParcheController,
            decoration: InputDecoration(
              labelText: 'Fecha de prescripcio del parche',
              hintText: 'Seleccione la fecha',
              prefixIcon: Icon(
                Icons.timer,
                color: MyColor.primaryColor,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(15),
              hintStyle: TextStyle(color: MyColor.primaryColorDark),
            ),
            keyboardType:
                TextInputType.none, // Especifica el tipo de teclado para fechas
            onTap: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(), // Fecha inicial predeterminada
                firstDate: DateTime(2010), // Fecha mínima permitida
                lastDate: DateTime.now(), // Fecha máxima permitida
              );
              if (picked != null && picked != DateTime.now()) {
                setState(() {
                  _con.fechaParcheController.text =
                      DateFormat("yyyy-MM-dd").format(picked);
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _formBuilderLente() {
    if (!_showLenteForm) return const SizedBox.shrink();
    refresh();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: MyColor.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            value: _con.tipoLenteController.text.isEmpty
                ? _lenteTypes.first
                : _con.tipoLenteController.text,
            onChanged: (String? newValue) {
              setState(() {
                _con.tipoLenteController.text = newValue!;
              });
            },
            items: _lenteTypes.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            decoration: InputDecoration(
                labelText: 'Tipo de lente, seleccione primero',
              prefixIcon:
                  Icon(Icons.visibility, color: MyColor.primaryColorDark),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(15),
              hintStyle: TextStyle(color: MyColor.primaryColorDark),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: TextEditingController.fromValue(TextEditingValue(
              text: _con.graduacionLenteController.text,
              selection: TextSelection.collapsed(
                  offset: _con.graduacionLenteController.text.length),
            )),
            decoration: InputDecoration(
              labelText: 'Graduacion del lente',
              hintText: 'Cual es?',
              prefixIcon: Icon(Icons.power_settings_new,
                  color: MyColor.primaryColorDark),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(15),
              hintStyle: TextStyle(color: MyColor.primaryColorDark),
            ),
            onChanged: (text) {
              _con.graduacionLenteController.text = text;
            },
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _con.fechaLenteController,
            decoration: InputDecoration(
              labelText: 'Fecha de prescripcion del lente',
              hintText: 'Seleccione la fecha',
              prefixIcon: Icon(Icons.layers, color: MyColor.primaryColorDark),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(15),
              hintStyle: TextStyle(color: MyColor.primaryColorDark),
            ),
            keyboardType:
                TextInputType.none, // Especifica el tipo de teclado para fechas
            onTap: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(), // Fecha inicial predeterminada
                firstDate: DateTime(2010), // Fecha mínima permitida
                lastDate: DateTime.now(), // Fecha máxima permitida
              );
              if (picked != null && picked != DateTime.now()) {
                setState(() {
                  _con.fechaLenteController.text =
                      DateFormat("yyyy-MM-dd").format(picked);
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
