import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<void> downloadFile(String base64Data, String fileName) async {
  try {
    // Solicitar permisos de almacenamiento
    var status = await Permission.storage.request();
    if (status.isGranted) {
      // Convertir base64 a bytes
      var bytes = const Base64Decoder().convert(base64Data);

      // Obtener la ruta de almacenamiento
      var dir = await getExternalStorageDirectory();
      String filePath = '${dir!.path}/$fileName';

      // Guardar el archivo
      File file = File(filePath);
      await file.writeAsBytes(bytes);

      print('Archivo guardado en: $filePath');
    } else {
      print('Permiso de almacenamiento denegado');
    }
  } catch (e) {
    print('Error al descargar el archivo: $e');
  }
}
