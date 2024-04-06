import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'Event.dart';
import 'event_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:just_audio/just_audio.dart';

class AddEventScreen extends StatefulWidget {
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final EventService _eventService = EventService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _imageFile;
  File? _audioFile;
  String? _audioFileName;
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Declaración de variables relacionadas con la reproducción de audio
  late bool _isPlaying = false; // Indica si el audio está reproduciéndose
  late int _currentPosition =
      0; // Almacena la posición actual de reproducción en milisegundos
  late int _totalDuration =
      0; // Almacena la duración total del audio en milisegundos

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    if (Platform.isAndroid) {
      PermissionStatus permissionStatus = await Permission.storage.status;
      if (permissionStatus.isDenied) {
        await Permission.storage.request();
      }
    }
  }

  Future<void> _selectImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveEvent() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _imageFile == null) {
      return;
    }

    Event newEvent = Event(
      date: DateTime.now(),
      title: _titleController.text,
      description: _descriptionController.text,
      imagePath: _imageFile!.path,
      audioPath: _audioFile?.path ?? '',
    );

    await _eventService.addEvent(newEvent);

    Navigator.pop(context, newEvent);
  }

  Future<void> _selectAudio() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'wav', 'aac'],
      );

      if (result != null && result.files.isNotEmpty) {
        File file = File(result.files.single.path!);
        setState(() {
          _audioFile = file;
          _audioFileName = file.path.split('/').last;
          _reproducirAudio(file.path);
        });
      } else {
        // El usuario canceló la selección de audio
        setState(() {
          _audioFile = null;
          _audioFileName = null;
        });
      }
    } catch (e) {
      print('Error al seleccionar el archivo de audio: $e');
    }
  }

  void _reproducirAudio(String audioPath) async {
    await _audioPlayer.setFilePath(audioPath);
    _audioPlayer.play();
    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _currentPosition = position.inMilliseconds;
      });
    });
    _audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      setState(() {
        _totalDuration = bufferedPosition.inMilliseconds;
      });
    });
    _audioPlayer.playerStateStream.listen((playerState) {
      setState(() {
        _isPlaying = playerState.playing;
      });
    });
  }

  void _pauseAudio() async {
    await _audioPlayer.pause();
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
          'Registrar Evento',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF4D038C),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Título',
                  labelStyle:
                      TextStyle(color: const Color.fromARGB(255, 64, 65, 65)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 254, 195, 0)),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 64, 65, 65)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 254, 195, 0)),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 200,
                color: Colors.grey[300],
                child: Center(
                  child: _imageFile != null
                      ? Image.file(_imageFile!)
                      : IconButton(
                          icon: Icon(
                            Icons.add,
                            size: 50,
                          ),
                          onPressed: () => _selectImage(ImageSource.gallery),
                        ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _selectImage(ImageSource.gallery),
                    child: Text('Seleccionar Imagen',
                        style: TextStyle(color: Colors.white)),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF4D038C)),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _selectAudio,
                    child: Text('Seleccionar Audio',
                        style: TextStyle(color: Colors.white)),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF4D038C)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _audioFileName != null
                  ? Column(
                      children: [
                        Text(
                          '$_audioFileName',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        MiniAudioPlayer(
                          audioPlayer: _audioPlayer,
                          isPlaying: _isPlaying,
                          currentPosition: _currentPosition,
                          totalDuration: _totalDuration,
                        ),
                      ],
                    )
                  : Container(),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _saveEvent,
                  child: Text(
                    'Guardar Evento',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 254, 195, 0)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MiniAudioPlayer extends StatefulWidget {
  final AudioPlayer audioPlayer;
  final bool isPlaying;
  final int currentPosition;
  final int totalDuration;

  const MiniAudioPlayer({
    Key? key,
    required this.audioPlayer,
    required this.isPlaying,
    required this.currentPosition,
    required this.totalDuration,
  }) : super(key: key);

  @override
  _MiniAudioPlayerState createState() => _MiniAudioPlayerState();
}

class _MiniAudioPlayerState extends State<MiniAudioPlayer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Alineación entre los elementos
          children: [
            Expanded(
              // Para que el botón ocupe el espacio restante
              child: Slider(
                value: widget.currentPosition.toDouble(),
                min: 0,
                max: widget.totalDuration.toDouble(),
                onChanged: (value) {
                  widget.audioPlayer
                      .seek(Duration(milliseconds: value.toInt()));
                },
              ),
            ),
            SizedBox(width: 10), // Espacio entre el slider y el botón
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () async {
                  if (widget.isPlaying) {
                    await widget.audioPlayer.pause();
                  } else {
                    await widget.audioPlayer.play();
                  }
                },
                icon: Icon(
                  widget.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.purple,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDuration(int milliseconds) {
    Duration duration = Duration(milliseconds: milliseconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
}
