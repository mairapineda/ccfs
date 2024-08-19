// ignore_for_file: unused_local_variable, avoid_print, file_names, use_build_context_synchronously

import 'dart:convert';

import 'dart:async';
import 'dart:typed_data';
import 'package:ccfs/app/models/imagen.dart';
import 'package:ccfs/app/models/sitio.dart';
import 'package:ccfs/app/servicios/servicioSitio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class SitioCrear extends StatefulWidget {
  const SitioCrear({super.key});

  @override
  State<SitioCrear> createState() => _SitioCrearState();
}

class _SitioCrearState extends State<SitioCrear> {
  final TextEditingController _cajaNombre = TextEditingController();
  final TextEditingController _cajaDescripcion = TextEditingController();
  final TextEditingController _cajaFecha = TextEditingController();
  final TextEditingController _cajaNombreImagen = TextEditingController();

  /* late List<CustomImage> imagenes = []; */
  late double size;
  late ImagePicker imagePicker = ImagePicker();
  late int idGenerator;

  final objSitio = Sitio(0, "", 0, "", "", "", "");
  final objImagen = Imagen(0, 0, "", "", "", "", 0, "");
  final misServicios = ServicioSitio();

  final _frmSitio = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    /* imagenes = []; */
    size = 400;
    idGenerator = 0;
    imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    var marcaSitio = ModalRoute.of(context)!.settings.arguments as Marker;
    objSitio.ubicacionSitio =
        '${marcaSitio.point.latitude},${marcaSitio.point.longitude}';

    return Scaffold(
      backgroundColor:
          const Color(0xFF002A3A), // Color de fondo de la pantalla completa
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.topRight,
          child: Text(
            "Agregar",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: const Color(0xFF002A3A),
      ),
      body: Stack(
        children: [
          // Imagen
          Positioned(
            top: 5.0, // Ajusta la posición vertical de la imagen
            // Ajusta la posición horizontal de la imagen
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Botones de editar y agregar imagen
                Container(
                  padding: const EdgeInsets.only(left: 50, right: 20, top: 10),
                  child: Stack(children: [
                    SizedBox(
                        height: 150,
                        width: size,
                        child: ClipRRect(
                            child: Image.memory(
                          const Base64Decoder().convert(objImagen.base64Imagen),
                          fit: BoxFit.fill,
                        ))),
                    Positioned(
                        right: 100,
                        top: 4,
                        child: InkWell(
                          onTap: () {
                            setState(() {});
                          },
                        ))
                  ]),
                ),

                // Ajusta la altura de la imagen
              ],
            ),
          ),
          Positioned(
            top: 170,
            left: 10, right: 10, // Ajusta la posición vertical del contenedor
            // Ajusta la posición horizontal del contenedor
            child: Container(
                width: 300, // Ajusta el ancho del contenedor
                height: 370, // Ajusta la altura del contenedor
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Form(
                    key: _frmSitio,
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Nombre Sitio",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 6, 6, 6),
                            ),
                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: _cajaNombre,
                          validator: (texto) {
                            if (texto!.isEmpty) {
                              return "Ingrese el nombre del sitio";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            filled: true,
                            fillColor: const Color.fromARGB(168, 220, 212, 212),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.only(),
                          child: Column(
                            children: <Widget>[
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Fecha Sitio",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 6, 6, 6),
                                  ),
                                ),
                              ),
                              TextFormField(
                                controller: _cajaFecha,
                                readOnly: true,
                                onTap: () async {
                                  DateTime? fechaSeleccionada =
                                      await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1200),
                                    lastDate: DateTime(2100),
                                  );
                                  if (fechaSeleccionada != null) {
                                    String fechaFormateada =
                                        DateFormat('yyyy-MM-dd')
                                            .format(fechaSeleccionada);
                                    setState(() {
                                      _cajaFecha.text = fechaFormateada;
                                    });
                                  }
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: const Color.fromARGB(168, 220, 212, 212),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.only(),
                          child: Column(
                            children: <Widget>[
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Descripción Sitio",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 6, 6, 6),
                                  ),
                                ),
                              ),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                controller: _cajaDescripcion,
                                validator: (texto) {
                                  if (texto!.isEmpty) {
                                    return "Ingrese la descripción del sitio";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  filled: true,
                                  fillColor: const Color.fromARGB(168, 220, 212, 212),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Padding(
                            padding: const EdgeInsets.only(),
                            child: Column(
                              children: <Widget>[
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Imagen Sitio",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 6, 6, 6),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(
                                      1), // Specify the desired contentPadding
                                  child: TextFormField(
                                    controller: _cajaNombreImagen,
                                    onTap: () {
                                      seleccionarImagen();
                                    },
                                    validator: (texto) {
                                      if (texto!.isEmpty) {
                                        return "Seleccione una imagen";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      isDense: true,
                                      prefixIcon: const Icon(
                                        Icons.image,
                                        size: 20,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      filled: true,
                                      fillColor: const Color.fromARGB(
                                          168, 220, 212, 212),
                                      contentPadding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 25),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: const Color(0xFF002A3A), side: const BorderSide(
                                        color: Color(0xFF002A3A),
                                        width: 2.0,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      minimumSize: const Size(70, 40),
                                    ),
                                    onPressed: () async {
                                      if (_frmSitio.currentState!.validate()) {
                                        objSitio.codUsuario = 0;
                                        objSitio.nombreSitio = _cajaNombre.text;
                                        objSitio.descripcionSitio =
                                            _cajaDescripcion.text;
                                        objSitio.fechaDescubrimientoSitio =
                                            _cajaFecha.text;

                                        if (await misServicios.registrarSitio(
                                            objSitio, objImagen)) {
                                          Navigator.pushNamed(context, '/map');
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                /* grabarBicicleta(nuevaBici); */
                                                return AlertDialog(
                                                  title: const Text('Error !'),
                                                  content: Text(
                                                      'Fallo al registar el sitio turistico ${objSitio.nombreSitio} '),
                                                );
                                              });
                                          _limpiarCajas();
                                        }

                                        setState(() {
                                          /* globals.ARREGLO_BICIS.add(nuevaBici); */
                                        });
                                        /* ; */
                                      }
                                    },
                                    child: const Text('Registrar'),
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ))),
          ),
        ],
      ),
    );
  }

  void _limpiarCajas() {
    setState(() {
      _cajaNombre.text = "";
      _cajaFecha.text = "";
      _cajaDescripcion.text = "";
      _cajaNombreImagen.text = "";
      objImagen.base64Imagen = "";
    });
  }

  Future seleccionarImagen() async {
    // XFile? image = await imagePicker.pickImage(source: ImageSource.camera);
    var image = await imagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      Uint8List datosImagen = await image.readAsBytes();
      int id = idGenerator++;
      var imagenBase64 = base64Encode(datosImagen);
      _cajaNombreImagen.text = image.name;

      objImagen.base64Imagen = imagenBase64;
      objImagen.nombrePublicoImagen = image.name;
      objImagen.tipoImagen = image.mimeType!;
      objImagen.tamanoImagen =
          (await image.readAsBytes()).lengthInBytes.toString();

      print(objImagen.tamanoImagen);
      setState(() {});
    }
  }
}

/* class CustomImage {
  Uint8List imageData;
  int id;
  CustomImage({required this.imageData, required this.id});
}
 */