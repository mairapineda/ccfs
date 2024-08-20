import 'dart:convert';
import 'package:ccfs/app/models/examen.dart';
import 'package:ccfs/app/models/partieCorps.dart';
import 'package:ccfs/app/servicios/servicioExamen.dart';
import 'package:ccfs/app/widgets/contenido/questionsExamen.dart';
import 'package:flutter/material.dart';

class ExamenxCorps extends StatefulWidget {
  final PartieduCorps codCorps;

  const ExamenxCorps({super.key, required this.codCorps});

  @override
  State<ExamenxCorps> createState() => _ExamenxCorpsState();
}

class _ExamenxCorpsState extends State<ExamenxCorps> {
  final ExamenService misServicios = ExamenService();
  Future<List<Examen>> objExamen = Future(() => []);
  List<Examen>? arrExamen = [];

  @override
  void initState() {
    super.initState();
    objExamen = misServicios.obtenerExamenCorps(widget.codCorps.codCorps);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 80, 74),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<List<Examen>>(
          future: objExamen,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              arrExamen = snapshot.data;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: arrExamen!.length,
                    itemBuilder: (context, index) {
                      Examen objExamen = arrExamen![index];
                      return _generarCard(context, objExamen);
                    },
                  ),
                ],
              );
            } else {
              return const Text('No hay datos disponibles');
            }
          },
        ),
      ),
    );
  }
}

Widget _generarCard(BuildContext context, Examen objExamen) {
  var imagenExamen = const Base64Decoder().convert(objExamen.base64Fichier);
  return Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      height: MediaQuery.of(context).size.height * 0.95,
      width: double.infinity,
      margin: const EdgeInsets.only(left: 5, right: 5, bottom: 0),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 255, 255, 255),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          Center(
            child: Container(
              width: 300,
              height: 200,
              margin: const EdgeInsets.only(top: 10.0),
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: MemoryImage(imagenExamen),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    objExamen.prenomExamen,
                    style: const TextStyle(
                      fontSize: 25,
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontFamily: 'DidotBold',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    objExamen.descExamen,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontFamily: 'DidotBold',
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              QuestionExamenPage(codExamen: objExamen),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(250, 40),
                      backgroundColor: const Color(0xFFFFFFFF),
                      disabledForegroundColor:
                          const Color.fromARGB(255, 242, 245, 247)
                              .withOpacity(0.38),
                      disabledBackgroundColor:
                          const Color(0xFFB0BEC5).withOpacity(0.12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      "Reprendre l'examen",
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'MonstserratSemiBold',
                        color: Color.fromARGB(255, 0, 80, 74),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
