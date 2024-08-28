class Examen {
  dynamic codExamen;
  String prenomExamen;
  String descExamen;
  int scoreExamen;
  dynamic codCorps;
  dynamic codFichier;
  String base64Fichier;

  Examen({
    required this.codExamen,
    required this.prenomExamen,
    required this.descExamen,
    required this.scoreExamen,
    required this.codCorps,
    required this.codFichier,
    required this.base64Fichier,
  });

  Map<String, dynamic> toJson() {
    return {
      'codExamen': codExamen,
      'prenomExamen': prenomExamen,
      'descExamen': descExamen,
      'scoreExamen': scoreExamen,
      'codCorps': codCorps.toJson(),
      'codFichier': codFichier.toJson(),
      'base64Fichier': base64Fichier,
    };
  }

  factory Examen.fromJson(Map<String, dynamic> json) {
    return Examen(
      codExamen: json['codExamen'],
      prenomExamen: json['prenomExamen'],
      descExamen: json['descExamen'],
      scoreExamen: json['scoreExamen'],
      codCorps: (json['codCorps']),
      codFichier: (json['codFichier']),
      base64Fichier: json['base64Fichier'],
    );
  }
}
