import 'dart:convert';

import 'package:ccfs/app/models/sitio.dart';
import 'package:ccfs/app/servicios/servicioSitio.dart';
import 'package:flutter/material.dart';

class Galeria extends StatefulWidget {
  const Galeria({super.key});

  @override
  State<Galeria> createState() => _GaleriaState();
}

class _GaleriaState extends State<Galeria> {
  final misServicios = ServicioSitio();
  Future<List<Sitio>> arrTmp = Future(() => []);

  List<Sitio>? arrSitios = [];
  @override
  void initState() {
    super.initState();
    arrTmp = misServicios.obtenerPuntosSitio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF002A3A),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: Text(
                'Bienvenido a la Galería',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            const Center(
              child: Text(
                'Sitios de Boyacá',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 39, 109, 105),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: FutureBuilder<List<Sitio>>(
                  future: arrTmp,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      arrSitios = snapshot.data;
                      return GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              2, // Adjust the number of columns as needed
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1,
                        ),
                        itemCount: arrSitios!.length,
                        itemBuilder: (context, index) {
                          Sitio objSitio = arrSitios!.elementAt(index);
                          return _generarCard(context, objSitio);
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    // By default, show a loading spinner.
                    return const CircularProgressIndicator();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _generarCard(BuildContext context, Sitio objSitio) {
    var imagenSitio = const Base64Decoder().convert(objSitio.base64Sitio);

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: SizedBox(
                height: 150,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                       child: Image.memory(
                        imagenSitio,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        objSitio.nombreSitio,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFF002A3A),
            width: 2.0,
          ),
        ),
        child: Image.memory(
          imagenSitio,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
