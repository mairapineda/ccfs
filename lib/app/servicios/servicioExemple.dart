// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';
import 'package:ccfs/app/models/exemple.dart';
import 'package:http/http.dart' as http;
import 'package:ccfs/app/utilities/domains/urls.dart' as urls;

class ExempleService {
  Future<List<Exemple>> obtenerExemple() async {
    var urlCorps = Uri.parse('${urls.API_EXEMPLE}/all');
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

  List<Exemple> toList(String responseBody) {
    final listSites =
        (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();
    return listSites.map<Exemple>((json) => Exemple.fromJson(json)).toList();
  }

  Future<List<Exemple>> obtenerExemplexFigees(String codFigees) async {
    final response = await http.get(
      Uri.parse('${urls.API_EXEMPLE}/figees/$codFigees'),
    );
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Exemple> exemples = body
          .map(
            (dynamic item) => Exemple.fromJson(item),
          )
          .toList();

      return exemples;
    } else {
      throw Exception('Fallo al cargar las Exemplees');
    }
  }
}
