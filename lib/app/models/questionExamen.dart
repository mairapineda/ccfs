// ignore_for_file: file_names

class QuestionExamen {
  late String codQuestion;
  late String prenomReponExamen;
  late String questions;
  late List<String> options;
  late String reponseExamen;
  late String tipo;
  late dynamic? codFichier;
  late dynamic codExamen;
  late String? base64Fichier;
  String? selectedOption;
  bool hasMovedOption = false;

  QuestionExamen(String id, String pre, String que, List<String> opt,
      String res, String tip, dynamic? codF, dynamic codE, String? bas,
      {this.selectedOption, this.hasMovedOption = false}) {
    codQuestion = id;
    prenomReponExamen = pre;
    questions = que;
    options = opt;
    reponseExamen = res;
    tipo = tip;
    codFichier = codF;
    codExamen = codE;
    base64Fichier = bas;
  }

  QuestionExamen.fromJson(Map<String, dynamic> json) {
    codQuestion = json['codQuestion'] as String;
    prenomReponExamen = json['prenomReponExamen'] as String;
    questions = json['questions'] as String;
    options = List<String>.from(json['options'] as List);
    reponseExamen = json['reponseExamen'] as String;
    tipo = json['tipo'] as String;
    codFichier = json['codFichier'] as dynamic?;
    codExamen = json['codExamen'] as dynamic;
    base64Fichier = json['base64Fichier'] as String?;
    selectedOption = json['selectedOption'] as String?;
    hasMovedOption = false;
  }

  Map<String, dynamic> toJson() {
    return {
      'codQuestion': codQuestion,
      'prenomReponExamen': prenomReponExamen,
      'questions': questions,
      'options': options,
      'reponseExamen': reponseExamen,
      'tipo': tipo,
      'codFichier': codFichier,
      'codExamen': codExamen,
      'base64Fichier': base64Fichier,
      'selectedOption': selectedOption,
      'hasMovedOption': hasMovedOption,
    };
  }
}
