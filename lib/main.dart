import 'dart:io';

import 'package:flutter/material.dart';
import 'add_event_screen.dart' as addEvent;
import 'menu.dart' as menu;
import 'events_screen.dart' as events;
import 'package:permission_handler/permission_handler.dart';
import 'DelegateFormPage.dart';
import 'acerca_de_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await checkPermissions();

  runApp(MaterialApp(
    home: DelegateFormPage(),
    routes: {
      '/Registro': (context) => addEvent.AddEventScreen(),
      '/Eventos': (context) => events.EventsScreen(),
      '/portada': (context) => menu.PortadaPage(),
      '/AcercaDe': (context) => AcercaDePage(),
    },
  ));
}

Future<void> checkPermissions() async {
  if (Platform.isAndroid) {
    // Verifica si el permiso de almacenamiento ya está concedido
    if (!await Permission.storage.isGranted) {
      // Solicita el permiso si aún no está concedido
      PermissionStatus permissionStatus = await Permission.storage.request();
      if (!permissionStatus.isGranted) {
        // El usuario denegó el permiso, manejar la situación adecuadamente
        print('Permiso de almacenamiento denegado por el usuario.');
      }
    }
  }
}
