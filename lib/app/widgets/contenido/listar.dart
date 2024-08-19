/* import 'dart:convert';
import 'dart:typed_data';

import 'package:app_roting/app/widgets/contenido/galeria.dart';
import 'package:app_roting/app/widgets/contenido/bureau.dart';
import 'package:app_roting/app/widgets/contenido/mapa.dart';
import 'package:app_roting/app/widgets/contenido/sitioListar.dart';
import 'package:flutter/material.dart';
import 'package:app_roting/app/utilities/globals.dart' as globals;

class Listar extends StatefulWidget {
  const Listar({super.key});

  @override
  State<Listar> createState() => _ListarState();
}

class _ListarState extends State<Listar> {
  int paginaActual = 0;
  @override
  Widget build(BuildContext context) {
    final Uint8List bytes = const Base64Decoder().convert(globals.base64Usuario);
    PageController controlPaginas = PageController();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TurismoAPP',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF002A3A),
        actions: <Widget>[
          IconButton(
            icon: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.memory(
                bytes,
                fit: BoxFit.contain,
                height: 45,
              ),
            ),
            tooltip: globals.objSesion.emailAcces,
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
        /*    title: */
      ),
      body: PageView(
        controller: controlPaginas,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          SitioListar(),
          Galeria(),
          Mapa(),
          InicioListar(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Sitios"),
          BottomNavigationBarItem(icon: Icon(Icons.photo), label: "Galeria"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Mapa"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
        ],
        backgroundColor: const Color(0xFF002A3A),
        selectedItemColor:
            const Color.fromARGB(255, 249, 249, 248).withOpacity(.8),
        currentIndex: paginaActual,
        onTap: (indice) {
          paginaActual = indice;
          controlPaginas.animateToPage(paginaActual,
              duration: const Duration(microseconds: 500),
              curve: Curves.bounceInOut);
          setState(() {});
        },
      ),
    );
  }
}

Image imageFromBase64String(String base64String) {
  return Image.memory(base64Decode(base64String));
}
 */