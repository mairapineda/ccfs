// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';
import 'package:ccfs/app/models/examen.dart';
import 'package:http/http.dart' as http;
import 'package:ccfs/app/utilities/domains/urls.dart' as urls;

class ExamenService {
  Future<List<Examen>> obtenerExamen() async {
    var urlCorps = Uri.parse('${urls.API_EXAMEN}/all');
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

  List<Examen> toList(String responseBody) {
    final listSites =
        (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();
    return listSites.map<Examen>((json) => Examen.fromJson(json)).toList();
  }

  Future<List<Examen>> obtenerExamenCorps(String codCorps) async {
    final response = await http.get(
      Uri.parse('${urls.API_EXAMEN}/corps/$codCorps'),
    );
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Examen> examenes = body
          .map(
            (dynamic item) => Examen.fromJson(item),
          )
          .toList();

      return examenes;
    } else {
      throw Exception('Fallo al cargar las Examenes');
    }
  }

}
