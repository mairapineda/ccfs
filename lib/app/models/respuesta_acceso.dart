class RespuestaAcceso{
late String token;
  late String base64Usuario;


 RespuestaAcceso(String tok, String fot) {
    token = tok;
    base64Usuario = fot;
  }

  RespuestaAcceso.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    base64Usuario = json['base64Usuario'];
  }
}


