// ignore_for_file: file_names,  unnecessary_this, prefer_initializing_formals

class MiSesion {
  late String id;
  late String emailAcces;
  late String nomUtils;
  late String prenomUtils;
  late String dateUtils;

  MiSesion(String id, String cor, String nom, String ape, String age) {
    this.id = id;
    this.emailAcces = cor;
    this.nomUtils = nom;
    this.prenomUtils = ape;
    this.dateUtils = age;
  }

  MiSesion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    emailAcces = json['emailAcces'];
    nomUtils = json['nomUtils'];
    prenomUtils = json['prenomUtils'];
    dateUtils = json['dateUtils'];
  }
}
