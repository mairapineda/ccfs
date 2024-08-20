class LesRoles {
  String codRoles;
  String prenomRoles;
  String descRoles;
  String photoRoles;
  String base64Roles;

  LesRoles({
    required this.codRoles,
    required this.prenomRoles,
    required this.descRoles,
    required this.photoRoles,
    required this.base64Roles,
  });

  Map<String, dynamic> toJson() {
    return {
      'codRoles': codRoles,
      'prenomRoles': prenomRoles,
      'descRoles': descRoles,
      'photoRoles': photoRoles,
      'base64Roles': base64Roles,
    };
  }

  factory LesRoles.fromJson(Map<String, dynamic> json) {
    return LesRoles(
      codRoles: json['codRoles'],
      prenomRoles: json['prenomRoles'],
      descRoles: json['descRoles'],
      photoRoles: json['photoRoles'],
      base64Roles: json['base64Roles'],
    );
  }
}
