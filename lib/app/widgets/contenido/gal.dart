/* import 'dart:convert';
import 'dart:typed_data';

import 'package:ccfs/app/widgets/contenido/galeria.dart';
import 'package:ccfs/app/widgets/contenido/bureau.dart';
import 'package:ccfs/app/widgets/contenido/sitioListar.dart';
import 'package:flutter/material.dart';
import 'package:ccfs/app/utilities/globals.dart' as globals;

class Gal extends StatefulWidget {
  const Gal({super.key});

  @override
  State<Gal> createState() => _GalState();
}

class _GalState extends State<Gal> {
  int paginaActual = 0;
  @override
  Widget build(BuildContext context) {
    final Uint8List bytes =
        const Base64Decoder().convert(globals.base64Usuario);
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
        children: const [Galeria(), InicioListar(), SitioListar()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.photo), label: "Galeria"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Mapa"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Sitios"),
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