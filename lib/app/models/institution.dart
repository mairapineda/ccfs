class Institution {
  String codInstitution;
  String prenomInstitution;
  String descInstitution;

  Institution({
    required this.codInstitution,
    required this.prenomInstitution,
    required this.descInstitution,
  });

  // Convert an Institution object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'codInstitution': codInstitution,
      'prenomInstitution': prenomInstitution,
      'descInstitution': descInstitution,
    };
  }

  // Create an Institution object from a JSON map
  factory Institution.fromJson(Map<String, dynamic> json) {
    return Institution(
      codInstitution: json['codInstitution'],
      prenomInstitution: json['prenomInstitution'],
      descInstitution: json['descInstitution'],
    );
  }
}
