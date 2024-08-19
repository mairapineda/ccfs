class Imagen {
  late int codImagen;
  late int codSitio;
  late String nombrePublicoImagen;
  late String nombrePrivadoImagen;
  late String tipoImagen;
  late String tamanoImagen;
  late int favoritaImagen;
  late String base64Imagen;

  Imagen(int cod, int codS, String nomPu, String nomPri, String tip, String tam,
      int fav, String base64) {
    codImagen = cod;
    codSitio = codS;
    nombrePublicoImagen = nomPu;
    nombrePrivadoImagen = nomPri;
    tipoImagen = tip;
    tamanoImagen = tam;
    favoritaImagen = fav;
    base64Imagen = base64;
  }

  Map toJson() => {
        'codImagen': codImagen,
        'codSitio': codSitio,
        'nombrePublicoImagen': nombrePublicoImagen,
        'nombrePrivadoImagen': nombrePrivadoImagen,
        'tipoImagen': tipoImagen,
        'tamanoImagen': tamanoImagen,
        'favoritaImagen': favoritaImagen,
        'base64Imagen': base64Imagen,
      };

  Imagen.fromJson(Map<String, dynamic> json) {
    codImagen = json['codImagen'];
    codSitio = json['codSitio'];
    nombrePublicoImagen = json['nombrePublicoImagen'];
    nombrePrivadoImagen = json['nombrePrivadoImagen'];
    tipoImagen = json['tipoImagen'];
    favoritaImagen = json['favoritaImagen'];
    base64Imagen = json['base64Imagen'];
  }
}
