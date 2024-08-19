// ignore_for_file: file_names

import 'dart:convert';

import 'package:ccfs/app/models/sitio.dart';
import 'package:flutter/material.dart';

class SitioDetalles extends StatelessWidget {
  final Sitio objSitio;

  const SitioDetalles({super.key, required this.objSitio});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002A3A),
      appBar: AppBar(
        title: Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 8), // Add top margin
            child: Text(
              objSitio.nombreSitio,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),
        ),
        backgroundColor: const Color(0xFF002A3A),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: 400,
            height: 500,
            child: Padding(
              padding: const EdgeInsets.only(top: 60), // Add top margin
              child: Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40), // Add top margin
                      child: Image.memory(
                        const Base64Decoder().convert(objSitio.base64Sitio),
                        fit: BoxFit.cover,
                        height: 200,
                        width: 800,
                      ),
                    ),
                    ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(top: 16), // Add top margin
                        child: Center(
                          child: Text(objSitio.nombreSitio),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16), // Add top margin
                      child: Text(
                        "Descubrimiento: ${objSitio.fechaDescubrimientoSitio.split('T')[0]}",
                        style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontFamily: 'Raleway',
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Text(objSitio.descripcionSitio),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
