// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io' show HttpHeaders;
import 'package:ccfs/app/models/registre.dart';
import 'package:ccfs/app/models/respuesta_acceso.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:ccfs/app/models/acceso.dart';
import 'package:ccfs/app/models/miSesion.dart';
import 'package:http/http.dart' as http;
import 'package:ccfs/app/utilities/domains/urls.dart' as urls;
import 'package:ccfs/app/utilities/globals.dart' as globals;

class ServicioPublico {
  Future<bool> iniciarSesion(Acces objAcces) async {
    var urlSesion = Uri.parse('${urls.API_SESION}/singin');

    Map<String, String> cabecera = {
      HttpHeaders.contentTypeHeader: "application/json"
    };
    final respuesta = await http.post(urlSesion,
        headers: cabecera, body: jsonEncode(objAcces.toJson()));

    if (respuesta.statusCode == 200) {
      final jsonResponse = json.decode(respuesta.body);
      RespuestaAcceso objRespuesta = RespuestaAcceso.fromJson(jsonResponse);

      final decodficacion = JwtDecoder.decode(objRespuesta.token);
      MiSesion objSesion = MiSesion.fromJson(decodficacion);
      globals.objSesion = objSesion;

      globals.base64Usuario = objRespuesta.base64Usuario;
      globals.token = objRespuesta.token;
      return true;
    } else {
      return false;
    }
  }

  Future<bool> registrarUsuario(Registre objRegistre) async {
    var urlRegistre = Uri.parse('${urls.API_REGISTRO}/user');

    Map<String, String> cabecera = {
      HttpHeaders.contentTypeHeader: "application/json"
    };
    final respuesta = await http.post(urlRegistre,
        headers: cabecera, body: jsonEncode(objRegistre.toJson()));

    if (respuesta.statusCode == 200) {
      final jsonResponse = json.decode(respuesta.body);
      RespuestaAcceso objRespuesta = RespuestaAcceso.fromJson(jsonResponse);

      final decodficacion = JwtDecoder.decode(objRespuesta.token);
      MiSesion objSesion = MiSesion.fromJson(decodficacion);
      globals.objSesion = objSesion;

      globals.base64Usuario = objRespuesta.base64Usuario;
      globals.token = objRespuesta.token;
      return true;
    } else {
      return false;
    }
  }

  Future<String> obtenerRol(String correo) async {
    var urlRol = Uri.parse(
        '${urls.API_SESION}/obtener/$correo'); 

    Map<String, String> cabecera = {
      HttpHeaders.contentTypeHeader: "application/json"
    };
    final respuesta = await http.get(
      urlRol,
      headers: cabecera,
    );

    if (respuesta.statusCode == 200) {
      final data = jsonDecode(respuesta.body);
      return data['nombreRol'];
    } else {
      print('Error: ${respuesta.statusCode}');
      throw Exception('Error al obtener el rol: ${respuesta.statusCode}');
    }
  }
}
