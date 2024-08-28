// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';
import 'package:ccfs/app/models/sequence.dart';
import 'package:http/http.dart' as http;
import 'package:ccfs/app/utilities/domains/urls.dart' as urls;

class SequenceService {
  Future<List<Sequence>> obtenerSequence() async {
    var urlSequence = Uri.parse('${urls.API_SEQUENCE}/all');
    Map<String, String> cabecera = {
      HttpHeaders.contentTypeHeader: "application/json"
    };

    final respuesta = await http.get(urlSequence, headers: cabecera);
    if (respuesta.statusCode == 200) {
        return toList(respuesta.body);
    } else {
      throw Exception("Error en la consulta de los datos");
    }
  }
  
  List<Sequence> toList(String responseBody) {
    final listSites =
        (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();
    return listSites.map<Sequence>((json) => Sequence.fromJson(json)).toList();
  }
   Future<List<Sequence>> obtenerSequenceCorps(String codCorps) async {
    final response = await http.get(
      Uri.parse('${urls.API_SEQUENCE}/corps/$codCorps'),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Sequence> expresiones = body
          .map(
            (dynamic item) => Sequence.fromJson(item),
          )
          .toList();

      return expresiones;
    } else {
      throw Exception('Fallo al cargar las expresiones');
    }
  }
   
}
