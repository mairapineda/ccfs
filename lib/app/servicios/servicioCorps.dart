// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';
import 'package:ccfs/app/models/partieCorps.dart';
import 'package:http/http.dart' as http;
import 'package:ccfs/app/utilities/domains/urls.dart' as urls;

class CorpsService {
  Future<List<PartieduCorps>> obtenerCorps() async {
    var urlCorps = Uri.parse('${urls.API_CORPS}/all');
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
  
  List<PartieduCorps> toList(String responseBody) {
    final listSites =
        (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();
    return listSites.map<PartieduCorps>((json) => PartieduCorps.fromJson(json)).toList();
  }
   
}
