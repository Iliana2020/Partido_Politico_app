import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:io';

import 'Event.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;

  const EventDetailsScreen({required this.event});

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _loadAudio();
  }

  Future<void> _loadAudio() async {
    try {
      await _audioPlayer.setFilePath(widget.event.audioPath);
    } catch (e) {
      print('Error al cargar el archivo de audio: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalles del Evento',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.deepPurple, // Color de fondo del app bar
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/fondoBlanco.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(widget.event.imagePath!),
                        width: 300,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (!_isPlaying) {
                            await _audioPlayer.play();
                            setState(() {
                              _isPlaying = true;
                            });
                          } else {
                            await _audioPlayer.pause();
                            setState(() {
                              _isPlaying = false;
                            });
                          }
                        },
                        child: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple, // Color del botón
                          shape: CircleBorder(), // Forma circular
                          padding: EdgeInsets.all(
                              12), // Ajuste el padding según sea necesario
                        ),
                      ),
                      SizedBox(
                          width:
                              10), // Espacio entre el botón y la línea de reproducción
                      Container(
                        width: 250, // Ancho de la línea de reproducción
                        child: Slider(
                          value: _audioPlayer.position?.inMilliseconds
                                  .toDouble() ??
                              0,
                          min: 0,
                          max: _audioPlayer.duration?.inMilliseconds
                                  .toDouble() ??
                              0,
                          onChanged: (value) {
                            _audioPlayer
                                .seek(Duration(milliseconds: value.toInt()));
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    '${widget.event.title}',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${widget.event.description}',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    textAlign:
                        TextAlign.center, // Alineación del texto al centro
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Fecha: ',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        '${widget.event.date.day.toString().padLeft(2, '0')}/${widget.event.date.month.toString().padLeft(2, '0')}/${widget.event.date.year.toString()}',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 99, 99, 99),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Hora: ',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        '${widget.event.date.hour.toString().padLeft(2, '0')}:${widget.event.date.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color: Color.fromARGB(255, 99, 99, 99),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
