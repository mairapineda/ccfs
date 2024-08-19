// ignore_for_file: file_names

class Expression {
  late dynamic codCorps;
  late String codFigees;
  late String prenomFigees;
  late String definitionFigees;
  late String originFigees;
  late String photoFigees;
  late String multimediaFigees;
  late String base64Figees;
  late String base64MultiFigees;

  Expression(dynamic cod, String codf, String pre, String def, String org,
      String ph, String mul, String base64, String basem) {
    codCorps = cod;
    codFigees = codf;
    prenomFigees = pre;
    definitionFigees = def;
    originFigees = org;
    photoFigees = ph;
    multimediaFigees = mul;
    base64Figees = base64;
    base64MultiFigees = basem;
  }

  Map toJson() => {
        'codCorps': codCorps,
        'codFigees': codFigees,
        'prenomFigees': prenomFigees,
        'definitionFigees': definitionFigees,
        'originFigees': originFigees,
        'photoFigees': photoFigees,
        'multimediaFigees': multimediaFigees,
        'base64Figees': base64Figees,
        'base64MultiFigees': base64MultiFigees,
      };
  Expression.fromJson(Map<String, dynamic> json) {
    codCorps = json['codCorps'] as dynamic;
    codFigees = json['codFigees'] as String;
    prenomFigees = json['prenomFigees'] as String;
    definitionFigees = json['definitionFigees'] as String;
    originFigees = json['originFigees'] as String;
    photoFigees = json['photoFigees'] as String;
    multimediaFigees = json['multimediaFigees'] as String;
    base64Figees = json['base64Figees'] as String;
    base64MultiFigees = json['base64MultiFigees'] as String;
  }
}
