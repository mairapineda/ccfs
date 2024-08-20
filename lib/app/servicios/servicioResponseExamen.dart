// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';
import 'package:ccfs/app/models/responseExamen.dart';
import 'package:http/http.dart' as http;
import 'package:ccfs/app/utilities/domains/urls.dart' as urls;
import 'package:ccfs/app/utilities/globals.dart' as globals;

class ResponseUtilisateurExamenService {
  Future<List<ReponseUtilisateurExamen>> obtenerResponseExamen() async {
    var urlResponseExamen = Uri.parse('${urls.API_RESPONSEEXAMEN}/all');
    Map<String, String> cabecera = {
      HttpHeaders.contentTypeHeader: "application/json"
    };

    final respuesta = await http.get(urlResponseExamen, headers: cabecera);
    if (respuesta.statusCode == 200) {
      return toList(respuesta.body);
    } else {
      throw Exception("Error en la consulta de los datos");
    }
  }

  List<ReponseUtilisateurExamen> toList(String responseBody) {
    final listResponseExamen =
        (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();
    return listResponseExamen
        .map<ReponseUtilisateurExamen>(
            (json) => ReponseUtilisateurExamen.fromJson(json))
        .toList();
  }

  Future<bool> guardarResponse(ReponseUtilisateurExamen objResponse) async {
    var urlSesion = Uri.parse('${urls.API_RESPONSEEXAMEN}/add');

    var respuesta = http.MultipartRequest('post', urlSesion);
    respuesta.fields['codExamen'] = '66c4d60ccad1049f150d818f';
    respuesta.fields['codUtils'] = objResponse.codUtils;
    respuesta.fields['reponseRepExa'] = jsonEncode(objResponse.reponseRepExa);
    respuesta.headers['Authorization']= 'Bearer ${globals.token}';
    var request = await respuesta.send();

    if (request.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
