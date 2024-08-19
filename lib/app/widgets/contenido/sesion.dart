// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously
import 'package:ccfs/app/models/acceso.dart';
import 'package:ccfs/app/models/miSesion.dart';
import 'package:ccfs/app/servicios/servicioPublico.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Sesion extends StatefulWidget {
  const Sesion({super.key});

  @override
  State<Sesion> createState() => _SesionState();
}

class _SesionState extends State<Sesion> {
  final TextEditingController _cajaCorreo = TextEditingController();
  final TextEditingController _cajaClave = TextEditingController();

  final ServicioPublico misServicios = ServicioPublico();
  bool _passwordVisible = false;
  final _frmSesion = GlobalKey<FormState>();
  
  final Acces objAcces = inicializarAcces();
  final MiSesion objSesion = MiSesion("", "", "", "", "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 1000,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 0, 80, 74),
        ),
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Text(
                'Parler avec le corps',
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'MonstserratBold',
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 280,
                height: 210,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  shape: BoxShape.rectangle,
                  image: const DecorationImage(
                    image: AssetImage('images/base/FrameL.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: <Widget>[
                  const Text(
                    "Se connecter",
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'MonstserratBold',
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Form(
                    key: _frmSesion,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          "Adresse e-mail",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'MonstserratBold',
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 12,
                            fontFamily: 'MonstserratSemiBold',
                          ),
                          controller: _cajaCorreo,
                          validator: (textoCorreo) {
                            String patron =
                                r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$";
                            if (textoCorreo!.isEmpty) {
                              return "Entrer l'adresse e-mail";
                            }
                            if (!RegExp(patron).hasMatch(textoCorreo)) {}
                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  width: 1),
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Mot de passe",
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'MonstserratBold',
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              obscureText: !_passwordVisible,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 12,
                                fontFamily: 'MonstserratSemiBold',
                              ),
                              controller: _cajaClave,
                              validator: (textoClave) {
                                String patron =
                                    r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$";
                                if (textoClave!.isEmpty) {
                                  return "Entrer le mot de passe";
                                }
                                if (!RegExp(patron).hasMatch(textoClave)) {}
                                return null;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      width: 1),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _passwordVisible
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    size: 15,
                                    color: const Color(0xFFF67B70),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_frmSesion.currentState!.validate()) {
                                  objAcces.emailAcces = _cajaCorreo.text;
                                  objAcces.passeAcces = _cajaClave.text;

                                  if (await misServicios
                                      .iniciarSesion(objAcces)) {
                                    Navigator.pushNamed(context, '/welcome');
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const AlertDialog(
                                          title: Text("Error!"),
                                          content: Text(
                                            "Échec de l'authentification "
                                            "Vérifier les données d'identification",
                                          ),
                                        );
                                      },
                                    );
                                    _limpiarCajas();
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(500, 50),
                                backgroundColor: const Color(0xFFFFFFFF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: const Text(
                                "Se connecter",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'MonstserratSemiBold',
                                  color: Color.fromARGB(255, 0, 80, 74),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: "N'a pas de S’inscrire ?",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'MonstserratLight',
                                    color: Colors.white,
                                  ),
                                ),
                                WidgetSpan(
                                  child: GestureDetector(
                                    child: const Text(
                                      "  S’inscrire",
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontFamily: 'MonstserratBold',
                                        color: Color(0xFFF67B70),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.pushNamed(context, '/registre');
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: InkWell(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Se connecter Avec Google',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontFamily: 'MonstserratBold',
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Icon(
                                    FontAwesomeIcons.google,
                                    size: 10,
                                    color: Color(0xFFF67B70),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _limpiarCajas() {
    setState(() {
      _cajaCorreo.text = "";
      _cajaClave.text = "";
    });
  }
}

Acces inicializarAcces() {
  return Acces("", "");
}


