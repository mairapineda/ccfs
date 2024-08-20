// ignore_for_file: file_names, use_build_context_synchronously
import 'package:ccfs/app/models/institution.dart';
import 'package:ccfs/app/models/miSesion.dart';
import 'package:ccfs/app/models/registre.dart';
import 'package:ccfs/app/servicios/servicioInstitution.dart';
import 'package:ccfs/app/servicios/servicioPublico.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ccfs/app/models/roles.dart';

class Registrer extends StatefulWidget {
  final LesRoles? selectedRole;
  const Registrer({Key? key, this.selectedRole}) : super(key: key);

  @override
  State<Registrer> createState() => _RegistreState();
}

class _RegistreState extends State<Registrer> {
  final TextEditingController _cajaCorreo = TextEditingController();
  final TextEditingController _cajaClave = TextEditingController();
  final TextEditingController _cajaReClave = TextEditingController();
  final TextEditingController _cajaNom = TextEditingController();
  final TextEditingController _cajaFecha = TextEditingController();
  final TextEditingController _cajaPrenom = TextEditingController();

  final ServicioPublico misServicios = ServicioPublico();
  final InstitucionService misServicio = InstitucionService();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  Future<List<Institution>> objInstitution = Future(() => []);
  List<Institution> instituciones = [];
  Institution? _selectedInstitution;

  final _frmSesion = GlobalKey<FormState>();
  final Registre objRegistre = inicializarRegistre();
  final MiSesion objSesion = MiSesion("", "", "", "", "", "", "");

  @override
  void initState() {
    super.initState();
    objInstitution = misServicio.obtenerInstitution();
    objInstitution.then((value) {
      setState(() {
        instituciones = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: 1200,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 0, 80, 74),
          ),
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 80),
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
                  width: 340,
                  height: 240,
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
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    width: 1),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              focusedBorder: OutlineInputBorder(
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
                                validator: (texto) {
                                  if (texto!.isEmpty) {
                                    return "Entrer le Nom";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        width: 1),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  focusedBorder: OutlineInputBorder(
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
                                validator: (texto) {
                                  if (texto!.isEmpty) {
                                    return "Entrer le Prenom";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        width: 1),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  focusedBorder: OutlineInputBorder(
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
                                  validator: (texto) {
                                    if (texto!.isEmpty) {
                                      return "Entrer le Date de naissance";
                                    }
                                    return null;
                                  },
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
                                                  255, 206, 230, 214),
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
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          width: 1),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    focusedBorder: OutlineInputBorder(
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
                          const SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Intitution",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'MonstserratBold',
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                              const SizedBox(height: 10),
                              DropdownButtonFormField<Institution>(
                                dropdownColor:
                                    const Color.fromARGB(255, 206, 230, 214),
                                iconEnabledColor: const Color(0xFFF67B70),
                                value: _selectedInstitution,
                                items: instituciones
                                    .map((Institution instituciones) {
                                  return DropdownMenuItem<Institution>(
                                    value: instituciones,
                                    child: Text(
                                      instituciones.prenomInstitution,
                                      style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        fontSize: 12,
                                        fontFamily: 'MonstserratSemiBold',
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (Institution? newValue) {
                                  setState(() {
                                    _selectedInstitution = newValue!;
                                  });
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        width: 1),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        width: 1),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null) {
                                    return "Sélectionner une Istitution";
                                  }
                                  return null;
                                },
                              ),
                            ],
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
                                  /*  labelText: 'Password',
                                  hintText: 'Enter your password', */
                                  border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        width: 1),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
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
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        width: 1),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        width: 1),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _confirmPasswordVisible
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
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
                                      objRegistre.passeAcces = _cajaClave.text;
                                      if (_selectedInstitution != null) {
                                        objRegistre.codInstitution =
                                            _selectedInstitution!
                                                .codInstitution;
                                      } else {
                                        ("la Institution no está seleccionado");
                                        return;
                                      }
                                      if (widget.selectedRole != null) {
                                        objRegistre.codRoles =
                                            widget.selectedRole!.codRoles;
                                      } else {
                                        ("El rol no está seleccionado");
                                        return;
                                      }
                                      if (await misServicios
                                          .registrarUsuario(objRegistre)) {
                                        if (widget.selectedRole!.prenomRoles ==
                                            'Etudiant') {
                                          // Habilitar examen
                                          Navigator.pushNamed(
                                              context, '/examen');
                                        } else if (widget
                                                .selectedRole!.prenomRoles ==
                                            'Enseignant') {
                                          // Habilitar secuencia
                                          Navigator.pushNamed(
                                              context, '/sequence');
                                        }
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const AlertDialog(
                                              backgroundColor: Color.fromARGB(
                                                  255, 206, 230, 214),
                                              title: Text(
                                                "Erreur!",
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 80, 74),
                                                  fontSize: 24,
                                                  fontFamily: 'DidotRegular',
                                                ),
                                              ),
                                              content: Text(
                                                "Échec de l'authentification\nVérifier les données d'identification",
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 18,
                                                  fontFamily: 'DidotRegular',
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                        _limpiarCajas();
                                      }
                                    }
                                  } catch (e) {
                                    (e);
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
      _cajaReClave.text = "";
    });
  }
}

Registre inicializarRegistre() {
  return Registre("", "", "", "", "", "", "", "");
}
