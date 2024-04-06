import 'package:flutter/material.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class AcercaDePage extends StatefulWidget {
  @override
  _AcercaDePageState createState() => _AcercaDePageState();
}

class _AcercaDePageState extends State<AcercaDePage> {
  String? _firstName;
  String? _lastName;
  String? _registrationNumber;
  String? _reflection;
  String? _selectedImagePath;

  @override
  void initState() {
    super.initState();
    _loadDelegateData();
  }

  Future<void> _loadDelegateData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstName = prefs.getString('firstName');
      _lastName = prefs.getString('lastName');
      _registrationNumber = prefs.getString('registrationNumber');
      _reflection = prefs.getString('reflection');
      _selectedImagePath = prefs.getString('selectedImage');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Acerca de',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF4D038C), // Color morado
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondoBlanco.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 5,
                    ),
                  ),
                  child: _selectedImagePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.file(
                            File(_selectedImagePath!),
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Placeholder(
                          color: Colors.grey,
                          fallbackHeight: 200,
                          fallbackWidth: 200,
                        ),
                ),
                SizedBox(height: 20),
                Text(
                  'Nombre: ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4D038C), // Color morado
                  ),
                ),
                Text('$_firstName $_lastName'),
                Text(
                  'Matrícula: ',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                Text('$_registrationNumber'),
                Text(
                  'Reflexión: "La democracia no es solo el derecho a elegir, sino también la responsabilidad de participar activamente en el servicio cívico para fortalecerla."',
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color.fromARGB(255, 90, 89, 89),
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                // Otros datos del delegado según sea necesario
              ],
            ),
          ),
        ),
      ),
    );
  }
}
