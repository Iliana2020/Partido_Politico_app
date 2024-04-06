import 'package:flutter/material.dart';
import 'dart:io';
import 'Event.dart' as EventModel;
import 'event_service.dart';
import 'add_event_screen.dart';
import 'event_details_screen.dart';

EventService? _eventService;

class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  List<EventModel.Event> _events = []; // Lista de eventos

  @override
  void initState() {
    super.initState();
    _eventService = EventService();
    _loadEvents(); // Cargar los eventos al iniciar la pantalla
  }

  Future<void> _loadEvents() async {
    List<EventModel.Event> events = await _eventService!.getEvents();
    setState(() {
      _events = events; // Actualizar la lista de eventos
    });
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.delete),
              SizedBox(width: 8),
              Text('Eliminar Eventos'),
            ],
          ),
          content:
              Text('¿Está seguro de que desea eliminar todos los eventos?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar el diálogo
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.red, // Color de fondo rojo
              ),
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: Colors.white, // Color del texto blanco
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Lógica para eliminar todos los eventos
                _events.clear();
                // Actualizar la vista
                setState(() {});
                Navigator.pop(context); // Cerrar el diálogo
              },
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF4D038C), // Color de fondo morado
              ),
              child: Text(
                'Aceptar',
                style: TextStyle(
                  color: Colors.white, // Color del texto blanco
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4D038C),
        title: Text(
          'Eventos Elecciones',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondoBlanco.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Eventos Registrados',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 170, 0),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _events.length,
                itemBuilder: (context, index) {
                  EventModel.Event event = _events[index];
                  return Card(
                    elevation: 3,
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: event.imagePath != null
                            ? FileImage(File(event.imagePath!))
                            : null,
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              event.title,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                      subtitle: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: 'Fecha: ',
                              style: TextStyle(
                                color: Color.fromARGB(255, 200, 100, 0),
                              ),
                            ),
                            TextSpan(
                              text: event.date.day.toString().padLeft(2, '0') +
                                  '/' +
                                  event.date.month.toString().padLeft(2, '0') +
                                  '/' +
                                  event.date.year.toString() +
                                  ' ',
                            ),
                            TextSpan(
                              text: 'Hora: ',
                              style: TextStyle(
                                color: Color(0xFF4D038C),
                              ),
                            ),
                            TextSpan(
                              text: event.date.hour.toString().padLeft(2, '0') +
                                  ':' +
                                  event.date.minute.toString().padLeft(2, '0'),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EventDetailsScreen(event: event),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 20),
              child: Image.asset(
                'assets/logo.png',
                height: 100,
                width: 100,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEventScreen(),
            ),
          ).then((newEvent) {
            if (newEvent != null) {
              // Si se guarda un nuevo evento, actualizar la lista
              setState(() {
                _events.add(newEvent);
              });
            }
          });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Color(0xFF4D038C),
      ),
      persistentFooterButtons: [
        ElevatedButton(
          onPressed: _showDeleteConfirmationDialog,
          child: Text('Eliminar Eventos'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.red[800], // Color del texto blanco
          ),
        ),
      ],
    );
  }
}
