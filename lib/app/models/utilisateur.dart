class Utilisateur {
  late String codUtils;
  late String nomUtils;
  late String prenomUtils;
  late String dateUtils;
  late String codInstitution;
  late String codRoles;

  Utilisateur(String cod, String nom, String ape, String doc, String tip,
      String base64) {
    codUtils = cod;
    nomUtils = nom;
    prenomUtils = ape;
    dateUtils = doc;
    codInstitution = tip;
    codRoles = base64;
  }

  Map toJson() => {
        'codUtils': codUtils,
        'nomUtils': nomUtils,
        'prenomUtils': prenomUtils,
        'dateUtils': dateUtils,
        'codInstitution': codInstitution,
        'codRoles': codRoles,
      };

  Utilisateur.fromJson(Map<String, dynamic> json) {
    codUtils = json['codUtils'];
    nomUtils = json['nomUtils'];
    prenomUtils = json['prenomUtils'];
    dateUtils = json['dateUtils'];
    codInstitution = json['codInstitution'];
    codRoles = json['codRoles'];
  }
}
