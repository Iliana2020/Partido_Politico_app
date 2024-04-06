import 'package:flutter/material.dart';
import 'dart:io';
import 'DelegateFormPage.dart'; // Importa la clase DelegateFormPage

class PortadaPage extends StatelessWidget {
  final Color morado = Colors.purple;

  @override
  Widget build(BuildContext context) {
    // Usa Navigator para encontrar la instancia actual de DelegateFormPage
    DelegateFormPage? delegateFormPage =
        ModalRoute.of(context)!.settings.arguments as DelegateFormPage?;

    File? selectedImage = delegateFormPage
        ?.selectedImage; // Accede a selectedImage desde la instancia de DelegateFormPage

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Elecciones Políticas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor:
            Color(0xFF4D038C), // Color de fondo blanco en el appbar
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                'Partido de la Liberación Dominicana',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black12),
              ),
              accountEmail: null,
              currentAccountPicture: selectedImage != null
                  ? CircleAvatar(
                      backgroundImage: FileImage(selectedImage),
                    )
                  : CircleAvatar(
                      backgroundImage: AssetImage('assets/logo2.png'),
                    ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/por.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: morado),
              title: Text('Portada'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person, color: morado),
              title: Text('Registro de Eventos'),
              onTap: () {
                Navigator.pushNamed(context, '/Registro');
              },
            ),
            ListTile(
              leading: Icon(Icons.event, color: morado), // Icono para Eventos
              title: Text('Eventos'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                    context, '/Eventos'); // Navega a EventosPage
              },
            ),
            ListTile(
              leading: Icon(Icons.info, color: morado), // Icono para Acerca de
              title: Text('Acerca de'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                    context, '/AcercaDe'); // Navega a AcercaDePage
              },
            ),
            // Agrega aquí otras opciones del menú según sea necesario
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/fondoBlanco.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 100.0), // Espacio para el carrusel
              SizedBox(height: 20.0), // Pasar contexto al método
              SizedBox(height: 20.0),
              Image.asset(
                'assets/logo.png', // Ruta del archivo del logo del PLD
                width: 200, // Ancho del logo
                height: 200, // Alto del logo
                fit: BoxFit.contain, // Ajuste del logo dentro del contenedor
              ),
              Text(
                'Servir al partido para servir al Pueblo',
                style: TextStyle(
                  fontSize: 24, // Tamaño de la fuente
                  fontWeight: FontWeight.bold, // Negrita
                  fontStyle: FontStyle.italic, // Cursiva
                  color: Colors.black, // Color del texto
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
