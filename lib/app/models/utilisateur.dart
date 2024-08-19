class Utilisateur {
  late String nomUtils;
  late String prenomUtils;
  late String dateUtils;
  late String photoUtils;
  late String base64Utils;

  Utilisateur(String nom, String ape, String doc, String tip, String base64) {
    nomUtils = nom;
    prenomUtils = ape;
    dateUtils = doc;
    photoUtils = tip;
    base64Utils = base64;
  }

  Map toJson() => {
        'nomUtils': nomUtils,
        'prenomUtils': prenomUtils,
        'dateUtils': dateUtils,
        'photoUtils': photoUtils,
        'base64Utils': base64Utils,
      };

  Utilisateur.fromJson(Map<String, dynamic> json) {
    nomUtils = json['nomUtils'];
    prenomUtils = json['prenomUtils'];
    dateUtils = json['dateUtils'];
    photoUtils = json['photoUtils'];
    base64Utils = json['base64Utils'];
  }
}
