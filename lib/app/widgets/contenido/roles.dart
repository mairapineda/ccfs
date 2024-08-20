import 'dart:convert';

import 'package:ccfs/app/models/roles.dart';
import 'package:ccfs/app/servicios/servicioRoles.dart';
import 'package:ccfs/app/widgets/contenido/register.dart';
import 'package:flutter/material.dart';

class RolesPage extends StatefulWidget {
  const RolesPage({super.key});

  @override
  _RolesPageState createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {
  final RolesService misServicio = RolesService();
  late Future<List<LesRoles>> objLesRoles;
  List<LesRoles> roles = [];
  LesRoles? selectedRole;

  @override
  void initState() {
    super.initState();
    objLesRoles = misServicio.obtenerRoles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
                    FutureBuilder<List<LesRoles>>(
                      future: objLesRoles,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('No hay roles disponibles'));
                        } else {
                          roles = snapshot.data!;
                          return Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: roles.length,
                                itemBuilder: (context, index) {
                                  LesRoles role = roles[index];
                                  return Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: _generarTarjeta(context, role),
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: selectedRole == null
                                    ? null
                                    : () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Registrer(
                                                selectedRole: selectedRole),
                                          ),
                                        );
                                      },
                                style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(300, 50),
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
                                  "Continuer",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'MonstserratSemiBold',
                                    color: Color.fromARGB(255, 0, 80, 74),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _generarTarjeta(BuildContext context, LesRoles role) {
    var imagenRoles = const Base64Decoder().convert(role.base64Roles);
    bool isSelected = role == selectedRole;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = role;
        });
      },
      child: Container(
        width: 300,
        height: 120,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected
                ? const Color.fromARGB(255, 255, 255, 255)
                : const Color.fromARGB(255, 255, 255, 255),
            width: isSelected ? 3 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  role.prenomRoles,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'DidotBold',
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.memory(
                  imagenRoles,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
