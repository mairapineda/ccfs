// ignore_for_file: file_names,  unnecessary_this, prefer_initializing_formals

class MiSesion {
  late String id;
  late String emailAcces;
  late String prenomUtils;
  late String nomUtils;
  late String dateUtils;
  late String codInstitution;
  late String codRoles;

  MiSesion(String id, String cor, String nom, String ape, String age,
      String ins, String rol) {
    this.id = id;
    this.emailAcces = cor;
    this.nomUtils = nom;
    this.prenomUtils = ape;
    this.dateUtils = age;
    this.codInstitution = ins;
    this.codRoles = rol;
  }

  MiSesion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    emailAcces = json['emailAcces'];
    nomUtils = json['nomUtils'];
    prenomUtils = json['prenomUtils'];
    dateUtils = json['dateUtils'];
    codInstitution = json['codInstitution'];
    codRoles = json['codRoles'];
  }
}
