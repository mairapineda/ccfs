class TypeFichier {
  dynamic codFichier;
  String typeFichier;
  String prenomFichier;
  String base64Fichier;

  TypeFichier(this.codFichier, this.typeFichier, this.prenomFichier, this.base64Fichier);


  Map<String, dynamic> toJson() {
    return {
      'codFichier': codFichier,
      'typeFichier': typeFichier,
      'prenomFichier': prenomFichier,
      'base64Fichier': base64Fichier,
    };
  }

  factory TypeFichier.fromJson(Map<String, dynamic> json) {
    return TypeFichier(
      json['codFichier'],
      json['typeFichier'],
      json['prenomFichier'],
      json['base64Fichier'],
    );
  }
}
