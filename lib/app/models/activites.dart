class Activites {
  late String codActivites;
  late String prenomActivites;
  late String typeActivites;
  late String typeActivitesdesc;
  late dynamic codFigees;
  late dynamic codFichier;
  late String base64Fichier;

  Activites(
    String cod,
    String codf,
    String pre,
    String def,
    dynamic org,
    dynamic ph,
    String base64,
  ) {
    codActivites = cod;
    prenomActivites = codf;
    typeActivites = pre;
    typeActivitesdesc = def;
    codFigees = org;
    codFichier = ph;
    base64Fichier = base64;
  }

  Map toJson() => {
        'codActivites': codActivites,
        'prenomActivites': prenomActivites,
        'typeActivites': typeActivites,
        'typeActivitesdesc': typeActivitesdesc,
        'codFigees': codFigees,
        'codFichier': codFichier,
        'base64Fichier': base64Fichier,
      };

  Activites.fromJson(Map<String, dynamic> json) {
    codActivites = json['codActivites'] as String;
    prenomActivites = json['prenomActivites'] as String;
    typeActivites = json['typeActivites'] as String;
    typeActivitesdesc = json['typeActivitesdesc'] as String;
    codFigees = json['codFigees'] as dynamic;
    codFichier = json['codFichier'] as dynamic;
    base64Fichier = json['base64Fichier'] as String;
  }
}
