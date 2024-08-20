// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';
import 'package:ccfs/app/models/activites.dart';
import 'package:http/http.dart' as http;
import 'package:ccfs/app/utilities/domains/urls.dart' as urls;

class ActivitesService {
  Future<List<Activites>> obtenerActivites() async {
    var urlCorps = Uri.parse('${urls.API_ACTIVITES}/all');
    Map<String, String> cabecera = {
      HttpHeaders.contentTypeHeader: "application/json"
    };

    final respuesta = await http.get(urlCorps, headers: cabecera);
    if (respuesta.statusCode == 200) {
      return toList(respuesta.body);
    } else {
      throw Exception("Error en la consulta de los datos");
    }
  }

  List<Activites> toList(String responseBody) {
    final listSites =
        (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();
    return listSites
        .map<Activites>((json) => Activites.fromJson(json))
        .toList();
  }

  Future<List<Activites>> obtenerActivitesFigees(String codFigees) async {
    final response = await http.get(
      Uri.parse('${urls.API_ACTIVITES}/cod/$codFigees'),
    );
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Activites> activites = body
          .map(
            (dynamic item) => Activites.fromJson(item),
          )
          .toList();

      return activites;
    } else {
      throw Exception('Fallo al cargar las Activiteses');
    }
  }

  Future<Activites> obtenerActivitesxcod(String codActivites) async {
    var urlSesion = Uri.parse('${urls.API_ACTIVITES}/id/$codActivites');
    Map<String, String> cabecera = {
      HttpHeaders.contentTypeHeader: "application/json",
    
    };
    final respuesta = await http.get(urlSesion, headers: cabecera);
    if (respuesta.statusCode == 200) {
      return Activites.fromJson(jsonDecode(respuesta.body));
    } else {
      throw Exception("Error en la consulta de los datos");
    }
  }
}
