// ignore_for_file: file_names

import 'dart:io';
import 'dart:convert';
import 'package:ccfs/app/models/imagen.dart';
import 'package:http/http.dart' as http;
import 'package:ccfs/app/utilities/domains/urls.dart' as urls;
import 'package:ccfs/app/utilities/globals.dart' as globals;

class ServiciosImagenes {
  Future<List<Imagen>> obtenerImagenesGaleria(int codSitio) async {
    var urlGaleria = Uri.parse('${urls.API_IMAGENES}/all/{$codSitio}');

    Map<String, String> cabecera = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer ${globals.token}",
    };

    final respuesta = await http.get(urlGaleria, headers: cabecera);

    if (respuesta.statusCode == 200) {
      return toList(respuesta.body);
    } else {
      throw Exception("Error en la consulta de los datos");
    }
  }

  Future<bool> crearImagen(Imagen objImagen) async {
    var urlGaleria = Uri.parse('${urls.API_IMAGENES}/add');

    Map<String, String> cabecera = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer ${globals.token}",
    };

    final respuesta = await http.get(urlGaleria, headers: cabecera);

    if (respuesta.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  List<Imagen> toList(String responseBody) {
    final listImagenes =
        (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();
    return listImagenes.map<Imagen>((json) => Imagen.fromJson(json)).toList();
  }
}
    