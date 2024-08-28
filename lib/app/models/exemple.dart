class Exemple {
  dynamic codExemple;
  String prenomExemple;
  String descExemple;
  String endoligueCorpusExemple;
  String exolingueCorpusExemple;
  String contexteExemple;
  dynamic codFigees;
  dynamic codFichier;
  String base64Fichier;

  Exemple({
    required this.codExemple,
    required this.prenomExemple,
    required this.descExemple,
    required this.endoligueCorpusExemple,
    required this.exolingueCorpusExemple,
    required this.contexteExemple,
    required this.codFigees,
    required this.codFichier,
    required this.base64Fichier,
  });

  Map<String, dynamic> toJson() {
    return {
      'codExemple': codExemple,
      'prenomExemple': prenomExemple,
      'descExemple': descExemple,
      'endoligueCorpusExemple': endoligueCorpusExemple,
      'exolingueCorpusExemple': exolingueCorpusExemple,
      'contexteExemple': contexteExemple,
      'codFigees': codFigees,
      'codFichier': codFichier,
      'base64Fichier': base64Fichier,
    };
  }

  factory Exemple.fromJson(Map<String, dynamic> json) {
    return Exemple(
      codExemple: json['codExemple'],
      prenomExemple: json['prenomExemple'],
      descExemple: json['descExemple'],
      endoligueCorpusExemple: json['endoligueCorpusExemple'],
      exolingueCorpusExemple: json['exolingueCorpusExemple'],
      contexteExemple: json['contexteExemple'],
      codFigees: json['codFigees'],
      codFichier: json['codFichier'],
      base64Fichier: json['base64Fichier'],
    );
  }
}
