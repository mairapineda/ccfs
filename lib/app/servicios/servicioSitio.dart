/* // ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';

import 'package:ccfs/app/models/imagen.dart';
import 'package:ccfs/app/models/sitio.dart';
import 'package:http/http.dart' as http;
import 'package:ccfs/app/utilities/domains/urls.dart' as urls;
import 'package:ccfs/app/utilities/globals.dart' as globals;

class ServicioSitio {
  Future<bool> registrarSitio(Sitio objSitio, Imagen objImagen) async {
    var urlSesion = Uri.parse('${urls.API_SITIOS}/add');

    Map<String, String> cabecera = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer ${globals.token}",
    };
    final respuesta = await http.post(urlSesion,
        headers: cabecera,
        body: jsonEncode([objSitio.toJson(), objImagen.toJson()]));

    if (respuesta.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Sitio>> obtenerPuntosSitio() async {
    var urlSesion = Uri.parse('${urls.API_SITIOS}/all');
    Map<String, String> cabecera = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer ${globals.token}",
    };
    final respuesta = await http.get(urlSesion, headers: cabecera);

    if (respuesta.statusCode == 200) {
      return toList(respuesta.body);
    } else {
      throw Exception("Error en la consulta de los datos");
    }
  }

  List<Sitio> toList(String responseBody) {
    final listSites =
        (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();
    return listSites.map<Sitio>((json) => Sitio.fromJson(json)).toList();
  }

  Future<Sitio> obtenerSitio(int codSitio) async {
    var urlSesion = Uri.parse('${urls.API_SITIOS}/one/$codSitio');
    Map<String, String> cabecera = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer ${globals.token}",
    };
    final respuesta = await http.get(urlSesion, headers: cabecera);
    if (respuesta.statusCode == 200) {
      return Sitio.fromJson(jsonDecode(respuesta.body));
    } else {
      throw Exception("Error en la consulta de los datos");
    }
  }
}
 */