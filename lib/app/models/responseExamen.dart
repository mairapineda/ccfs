// ignore_for_file: file_names

class ReponseRepExa {
  String codQuestion;
  String reponseUtilsExamen;

  ReponseRepExa({
    required this.codQuestion,
    required this.reponseUtilsExamen});

  Map<String, dynamic> toJson() => {
        'codQuestion': codQuestion,
        'reponseUtilsExamen': reponseUtilsExamen,
      };

  ReponseRepExa.fromJson(Map<String, dynamic> json)
      : codQuestion = json['codQuestion'],
        reponseUtilsExamen = json['reponseUtilsExamen'];
}

class ReponseUtilisateurExamen {
  String codExamen;
  String codUtils;
  List<ReponseRepExa> reponseRepExa;

  ReponseUtilisateurExamen(
      {required this.codExamen,
      required this.codUtils,
      required this.reponseRepExa});

  Map<String, dynamic> toJson() => {
        'codExamen': codExamen,
        'codUtils': codUtils,
        'reponseRepExa': reponseRepExa.map((e) => e.toJson()).toList(),
      };

  ReponseUtilisateurExamen.fromJson(Map<String, dynamic> json)
      : codExamen = (json['codExamen']),
        codUtils = (json['codUtils']),
        reponseRepExa = (json['reponseRepExa'] as List)
            .map((e) => ReponseRepExa.fromJson(e))
            .toList();
}
