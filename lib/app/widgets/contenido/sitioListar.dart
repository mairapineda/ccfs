// ignore_for_file: file_names

import 'dart:convert';

import 'package:ccfs/app/models/sitio.dart';
import 'package:ccfs/app/servicios/servicioSitio.dart';
import 'package:ccfs/app/widgets/contenido/listarUnSitio.dart';
// ignore: unused_import
import 'package:ccfs/app/widgets/contenido/mapa.dart';
import 'package:flutter/material.dart';

class SitioListar extends StatefulWidget {
  const SitioListar({super.key});

  @override
  State<SitioListar> createState() => _SitioListarState();
}

class _SitioListarState extends State<SitioListar> {
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
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<List<Sitio>>(
            future: arrTmp,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                arrSitios = snapshot.data;
                return ListView(
                  children: List.generate(arrSitios!.length, (index) {
                    Sitio objSitio = arrSitios!.elementAt(index);
                    return _generarCard(context, objSitio);
                  }),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            }),
      ),
    );
  }
}

Widget _generarCard(BuildContext context, Sitio objSitio) {
  var imagenSitio = const Base64Decoder().convert(objSitio.base64Sitio);
  return GestureDetector(
    onTap: () {
      // Navigate to the details screen/page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SitioDetalles(objSitio: objSitio),
        ),
      );
    },
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Image.memory(
                  imagenSitio,
                  fit: BoxFit.contain,
                  height: 80,
                ),
                Container(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.location_on),
                        iconColor: Colors.blue,
                        title: Text(objSitio.nombreSitio),
                      ),
                      Text(
                        "Descubrimiento: ${objSitio.fechaDescubrimientoSitio.split('T')[0]}",
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontFamily: 'Raleway',
                          fontSize: 12,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ListBody(
                          children: [
                            Text(
                              objSitio.descripcionSitio,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
