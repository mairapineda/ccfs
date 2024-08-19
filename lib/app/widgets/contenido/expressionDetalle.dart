// ignore_for_file: file_names

import 'dart:convert';

import 'package:ccfs/app/models/expressionFigges.dart';

import 'package:flutter/material.dart';

class FigeesDetalles extends StatelessWidget {
  final Expression objfigees;

  const FigeesDetalles({super.key, required this.objfigees});
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
              objfigees.prenomFigees,
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
              padding: const EdgeInsets.only(top: 60), 
              child: Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40), 
                      child: Image.memory(
                        const Base64Decoder().convert(objfigees.base64Figees),
                        fit: BoxFit.cover,
                        height: 200,
                        width: 800,
                      ),
                    ),
                    ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(top: 16), 
                        child: Center(
                          child: Text(objfigees.prenomFigees),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16), // Add top margin
                      child: Text(
                        "Descubrimiento: ${objfigees.definitionFigees.split('T')[0]}",
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
                        child: Text(objfigees.originFigees),
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
