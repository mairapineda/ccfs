class Sequence {
  String codSequence;
  dynamic codCorps;
  String prenomSequence;
  String urlarchSequence;
  String base64Sequence;

  Sequence({
    required this.codSequence,
    required this.codCorps,
    required this.prenomSequence,
    required this.urlarchSequence,
    required this.base64Sequence,
  });

  Map<String, dynamic> toJson() => {
        'codSequence': codSequence,
        'codCorps': codCorps,
        'prenomSequence': prenomSequence,
        'urlarchSequence': urlarchSequence,
        'base64Sequence': base64Sequence,
      };

  factory Sequence.fromJson(Map<String, dynamic> json) {
    return Sequence(
      codSequence: json['codSequence'],
      codCorps: (json['codCorps']),
      prenomSequence: json['prenomSequence'],
      urlarchSequence: json['urlarchSequence'],
      base64Sequence: json['base64Sequence'],
    );
  }
}
