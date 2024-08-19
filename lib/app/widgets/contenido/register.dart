// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously, avoid_print
import 'package:ccfs/app/models/miSesion.dart';
import 'package:ccfs/app/models/registre.dart';
import 'package:ccfs/app/servicios/servicioPublico.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class Registrar extends StatefulWidget {
  const Registrar({super.key});

  @override
  State<Registrar> createState() => _RegistreState();
}

class _RegistreState extends State<Registrar> {
  final TextEditingController _cajaCorreo = TextEditingController();
  final TextEditingController _cajaClave = TextEditingController();
  final TextEditingController _cajaReClave = TextEditingController();
  final TextEditingController _cajaNom = TextEditingController();
  final TextEditingController _cajaFecha = TextEditingController();
  final TextEditingController _cajaPrenom = TextEditingController();

  final ServicioPublico misServicios = ServicioPublico();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible =false;
  final _frmSesion = GlobalKey<FormState>();

  final Registre objRegistre = inicializarRegistre();
  final MiSesion objSesion = MiSesion("", "", "", "", "");
  

/*   Widget OpcionesDocente(){
    return Column( children: [Text('bien')],);
  } */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
                child: Container(
                  width: 280,
                  height: 210,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    shape: BoxShape.rectangle,
                    image: const DecorationImage(
                      image: AssetImage('images/base/FrameR.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              /*   if()
                OpcionesDocente(), */
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: <Widget>[
                    const Text(
                      "S’inscrire",
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'MonstserratBold',
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    const SizedBox(height: 20),
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
                          const SizedBox(height: 8),
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
                                borderSide:
                                    const BorderSide(color: Colors.white),
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
                                "Nom",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'MonstserratBold',
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 12,
                                  fontFamily: 'MonstserratSemiBold',
                                ),
                                controller: _cajaNom,
                                validator: (textoClave) {
                                  String patron =
                                      r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$";
                                  if (textoClave!.isEmpty) {
                                    return "Entrer le Nom";
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
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        width: 1),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Prenom",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'MonstserratBold',
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 12,
                                  fontFamily: 'MonstserratSemiBold',
                                ),
                                controller: _cajaPrenom,
                                validator: (textoClave) {
                                  String patron =
                                      r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$";
                                  if (textoClave!.isEmpty) {
                                    return "Entrer le Prenom";
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
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        width: 1),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(),
                            child: Column(
                              children: <Widget>[
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Date de naissance",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'MonstserratBold',
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: _cajaFecha,
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 12,
                                    fontFamily: 'MonstserratSemiBold',
                                  ),
                                  onTap: () async {
                                    DateTime? fechaSeleccionada =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1200),
                                      lastDate: DateTime(2100),
                                      builder: (BuildContext context,
                                          Widget? child) {
                                        return Theme(
                                          data: ThemeData.light().copyWith(
                                            colorScheme:
                                                const ColorScheme.light(
                                              primary: Color.fromARGB(
                                                  255, 0, 80, 74),
                                              onPrimary: Color.fromARGB(
                                                  255, 206, 230, 214),
                                              surface: Color.fromARGB(
                                                  255, 39, 176, 76),
                                              onSurface: Color.fromARGB(
                                                  255, 0, 80, 74),
                                            ),
                                            dialogBackgroundColor: Colors.white,
                                            dialogTheme: const DialogTheme(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30)),
                                                side: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    width: 1),
                                              ),
                                            ),
                                            textTheme: const TextTheme(
                                              headlineMedium: TextStyle(
                                                fontFamily:
                                                    'MonstserratSemiBold',
                                                fontSize: 20,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                              ),
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
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
                                      borderSide:
                                          const BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          width: 1),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          /* const SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Âge",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'MonstserratBold',
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 12,
                                  fontFamily: 'MonstserratSemiBold',
                                ),
                                controller: _cajaAge,
                                validator: (textoEdad) {
                                  if (textoEdad!.isEmpty) {
                                    return "Entrer l'âge";
                                  }
                                  if (int.tryParse(textoEdad) == null) {
                                    return "L'âge doit être un nombre entier";
                                  }
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
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        width: 1),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                              ),
                            ],
                          ),
                           */
                          
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
                                  /*  labelText: 'Password',
                                  hintText: 'Enter your password', */
                                  border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        width: 1),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _passwordVisible
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Confirmer le mot de passe",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'MonstserratBold',
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                obscureText: !_confirmPasswordVisible,
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 12,
                                  fontFamily: 'MonstserratSemiBold',
                                ),
                                controller: _cajaReClave,
                                validator: (textoConfirmarClave) {
                                  if (textoConfirmarClave!.isEmpty) {
                                    return "Veuillez entrer à nouveau le mot de passe";
                                  }
                                  if (textoConfirmarClave != _cajaClave.text) {
                                    return "Les mots de passe ne correspondent pas";
                                  }
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
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        width: 1),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _confirmPasswordVisible
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      size: 15,
                                      color: const Color(0xFFF67B70),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _confirmPasswordVisible =
                                            !_confirmPasswordVisible;
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
                                  try {
                                    if (_frmSesion.currentState!.validate()) {
                                      objRegistre.emailAcces = _cajaCorreo.text;
                                      objRegistre.nomUtils = _cajaNom.text;
                                      objRegistre.prenomUtils =
                                          _cajaPrenom.text;
                                      objRegistre.dateUtils = _cajaFecha.text;
                                      /*  int? age = int.parse(_cajaAge.text);
                                      objRegistre.ageUtils = age; */
                                      objRegistre.passeAcces = _cajaClave.text;

                                      if (await misServicios
                                          .registrarUsuario(objRegistre)) {
                                        Navigator.pushNamed(
                                            context, '/welcome');
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const AlertDialog(
                                              title: Text("Error!"),
                                              content: Text(
                                                "Échec de l'authentification"
                                                "Vérifier les données d'identification",
                                              ),
                                            );
                                          },
                                        );
                                        _limpiarCajas();
                                      }
                                    }
                                  } catch (e) {
                                    print(e);
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
                                  "S’inscrire",
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
                                    text: "N'a pas de e connecter?",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontFamily: 'MonstserratLight',
                                      color: Colors.white,
                                    ),
                                  ),
                                  WidgetSpan(
                                    child: GestureDetector(
                                      child: const Text(
                                        "  Se connecter",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontFamily: 'MonstserratBold',
                                          color: Color(0xFFF67B70),
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.pushNamed(context, '/login');
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
      ),
    );
  }

  void _limpiarCajas() {
    setState(() {
      _cajaCorreo.text = "";
      _cajaClave.text = "";
      _cajaFecha.text = "";
      _cajaNom.text = "";
      _cajaPrenom.text = "";
    });
  }
}

Registre inicializarRegistre() {
  return Registre("", "", "", "", "","");
}
