// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';
import 'package:ccfs/app/models/questionExamen.dart';
import 'package:http/http.dart' as http;
import 'package:ccfs/app/utilities/domains/urls.dart' as urls;

class QuestionsExamenService {
  Future<List<QuestionExamen>> obtenerQuestionsExamen() async {
    var urlQuestionsExamen = Uri.parse('${urls.API_QUESTIONEXAMEN}/all');
    Map<String, String> cabecera = {
      HttpHeaders.contentTypeHeader: "application/json"
    };

    final respuesta = await http.get(urlQuestionsExamen, headers: cabecera);
    if (respuesta.statusCode == 200) {
      return toList(respuesta.body);
    } else {
      throw Exception("Error en la consulta de los datos");
    }
  }

  List<QuestionExamen> toList(String responseBody) {
    final listQuestionsExamen =
        (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();
    return listQuestionsExamen
        .map<QuestionExamen>((json) => QuestionExamen.fromJson(json))
        .toList();
  }

  Future<List<QuestionExamen>> obtenerQuestionxExamen(String codExamen) async {
    try {
      final response = await http.get(
        Uri.parse('${urls.API_QUESTIONEXAMEN}/exam/$codExamen'),
      );

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<QuestionExamen> expresiones = body
            .map(
              (dynamic item) => QuestionExamen.fromJson(item),
            )
            .toList();

        return expresiones;
      } else {
        throw Exception('Failed to load questions: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load questions');
    }
  }
}
