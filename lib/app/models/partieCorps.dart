// ignore_for_file: file_names

class PartieduCorps {
  late dynamic codCorps;
  late String prenomCorps;
  late String photoCorps;
  late String base64Corps;

  PartieduCorps(
    dynamic cod,
    String corr,
    String pho,
    String bas,
  ) {
    codCorps = cod;
    prenomCorps = corr;
    photoCorps = pho;
    base64Corps = bas;
  }

  Map toJson() => {
        'codCorps': codCorps,
        'prenomCorps': prenomCorps,
        'photoCorps': photoCorps,
        'base64Corps': base64Corps
      };

  PartieduCorps.fromJson(Map<String, dynamic> json) {
    codCorps = json['codCorps'] as dynamic;
    prenomCorps = json['prenomCorps'] as String;
    photoCorps = json['photoCorps'] as String;
    base64Corps = json['base64Corps'] as String;
  }
}
