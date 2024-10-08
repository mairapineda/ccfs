// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';
import 'package:ccfs/app/models/responseActividad.dart';
import 'package:http/http.dart' as http;
import 'package:ccfs/app/utilities/domains/urls.dart' as urls;
import 'package:ccfs/app/utilities/globals.dart' as globals;

class ResponseUtilisateurActivitesService {
  Future<List<ReponseUtilisateurActivites>> obtenerResponseActivites() async {
    var urlResponseActivites = Uri.parse('${urls.API_RESPONSEACTIVITES}/all');
    Map<String, String> cabecera = {
      HttpHeaders.contentTypeHeader: "application/json"
    };

    final respuesta = await http.get(urlResponseActivites, headers: cabecera);
    if (respuesta.statusCode == 200) {
      return toList(respuesta.body);
    } else {
      throw Exception("Error en la consulta de los datos");
    }
  }

  List<ReponseUtilisateurActivites> toList(String responseBody) {
    final listResponseActivites =
        (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();
    return listResponseActivites
        .map<ReponseUtilisateurActivites>(
            (json) => ReponseUtilisateurActivites.fromJson(json))
        .toList();
  }

  Future<bool> guardarResponse(ReponseUtilisateurActivites objResponse) async {
    print("${globals.token}");
    var urlSesion = Uri.parse('${urls.API_RESPONSEACTIVITES}/add');

     Map<String, String> cabecera = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer ${globals.token}",
    };


    final respuesta = await http.post(
      urlSesion,
      headers: cabecera,
      body: jsonEncode(objResponse.toJson()),
    );

    if (respuesta.statusCode == 201) {
      return true;
    } else {
      print('Error: ${respuesta.statusCode}');
      return false;
    }
  }
}
