
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Sitio {
  late int codSitio;
  late String nombreSitio;
  late int codUsuario;
  late String descripcionSitio;
  late String ubicacionSitio;
  late String fechaDescubrimientoSitio;
  late String base64Sitio;

  Sitio(int cod, String nom, int codU, String des, String ubi, String fec,
      String base64) {
    codSitio = cod;
    nombreSitio = nom;
    codUsuario = codU;
    descripcionSitio = des;
    ubicacionSitio = ubi;
    fechaDescubrimientoSitio = fec;
    base64Sitio = base64;
  }

  Map toJson() => {
        'codSitio': codSitio,
        'nombreSitio': nombreSitio,
        'codUsuario': codUsuario,
        'descripcionSitio': descripcionSitio,
        'ubicacionSitio': ubicacionSitio,
        'fechaDescubrimientoSitio': fechaDescubrimientoSitio,
        'base64Sitio': base64Sitio,
      };

  Sitio.fromJson(Map<String, dynamic> json) {
    codSitio = json['codSitio'] as int;
    nombreSitio = json['nombreSitio'] as String;
    codUsuario = json['codUsuario'] as int;
    descripcionSitio = json['descripcionSitio'] as String;
    fechaDescubrimientoSitio = json['fechaDescubrimientoSitio'] as String;
    ubicacionSitio = json['ubicacionSitio'] as String;
    base64Sitio = json['base64Sitio'] as String;
  }
}
