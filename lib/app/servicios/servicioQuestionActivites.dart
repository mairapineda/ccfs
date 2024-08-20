// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';

import 'package:ccfs/app/models/questionActivites.dart';
import 'package:http/http.dart' as http;
import 'package:ccfs/app/utilities/domains/urls.dart' as urls;

class QuestionsActivitesService {
  Future<List<QuestionActivites>> obtenerQuestionsActivites() async {
    var urlQuestionsActivites = Uri.parse('${urls.API_QUESTIONACTIVITES}/all');
    Map<String, String> cabecera = {
      HttpHeaders.contentTypeHeader: "application/json"
    };

    final respuesta = await http.get(urlQuestionsActivites, headers: cabecera);
    if (respuesta.statusCode == 200) {
      return toList(respuesta.body);
    } else {
      throw Exception("Error en la consulta de los datos");
    }
  }

  List<QuestionActivites> toList(String responseBody) {
    final listQuestionsActivites =
        (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();
    return listQuestionsActivites
        .map<QuestionActivites>((json) => QuestionActivites.fromJson(json))
        .toList();
  }

  Future<List<QuestionActivites>> obtenerQuestionxActivites(
      String codActivites) async {
    try {
      final response = await http.get(
        Uri.parse('${urls.API_QUESTIONACTIVITES}/actv/$codActivites'),
      );

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<QuestionActivites> expresiones = body
            .map(
              (dynamic item) => QuestionActivites.fromJson(item),
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
