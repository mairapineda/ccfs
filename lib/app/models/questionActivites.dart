// ignore_for_file: file_names

class QuestionActivites {
  String codQuestion;
  String? prenomReponActivites;
  String? questionsActivites;
  List<String> optionsActivites;
  List<String> reponseActivites;
  String? retourActivites;
  String? tipo;
  dynamic? codFichier;
  dynamic codActivites;
  String? base64Fichier;
  String? selectedOption;
  bool? hasMovedOption = false;

  QuestionActivites({
    required this.codQuestion,
    required this.prenomReponActivites,
    required this.questionsActivites,
    required this.optionsActivites,
    required this.reponseActivites,
    required this.tipo,
    required this.retourActivites,
    this.codFichier,
    this.codActivites,
    required this.base64Fichier,
    required this.selectedOption,
    required this.hasMovedOption,
  });

  factory QuestionActivites.fromJson(Map<String, dynamic> json) {
    return QuestionActivites(
        codQuestion: json['codQuestion'],
        prenomReponActivites: json['prenomReponActivites'],
        questionsActivites: json['questionsActivites'],
        optionsActivites: List<String>.from(json['optionsActivites']?? []),
        reponseActivites: List<String>.from(json['reponseActivites']?? []),
        retourActivites: json['retourActivites'],
        tipo: json['tipo'],
        codFichier: json['codFichier'],
        codActivites: json['codActivites'],
        base64Fichier: json['base64Fichier'],
        selectedOption: json['selectedOption'] as String?,
        hasMovedOption: false, 
        );
  }

  Map<String, dynamic> toJson() {
    return {
      'codQuestion': codQuestion,
      'prenomReponActivites': prenomReponActivites,
      'questionsActivites': questionsActivites,
      'optionsActivites': optionsActivites,
      'reponseActivites': reponseActivites,
      'retourActivites': retourActivites,
      'tipo': tipo,
      'codFichier': codFichier,
      'codActivites': codActivites,
      'base64Fichier': base64Fichier,
      'selectedOption': selectedOption,
      'hasMovedOption': hasMovedOption,
    };
  }
}
