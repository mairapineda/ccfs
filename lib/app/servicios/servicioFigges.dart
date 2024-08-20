// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';
import 'package:ccfs/app/models/expressionFigges.dart';
import 'package:http/http.dart' as http;
import 'package:ccfs/app/utilities/domains/urls.dart' as urls;

class FiggesService {
  Future<List<Expression>> obtenerFigges() async {
    var urlFigges = Uri.parse('${urls.API_FIGGES}/all');
    Map<String, String> cabecera = {
      HttpHeaders.contentTypeHeader: "application/json"
    };

    final respuesta = await http.get(urlFigges, headers: cabecera);
    if (respuesta.statusCode == 200) {
      return toList(respuesta.body);
    } else {
      throw Exception("Error en la consulta de los datos");
    }
  }

  List<Expression> toList(String responseBody) {
    final listFigges =
        (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();
    return listFigges
        .map<Expression>((json) => Expression.fromJson(json))
        .toList();
  }

  Future<List<Expression>> obtenerExpressionCorps(String codCorps) async {
    final response = await http.get(
      Uri.parse('${urls.API_FIGGES}/corps/$codCorps'),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Expression> expresiones = body
          .map(
            (dynamic item) => Expression.fromJson(item),
          )
          .toList();

      return expresiones;
    } else {
      throw Exception('Fallo al cargar las expresiones');
    }
  }

/*  Future<List<Expression>> obtenerExpressionCorps(String codCorps) async {
    var urlSesion = Uri.parse('${urls.API_FIGGES}/corps/$codCorps');
    Map<String, String> cabecera = {
      HttpHeaders.contentTypeHeader: "application/json",
    };
   final respuesta = await http.get(urlSesion, headers: cabecera);
  if (respuesta.statusCode == 200) {
    final listExpressions = toList(respuesta.body);
    final filteredExpressions = listExpressions.where((expression) {
      return expression.partOfBodyCode == codCorps;
    }).toList();
    return filteredExpressions;
  } else {
    throw Exception("Error en la consulta de los datos");
  }
  }
 */
Future<Expression> obtenerExpression(String codFigees) async {
  try {
    var urlSesion = Uri.parse('${urls.API_FIGGES}/one/$codFigees');
    
    Map<String, String> cabecera = {
      HttpHeaders.contentTypeHeader: "application/json",
    };
    final respuesta = await http.get(urlSesion, headers: cabecera);
   
    if (respuesta.statusCode == 200) {
      return Expression.fromJson(jsonDecode(respuesta.body));
    } else {
      throw Exception("Error en la consulta de los datos");
    }
  } catch (e) {
    print('Error: $e');
    rethrow;
  }
}

}
