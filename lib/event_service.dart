import 'package:shared_preferences/shared_preferences.dart'; // Importa la biblioteca 'shared_preferences' para trabajar con almacenamiento local.
import 'Event.dart'; // Importa la clase Event definida en otro archivo.
import 'dart:convert'; // Importa la biblioteca para trabajar con JSON.

class EventService {
  static const String _eventKey =
      'events'; // Define una constante para la clave de almacenamiento local.

  Future<List<Event>> getEvents() async {
    // Método para obtener la lista de eventos almacenados localmente.
    SharedPreferences prefs = await SharedPreferences
        .getInstance(); // Obtiene una instancia de SharedPreferences para acceder al almacenamiento local.
    List<String>? eventsJson = prefs.getStringList(
        _eventKey); // Obtiene la lista de eventos en formato JSON del almacenamiento local.

    if (eventsJson == null) {
      // Verifica si la lista de eventos es nula.
      return []; // Devuelve una lista vacía si no hay eventos almacenados.
    }

    // Mapea la lista de eventos JSON a una lista de objetos Event utilizando el constructor fromJson de la clase Event.
    return eventsJson
        .map((eventJson) => Event.fromJson(jsonDecode(eventJson)))
        .toList();
  }

  Future<void> addEvent(Event event) async {
    // Método para agregar un evento al almacenamiento local.
    SharedPreferences prefs = await SharedPreferences
        .getInstance(); // Obtiene una instancia de SharedPreferences para acceder al almacenamiento local.
    List<String> eventsJson = prefs.getStringList(_eventKey) ??
        []; // Obtiene la lista de eventos en formato JSON del almacenamiento local o crea una lista vacía si no hay eventos.

    eventsJson.add(event
        .toJsonString()); // Agrega el evento actual en formato JSON a la lista de eventos JSON.
    await prefs.setStringList(_eventKey,
        eventsJson); // Guarda la lista actualizada de eventos JSON en el almacenamiento local.
  }
}
