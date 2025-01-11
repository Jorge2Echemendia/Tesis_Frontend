import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_3/src/controller/historial_controller.dart';
import 'package:flutter_application_3/src/model/historial_de_notas.dart';
import 'package:flutter_application_3/src/model/historial_de_tratamiento.dart';
import 'package:flutter_application_3/src/utils/my_color.dart';
import 'package:table_calendar/table_calendar.dart';

class HistorialPage extends StatefulWidget {
  final List<Historial> historial;
  final List<HistorialNotas> historialNotas;
  const HistorialPage(
      {super.key, required this.historial, required this.historialNotas});

  @override
  State<HistorialPage> createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage> {
  final HistorialController _controller = HistorialController();
  late Map<DateTime, List<dynamic>> _eventMap;
  late DateTime _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.init(context, refresh);
    });

    _selectedDay = DateTime.now();
    _eventMap = _groupEventsByDate(widget.historial, widget.historialNotas);
  }

  void refresh() {
    print("Actualizando UI");
    setState(() {});
  }

  Map<DateTime, List<dynamic>> _groupEventsByDate(
      List<Historial> historiales, List<HistorialNotas> historialNotas) {
    Map<DateTime, List<dynamic>> eventMap = {};

    for (var historial in historiales) {
      DateTime? fechaAdministracion = historial.fechaAdministracion;

      if (fechaAdministracion != null) {
        // Normaliza la fecha para que coincida con el formato en el mapa de eventos
        DateTime normalizedDate = DateTime(fechaAdministracion.year,
            fechaAdministracion.month, fechaAdministracion.day);

        if (!eventMap.containsKey(normalizedDate)) {
          eventMap[normalizedDate] = [];
        }

        eventMap[normalizedDate]!.add(historial);
      }
    }

    for (var nota in historialNotas) {
      DateTime? fechaNota = nota.fechas;

      if (fechaNota != null) {
        // Normaliza la fecha para que coincida con el formato en el mapa de notas
        DateTime normalizedDate =
            DateTime(fechaNota.year, fechaNota.month, fechaNota.day);

        if (!eventMap.containsKey(normalizedDate)) {
          eventMap[normalizedDate] = [];
        }

        eventMap[normalizedDate]!.add(nota);
      }
    }
    return eventMap;
  }

  void _showEventsForDay(DateTime day) {
    // Normaliza la fecha del día para que coincida con el formato en el mapa de eventos
    DateTime normalizedDay = DateTime(day.year, day.month, day.day);
    var events = _eventMap[normalizedDay] ?? [];

    if (events.isEmpty) {
      return; // No mostrar el modal si no hay eventos ni notas
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          children: events.map((event) {
            if (event is Historial) {
              bool isFuture =
                  event.fechaAdministracion!.isAfter(DateTime.now());
              return Card(
                color: isFuture ? Colors.red : Colors.green,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(
                    'Fecha de medicación: ${event.fechaAdministracion}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            } else if (event is HistorialNotas) {
               bool isFuture =
                  event.fechas!.isAfter(DateTime.now());
              return Card(
                 color: isFuture ? Colors.red : Colors.green,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(
                    'Fecha: ${event.fechas}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              );
            }
            return Container();
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.primaryColor,
        title: const Text(
          'Historial de Tratamiento y Notas',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TableCalendar<dynamic>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2025, 12, 31),
            focusedDay: _selectedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                });
                _showEventsForDay(selectedDay);
              }
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            eventLoader: (day) {
              DateTime normalizedDay = DateTime(day.year, day.month, day.day);
              var events = _eventMap[normalizedDay] ?? [];
              print('Eventos para $normalizedDay: $events');
              return events;
            },
          ),
        ],
      ),
    );
  }
}

