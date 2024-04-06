import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'menu.dart';
import 'package:flutter/services.dart'; // Importar el paquete para formatear el texto de entrada

class DelegateFormPage extends StatefulWidget {
  File? get selectedImage => null;

  @override
  _DelegateFormPageState createState() => _DelegateFormPageState();
}

class _DelegateFormPageState extends State<DelegateFormPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _registrationNumberController =
      TextEditingController();
  final TextEditingController _reflectionController = TextEditingController();

  File? _selectedImage;
  // Añadido el campo para almacenar la imagen seleccionada
  File? get selectedImage => _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ingresar sus Datos ',
          style: TextStyle(color: Colors.white), // Texto blanco
        ),
        backgroundColor: Color(0xFF4D038C),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Ingrese sus datos para poder ingresar como delegado del PLD',
              style: TextStyle(
                color: Colors.grey, // Color gris
                fontSize: 16.0,
                fontStyle: FontStyle.italic, // Texto en cursiva
              ),
              textAlign: TextAlign.center, // Texto centrado
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: 'Nombre',
                labelStyle: TextStyle(
                  color: const Color.fromARGB(255, 97, 96, 96),
                ), // Color negro
              ),
            ),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: 'Apellido',
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 97, 96, 96),
                ), // Color negro
              ),
            ),
            TextField(
              controller: _registrationNumberController,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ], // Acepta solo números
              decoration: InputDecoration(
                labelText: 'Matrícula',
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 97, 96, 96),
                ), // Color negro
              ),
            ),
            SizedBox(height: 10.0),
            GestureDetector(
              onTap: _selectImage,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: _selectedImage != null
                      ? Image.file(_selectedImage!)
                      : Icon(
                          Icons.add,
                          size: 40,
                          color: Colors.black,
                        ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _validateAndSave,
              child: Text(
                'INGRESAR',
                style: TextStyle(color: Color(0xFFFEF200)), // Color amarillo
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4D038C), // Color morado
              ),
            ),
            SizedBox(height: 20),
            Image.asset(
              'assets/logo.png', // Ruta del archivo del logo del partido
              width: 100, // Ancho del logo
              height: 100, // Alto del logo
              fit: BoxFit.contain, // Ajuste del logo dentro del contenedor
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _validateAndSave() async {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _registrationNumberController.text.isEmpty ||
        _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Por favor complete todos los campos.'),
        backgroundColor: Colors.red, // Color rojo
      ));
    } else {
      _saveDelegateData();
      Navigator.pushReplacementNamed(context, '/portada');
    }
  }

  Future<void> _saveDelegateData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('firstName', _firstNameController.text);
    prefs.setString('lastName', _lastNameController.text);
    prefs.setString('registrationNumber', _registrationNumberController.text);
    prefs.setString(
        'selectedImage',
        _selectedImage?.path ??
            ''); // Guardar la ruta de la imagen seleccionada

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Datos del delegado guardados correctamente.'),
      backgroundColor: Color(0xFF4D038C), // Color morado
    ));
  }

  Future<void> _selectImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }
}
