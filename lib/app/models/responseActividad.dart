class ReponseActividad {
  String codQuestion;
  String reponseUtilsActi;

  ReponseActividad({required this.codQuestion, required this.reponseUtilsActi});

  Map<String, dynamic> toJson() => {
        'codQuestion': codQuestion,
        'reponseUtilsActi': reponseUtilsActi,
      };

  ReponseActividad.fromJson(Map<String, dynamic> json)
      : codQuestion = json['codQuestion'],
        reponseUtilsActi = json['reponseUtilsActi'];
}


class ReponseUtilisateurActivites {
  String codActivites;
  String codUtils;
  List<ReponseActividad> reponseActividad;

  ReponseUtilisateurActivites({
     required this.codActivites, required this.codUtils, required this.reponseActividad});

  Map<String, dynamic> toJson() => {
        'codActivites': codActivites,
        'codUtils': codUtils,
        'reponseActividad': reponseActividad.map((e) => e.toJson()).toList(),
      };

  ReponseUtilisateurActivites.fromJson(Map<String, dynamic> json)
      : codActivites = (json['codActivites']),
        codUtils = (json['codUtils']),
        reponseActividad = (json['reponseActividad'] as List)
            .map((e) => ReponseActividad.fromJson(e))
            .toList();
}
