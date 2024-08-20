// ignore_for_file: file_names
import 'dart:convert';
import 'dart:io';
import 'package:ccfs/app/models/institution.dart';
import 'package:http/http.dart' as http;
import 'package:ccfs/app/utilities/domains/urls.dart' as urls;

class InstitucionService {
  Future<List<Institution>> obtenerInstitution() async {
    var urlRoles = Uri.parse('${urls.API_INSTITUTION}/all');
    Map<String, String> cabecera = {
      HttpHeaders.contentTypeHeader: "application/json"
    };

    final respuesta = await http.get(urlRoles, headers: cabecera);
    print(respuesta.body);
    if (respuesta.statusCode == 200) {
      return toList(respuesta.body);
    } else {
      throw Exception("Error en la consulta de los datos");
    }
  }

  List<Institution> toList(String responseBody) {
    final listRoles =
        (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();
    return listRoles
        .map<Institution>((json) => Institution.fromJson(json))
        .toList();
  }
}
