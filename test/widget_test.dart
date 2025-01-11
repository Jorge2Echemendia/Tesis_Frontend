// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_application_3/src/controller/paciente_controller.dart';
import 'package:flutter_application_3/src/model/paciente.dart';
import 'package:flutter_application_3/src/provider/pacientes_provider.dart';
import 'package:flutter_application_3/src/view/pages/patient/crear_paciente_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CrearPacientePage tests', () {
    late PacienteController con;
    late PacientesProvider pacientesProvider;

    setUp(() {
      con = PacienteController();
      pacientesProvider = PacientesProvider();
    });

    testWidgets('CrearPacientePage renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CrearPacientePage(),
        ),
      );

      expect(find.byType(CrearPacientePage), findsOneWidget);
      expect(find.text('Nuevo Paciente'), findsOneWidget);
    });

 testWidgets('Nombre field is present', (WidgetTester tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: CrearPacientePage(),
    ),
  );

  // Busca todos los TextField y verifica que uno de ellos tenga el hintText 'Nombre'
  expect(find.widgetWithText(TextField, 'Nombre'), findsOneWidget);
});

testWidgets('Apellido field is present', (WidgetTester tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: CrearPacientePage(),
    ),
  );

  // Busca todos los TextField y verifica que uno de ellos tenga el hintText 'Apellido'
  expect(find.widgetWithText(TextField, 'Apellido'), findsOneWidget);
});

testWidgets('Apellido Segundo field is present', (WidgetTester tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: CrearPacientePage(),
    ),
  );

  // Busca todos los TextField y verifica que uno de ellos tenga el hintText 'Apellido Segundo'
  expect(find.widgetWithText(TextField, 'Apellido Segundo'), findsOneWidget);
});

testWidgets('Afeccion dropdown is present', (WidgetTester tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: CrearPacientePage(),
    ),
  );

  // Busca todos los DropdownButtonFormField y verifica que uno de ellos tenga el hintText 'Seleccione la afección'
  expect(find.widgetWithText( DropdownButtonFormField<String>, 'Seleccione la afección'), findsOneWidget);
});

testWidgets('Fecha de Nacimiento field is present', (WidgetTester tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: CrearPacientePage(),
    ),
  );

  // Busca todos los TextField y verifica que uno de ellos tenga el hintText 'Fecha de Nacimiento'
  expect(find.widgetWithText(TextField, 'Fecha de Nacimiento'), findsOneWidget);
});

testWidgets('Etapa de Tratamiento dropdown is present', (WidgetTester tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: CrearPacientePage(),
    ),
  );

  // Busca todos los DropdownButtonFormField y verifica que uno de ellos tenga el hintText 'Seleccione Etapa'
  expect(find.widgetWithText( DropdownButtonFormField<String>, 'Seleccione Etapa '), findsOneWidget);
});
testWidgets('Diagnóstico Inicial form is present when selected', (WidgetTester tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: CrearPacientePage(),
    ),
  );

  await tester.tap(find.widgetWithText(DropdownButtonFormField<String>, 'Seleccione Etapa '));
  await tester.pump();
  await tester.tap(find.text('Diagnóstico Inicial').last);
  await tester.pump();

  // Verifica que el formulario de Diagnóstico Inicial esté presente
  expect(find.text('Fecha del diagnóstico:'), findsOneWidget);
});

testWidgets('Tratamiento Activo form is present when selected', (WidgetTester tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: CrearPacientePage(),
    ),
  );

  await tester.tap(find.widgetWithText(DropdownButtonFormField<String>, 'Seleccione Etapa '));
  await tester.pump();
  await tester.tap(find.text('Tratamiento Activo').last);
  await tester.pump();

  // Verifica que el formulario de Tratamiento Activo esté presente
  expect(find.text('Tipo de corrección óptica:'), findsOneWidget);
});

testWidgets('Mantenimiento form is present when selected', (WidgetTester tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: CrearPacientePage(),
    ),
  );

  await tester.tap(find.widgetWithText(DropdownButtonFormField<String>, 'Seleccione Etapa '));
  await tester.pump();
  await tester.tap(find.text('Mantenimiento').last);
  await tester.pump();

  // Verifica que el formulario de Mantenimiento esté presente
  expect(find.text('Cambios en la corrección óptica:'), findsOneWidget);
});

testWidgets('Intervención Quirúrgica form is present when selected', (WidgetTester tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: CrearPacientePage(),
    ),
  );

  await tester.tap(find.widgetWithText(DropdownButtonFormField<String>, 'Seleccione Etapa '));
  await tester.pump();
  await tester.tap(find.text('Intervención Quirúrgica').last);
  await tester.pump();

  // Verifica que el formulario de Intervención Quirúrgica esté presente
  expect(find.text('Tipo de cirugía:'), findsOneWidget);
});

testWidgets('Rehabilitación Visual form is present when selected', (WidgetTester tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: CrearPacientePage(),
    ),
  );

  await tester.tap(find.widgetWithText(DropdownButtonFormField<String>, 'Seleccione Etapa '));
  await tester.pump();
  await tester.tap(find.text('Rehabilitación Visual').last);
  await tester.pump();

  // Verifica que el formulario de Rehabilitación Visual esté presente
  expect(find.text('Evaluaciones periódicas sobre el avance'), findsOneWidget);
});

testWidgets('Crear Paciente button is present', (WidgetTester tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: CrearPacientePage(),
    ),
  );

  // Verifica que el botón de Crear Paciente esté presente
  expect(find.widgetWithText(ElevatedButton, 'Crear Paciente'), findsOneWidget);
});

testWidgets('Parche option is present', (WidgetTester tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: CrearPacientePage(),
    ),
  );

  // Verifica que la opción de Parche esté presente
  await tester.tap(find.widgetWithText(DropdownButtonFormField<String>,  'Seleccione una opción'));
  await tester.pump();
  await tester.tap(find.text('Parche').last);
  await tester.pump();

  expect(find.text('Observaciones del parche'), findsOneWidget);
});

testWidgets('Lente option is present', (WidgetTester tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: CrearPacientePage(),
    ),
  );

  // Verifica que la opción de Lente esté presente
  await tester.tap(find.widgetWithText(DropdownButtonFormField<String>,  'Seleccione una opción'));
  await tester.pump();
  await tester.tap(find.text('Lente').last);
  await tester.pump();

  expect(find.text('Fecha de prescripcion del lente'), findsOneWidget);
});
    test('CrearPacientePage creates a new Paciente', () {
      // Arrange
      con.nombreController.text = 'Juan';
  con.apellidoController.text = 'Pérez';
  con.apellidoSegundoController.text = 'García';
  con.afeccionController.text = 'Simple';
  con.fechaNacimientoController.text = '2023-01-01';
  con.etapaDeTratamientoController.text = 'Diagnóstico Inicial';
  con.fechaDiagnosticoController.text = '2023-01-01';
  con.gradoMiopiaController.text = '2.5';
  con.examenesController.text = 'Examen de la vista';
  con.recomendacionesController.text = 'Usar gafas';
  con.lenteController.text = 'true';
  con.parcheController.text = 'false';
  con.tipoLenteController.text = 'Lentes correctivos';
  con.graduacionLenteController.text = '2.5';
  con.fechaLenteController.text = '2023-01-01';
  con.tipoParcheController.text = 'Parche oclusor';
  con.horasParcheController.text = '8';
  con.fechaParcheController.text = '2023-01-01';
  con.observacionesParcheController.text = 'Usar durante el día';
  con.correccionOpticaController.text = 'Gafas';
  con.ejerciciosVisualesController.text = 'Rotación de ojos';
  con.cambioOpticoController.text = 'Ajuste mensual';
  con.consejosHigieneController.text = 'Lavar las manos antes de tocar los ojos';
  con.cirujiaController.text = 'LASIK';
  con.cirujiaFechaController.text = '2023-01-01';
  con.cirujiaResultadosController.text = 'Éxito';
  con.progresoController.text = 'Mejorando';

  // Act
  Paciente paciente = Paciente(
    nombre: con.nombreController.text,
    apellido: con.apellidoController.text,
    apellidoSegundo: con.apellidoSegundoController.text,
    fechaNacimiento: DateTime.parse(con.fechaNacimientoController.text),
    afeccion: con.afeccionController.text,
    etapaDeTratamiento: con.etapaDeTratamientoController.text,
    lente: con.lenteController.text == 'true',
    parche: con.parcheController.text == 'true',
    tipoLente: con.tipoLenteController.text,
    graduacionLente: con.graduacionLenteController.text,
    fechaLente: DateTime.parse(con.fechaLenteController.text),
    fechaDiagnostico: DateTime.parse(con.fechaDiagnosticoController.text),
    gradoMiopia: con.gradoMiopiaController.text,
    examenes: con.examenesController.text,
    recomendaciones: con.recomendacionesController.text,
    tipoParche: con.tipoParcheController.text,
    horasParche: con.horasParcheController.text,
    fechaParche: DateTime.parse(con.fechaParcheController.text),
    observacionesParche: con.observacionesParcheController.text,
    correccionOptica: con.correccionOpticaController.text,
    cambioOptico: con.cambioOpticoController.text,
    progreso: con.progresoController.text,
    cirujiaResultados: con.cirujiaResultadosController.text,
    ejerciciosVisuales: con.ejerciciosVisualesController.text,
    consejosHigiene: con.consejosHigieneController.text,
    cirujia: con.cirujiaController.text,
    cirujiaFecha: DateTime.parse(con.cirujiaFechaController.text),
  );

  // Assert
  expect(paciente.nombre, 'Juan');
  expect(paciente.apellido, 'Pérez');
  expect(paciente.apellidoSegundo, 'García');
  expect(paciente.afeccion, 'Simple');
  expect(paciente.etapaDeTratamiento, 'Diagnóstico Inicial');
  expect(paciente.lente, true);
  expect(paciente.parche, false);
  expect(paciente.tipoLente, 'Lentes correctivos');
  expect(paciente.graduacionLente, '2.5');
  expect(paciente.fechaLente, DateTime(2023, 1, 1));
  expect(paciente.fechaDiagnostico, DateTime(2023, 1, 1));
  expect(paciente.gradoMiopia, '2.5');
  expect(paciente.examenes, 'Examen de la vista');
  expect(paciente.recomendaciones, 'Usar gafas');
  expect(paciente.tipoParche, 'Parche oclusor');
  expect(paciente.horasParche, '8');
  expect(paciente.fechaParche, DateTime(2023, 1, 1));
  expect(paciente.observacionesParche, 'Usar durante el día');
  expect(paciente.correccionOptica, 'Gafas');
  expect(paciente.cambioOptico, 'Ajuste mensual');
  expect(paciente.progreso, 'Mejorando');
  expect(paciente.cirujiaResultados, 'Éxito');
  expect(paciente.ejerciciosVisuales, 'Rotación de ojos');
  expect(paciente.consejosHigiene, 'Lavar las manos antes de tocar los ojos');
  expect(paciente.cirujia, 'LASIK');
  expect(paciente.cirujiaFecha, DateTime(2023, 1, 1));
});
  });
}