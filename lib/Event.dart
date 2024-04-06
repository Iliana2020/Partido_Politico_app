import 'dart:convert'; // Importa la biblioteca 'dart:convert' que proporciona funciones para codificar y decodificar datos JSON.

class Event {
  final DateTime date;
  final String title;
  final String description;
  final String imagePath;
  final String audioPath; // Nuevo parámetro para la ruta del archivo de audio

  Event({
    required this.date,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.audioPath,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    // Factory constructor que convierte un mapa JSON en una instancia de Event.
    return Event(
      date: DateTime.parse(json[
          'date']), // Convierte la cadena JSON 'date' en un objeto DateTime utilizando parse().
      title: json[
          'title'], // Obtiene el valor del título del evento del mapa JSON.
      description: json[
          'description'], // Obtiene el valor de la descripción del evento del mapa JSON.
      imagePath: json['imagePath'],
      audioPath: json[
          'audioPath'], // Obtiene el valor de la ruta de la imagen del evento del mapa JSON.
    );
  }

  Map<String, dynamic> toJson() {
    // Convierte una instancia de Event en un mapa JSON.
    return {
      'date': date
          .toIso8601String(), // Convierte la fecha del evento en una cadena ISO 8601 y la agrega al mapa JSON.
      'title': title, // Agrega el título del evento al mapa JSON.
      'description':
          description, // Agrega la descripción del evento al mapa JSON.
      'imagePath': imagePath,
      'audioPath':
          audioPath, // Agrega la ruta de la imagen del evento al mapa JSON.
    };
  }

  String toJsonString() {
    // Convierte una instancia de Event en una cadena JSON.
    Map<String, dynamic> jsonMap =
        toJson(); // Convierte la instancia de Event en un mapa JSON utilizando el método toJson().
    return jsonEncode(
        jsonMap); // Convierte el mapa JSON en una cadena JSON utilizando jsonEncode().
  }
}
