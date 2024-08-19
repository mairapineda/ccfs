// ignore_for_file: file_names, avoid_print

import 'dart:io';
import 'dart:convert';
import 'package:ccfs/app/models/imagen.dart';
import 'package:ccfs/app/models/utilisateur.dart';

import 'package:http/http.dart' as http;
import 'package:ccfs/app/utilities/domains/urls.dart' as urls;
import 'package:ccfs/app/utilities/globals.dart' as globals;

class ServiciosPerfil {
  final urlUtilisateur = urls.API_UTILISATEUR;

  Future<Utilisateur> obtenerInfoPerfil() async {
    final urlUtilisateur = urls.API_UTILISATEUR;

    Map<String, String> cabecera = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer ${globals.token}",
    };
    print(cabecera);

    final respuesta =
        await http.get(Uri.parse('$urlUtilisateur/infoBasic'), headers: cabecera);

    if (respuesta.statusCode == 200) {
      final jsonResponse = json.decode(respuesta.body);
      return Utilisateur.fromJson(jsonResponse);
    } else {
      throw Exception("Error en la consulta de los datos");
    }
  }

  Future<bool> actualizarInfoPerfil(Utilisateur objUtilisateur, Imagen objImagen) async {
    var urlUtilisateur = Uri.parse('${urls.API_UTILISATEUR}/profile');

    Map<String, String> cabecera = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer ${globals.token}",
    };
    final respuesta = await http.put(urlUtilisateur,
        headers: cabecera,
        body: jsonEncode([objUtilisateur.toJson(), objImagen.toJson()]));

    if (respuesta.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
