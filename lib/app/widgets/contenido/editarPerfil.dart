/* // ignore_for_file: file_names, use_build_context_synchronously

import 'dart:convert';
import 'dart:typed_data';

import 'package:ccfs/app/models/imagen.dart';
import 'package:ccfs/app/models/utilisateur.dart';
import 'package:ccfs/app/servicios/serviciosPerfil.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:ccfs/app/utilities/globals.dart' as globals;
import 'package:image_picker/image_picker.dart';

class EditarPerfil extends StatefulWidget {
  const EditarPerfil({super.key});

  @override
  State<EditarPerfil> createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  final TextEditingController _cajanomUtils = TextEditingController();
  final TextEditingController _cajaprenomUtils = TextEditingController();
  final TextEditingController _cajadateUtils = TextEditingController();
  final TextEditingController _cajaphotoUtils = TextEditingController();
  final TextEditingController _cajabase64Utils = TextEditingController();
  

  final ServiciosPerfil misServiciosPerfil = ServiciosPerfil();
  late double size;
  late ImagePicker imagePicker = ImagePicker();
  late int idGenerator;
  late Future<Utilisateur> objUsu =
      Future(() => Utilisateur( '', '', '', '', ''));

  final _frmUtilisateur = GlobalKey<FormState>();
  final objUtilisateur = Utilisateur('', '', '', '', '');
  final objImagen = Imagen(0, 0, "", "", "", "", 0, "");
  @override
  void initState() {
    super.initState();
    idGenerator = 0;
    size = 100;
    imagePicker = ImagePicker();
    objUsu = misServiciosPerfil.obtenerInfoPerfil();
    objUsu.then((Utilisateur Utilisateur) {
      _cajaNombre.text = Utilisateur.nombresUtilisateur;
      _cajaApellido.text = Utilisateur.apellidosUtilisateur;
      _cajaDocumento.text = Utilisateur.documentoUtilisateur;
      _cajaTipoDocumento.text = Utilisateur.tipoDocumentoUtilisateur;
      _cajaTelefono.text = Utilisateur.telefonoUtilisateur;
      _cajaNombreImagen.text=Utilisateur.fotoPublicaUtilisateur;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.topRight,
          child: Text(
            "Editar Perfil",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
        backgroundColor: const Color(0xFF002A3A),
      ),
      body: Center(
        child: FutureBuilder<Utilisateur>(
          future: objUsu,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Text('Error al cargar el perfil');
            } else if (snapshot.hasData) {
              return _edit(snapshot.data!);
            } else {
              return const Text('No hay datos disponibles');
            }
          },
        ),
      ),
    );
  }

  Widget _edit(Utilisateur Utilisateur) {
    return Scaffold(
      backgroundColor: const Color(0xFF002A3A),
      body: Stack(
        children: [
          Positioned(
            left: 10,
            right: 10,
            child: Container(
              width: 300,
              height: 560,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Form(
                key: _frmUtilisateur,
                child: Column(
                  children: [
                    Positioned(
                      top: 2, // Ajusta la posición vertical de la imagen
                      // Ajusta la posición horizontal de la imagen
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Botones de editar y agregar imagen
                          Container(
                            padding:
                                const EdgeInsets.only(left: 50, right: 20, top: 10),
                            child: Stack(children: [
                              SizedBox(
                                  height: 50,
                                  width: size,
                                  child: ClipRRect(
                                      child: Image.memory(
                                    const Base64Decoder()
                                        .convert(objImagen.base64Imagen),
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
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Nombre Utilisateur",
                        style: TextStyle(
                          fontSize: 10,
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
                          return "Ingrese el nombre del Utilisateur";
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
                    const SizedBox(height: 2),
                    Padding(
                      padding: const EdgeInsets.only(),
                      child: Column(
                        children: <Widget>[
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Apellido Utilisateur",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 6, 6, 6),
                              ),
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: _cajaApellido,
                            validator: (texto) {
                              if (texto!.isEmpty) {
                                return "Ingrese el apellido";
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
                    const SizedBox(height: 2),
                    Padding(
                      padding: const EdgeInsets.only(),
                      child: Column(
                        children: <Widget>[
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Documento Utilisateur ",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 6, 6, 6),
                              ),
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: _cajaDocumento,
                            validator: (texto) {
                              if (texto!.isEmpty) {
                                return "Ingrese el documento";
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
                       const SizedBox(height: 2),
                    Padding(
                      padding: const EdgeInsets.only(),
                      child: Column(
                        children: <Widget>[
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Tipo de Documento Utilisateur ",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 6, 6, 6),
                              ),
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: _cajaTipoDocumento,
                            validator: (texto) {
                              if (texto!.isEmpty) {
                                return "Ingrese el tipo de documento";
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
                    const SizedBox(height: 2),
                    Padding(
                      padding: const EdgeInsets.only(),
                      child: Column(
                        children: <Widget>[
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Telefono Utilisateur ",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 6, 6, 6),
                              ),
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: _cajaTelefono,
                            validator: (texto) {
                              if (texto!.isEmpty) {
                                return "Ingrese el telefono";
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
                    const SizedBox(height: 2),
                    Padding(
                      padding: const EdgeInsets.only(),
                      child: Column(
                        children: <Widget>[
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Imagen",
                              style: TextStyle(
                                fontSize: 10,
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
                                  size: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                filled: true,
                                fillColor: const Color.fromARGB(168, 220, 212, 212),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 25),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 1),
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
                          if (_frmUtilisateur.currentState!.validate()) {
                            objUtilisateur.nombresUtilisateur = _cajaNombre.text;
                            objUtilisateur.apellidosUtilisateur = _cajaApellido.text;
                            objUtilisateur.tipoDocumentoUtilisateur = _cajaTipoDocumento.text;
                            objUtilisateur.documentoUtilisateur = _cajaDocumento.text;
                            objUtilisateur.telefonoUtilisateur = _cajaTelefono.text;
                            objUtilisateur.fotoPublicaUtilisateur = _cajaNombreImagen.text;


                            if (await misServiciosPerfil.actualizarInfoPerfil(objUtilisateur,objImagen)) {
                              Navigator.pushNamed(context, '/profile');
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Error !'),
                                    content: Text(
                                      'Fallo al registrar el perfil ${objUtilisateur.nombresUtilisateur}',
                                    ),
                                  );
                                },
                              );
                                _limpiarCajas();
                            }

                            setState(() {
                              // Update state here
                            });
                          }
                        },
                        child: const Text('Actualizar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
    
  }
    void _limpiarCajas() {
    setState(() {
      _cajaNombre.text = "";
      _cajaApellido.text = "";
      _cajaDocumento.text = "";
      _cajaTipoDocumento.text = "";
      _cajaTelefono.text = "";
      _cajaNombreImagen.text = "";
      objImagen.base64Imagen = "";
    });
  }

  Future seleccionarImagen() async {
    // XFile? image = await imagePicker.pickImage(source: ImageSource.camera);
    var image = await imagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      Uint8List datosImagen = await image.readAsBytes();
      // ignore: unused_local_variable
      int id = idGenerator++;
      var imagenBase64 = base64Encode(datosImagen);
      _cajaNombreImagen.text = image.name;

      objImagen.base64Imagen = imagenBase64;
      objImagen.nombrePublicoImagen = image.name;
      objImagen.tipoImagen = image.mimeType!;
      objImagen.tamanoImagen =
          (await image.readAsBytes()).lengthInBytes.toString();

      // ignore: avoid_print
      print(objImagen.tamanoImagen);
      setState(() {});
    }
  }
}
 */