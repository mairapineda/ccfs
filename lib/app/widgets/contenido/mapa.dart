/* // ignore_for_file: unused_import, avoid_web_libraries_in_flutter, avoid_function_literals_in_foreach_calls

import 'dart:convert';
import "dart:js_util" show equal;
import 'dart:typed_data';

import 'package:app_roting/app/models/sitio.dart';
import 'package:app_roting/app/servicios/servicioSitio.dart';
import 'package:app_roting/app/widgets/contenido/listarUnSitio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';

class Mapa extends StatefulWidget {
  const Mapa({super.key});
  @override
  State<Mapa> createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  final misServicios = ServicioSitio();
  List<Marker> marcas = [];
  Marker marca = const Marker(point: LatLng(0, 0), child: Icon(Icons.location_on));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<Sitio>>(
          future: misServicios.obtenerPuntosSitio(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return FlutterMap(
                options: MapOptions(
                    initialCenter: const LatLng(5.5133000, -73.4167500),
                    initialZoom: 9.2,
                    onLongPress: (pos0, latlng) {
                      marcas.clear();
                      marca = Marker(
                        width: 150.0,
                        height: 150.0,
                        point: latlng,
                        child: const Icon(
                          Icons.location_on,
                          color: Color.fromRGBO(33, 158, 155, 1.0),
                          size: 35.0,
                        ),
                      );
                      setState(() {
                        marcas.add(marca);
                      });
                    }),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(markers: obtenerPuntos(snapshot.data)),
                  MarkerLayer(markers: marcas),
                  PopupMarkerLayer(
                    options: PopupMarkerLayerOptions(
                      markers: marcas,
                      popupDisplayOptions: PopupDisplayOptions(
                          builder: (BuildContext context, Marker marker) {
                        return _cardAgregarSitio(context, marker);
                      }),
                    ),
                  ),
                  PopupMarkerLayer(
                    options: PopupMarkerLayerOptions(
                      markers: obtenerPuntos(snapshot.data),
                      popupDisplayOptions: PopupDisplayOptions(
                          builder: (BuildContext context, Marker marker) {
                        return _cardMostrarSitio(context, marker, snapshot.data);
                      }),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ));
  }
}

Widget _cardAgregarSitio(BuildContext context, Marker marca) {
  return Card(
    color: const Color(0xFF002A3A),
    child: InkWell(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              constraints: const BoxConstraints(minWidth: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      "Nuevo Sitio",
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 11,
                        color: Color.fromARGB(255, 255, 255, 255), // Set the color here
                      ),
                    ),
                  ),
                  OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/addSite",
                            arguments: marca);
                      },
                      style: OutlinedButton.styleFrom(
                          foregroundColor: const Color.fromARGB(255, 255, 255, 255), side: const BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                          minimumSize: const Size(40, 30)),
                      child: const Text('Agregar'))
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _cardMostrarSitio(
  BuildContext context, Marker marca, List<Sitio>? arrSitios) {
  var latLong = [];
  var puntoTmp = const LatLng(0, 0);
  var objSitio = Sitio(0, "", 0, "", "", "", "");
  arrSitios!.forEach((sitio) => {
    latLong = sitio.ubicacionSitio.split(','),
    puntoTmp = LatLng(double.parse(latLong[0]), double.parse(latLong[1])),
    if (equal(puntoTmp.toString(), marca.point.toString())) {objSitio = sitio}
  });
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
        borderRadius: BorderRadius.circular(4),
      ),
      color: const Color(0xFF002A3A), // Add the color property here
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        child: Container(
          constraints: const BoxConstraints(
              minWidth: 180, maxWidth: 300, maxHeight: 100),
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
                      height: 60,
                    ),
                    Container(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            objSitio.nombreSitio,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontFamily: 'Raleway',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(height: 5),
                          // Add a subtitle widget
                          Text(
                            "Descubrimiento: ${objSitio.fechaDescubrimientoSitio.split('T')[0]}",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontFamily: 'Raleway',
                              fontSize: 12,
                            ),
                          ),
                          Container(height: 5),
                          Text(
                            objSitio.descripcionSitio,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 255, 251, 251),
                              fontFamily: 'Raleway',
                              fontSize: 12,
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
      ),
    ),
  );
}
List<Marker> obtenerPuntos(List<Sitio>? arrSitios) {
  List<Marker> puntos = [];
  var latLong = [];

  arrSitios!.forEach((sitio) => {
        latLong = sitio.ubicacionSitio.split(','),
        puntos.add(Marker(
          width: 150.0,
          height: 150.0,
          point: LatLng(double.parse(latLong[0]), double.parse(latLong[1])),
          child: const Icon(
            Icons.location_on,
            color: Color(0xFF002A3A),
            size: 35.0,
          ),
        ))
      });
  return puntos;
} 
 */