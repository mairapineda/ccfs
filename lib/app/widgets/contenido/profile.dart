import 'package:ccfs/app/models/utilisateur.dart';
import 'package:ccfs/app/servicios/serviciosPerfil.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:ccfs/app/utilities/globals.dart' as globals;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ServiciosPerfil misServiciosPerfil = ServiciosPerfil();
  late Future<Utilisateur> objUtilisateur =
      Future(() => Utilisateur('', '', '', '', '', ''));

  @override
  void initState() {
    super.initState();
    objUtilisateur = misServiciosPerfil.obtenerInfoPerfil();
  }

  @override
  Widget build(BuildContext context) {
    final Uint8List bytes =
        const Base64Decoder().convert(globals.base64Usuario);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 80, 74),
        elevation: 0,
        centerTitle: true,
        title: const Text('Mon profil',
            style: TextStyle(
              fontFamily: 'DidotBold',
              fontWeight: FontWeight.w400,
              fontSize: 20,
              color: Color.fromARGB(255, 255, 255, 255),
            )),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 0, 80, 74),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100))),
            child: const Text(
              'Éditer',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontFamily: 'DidotBold',
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      body: FutureBuilder<Utilisateur>(
        future: objUtilisateur,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final utilisateur = snapshot.data!;
            final DateFormat formatter = DateFormat('yyyy-MM-dd');
            final String formattedDate =
                formatter.format(DateTime.parse(utilisateur.dateUtils));
            return ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                Container(
                  color: const Color.fromARGB(255, 0, 80, 74),
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: GestureDetector(
                      onTap: () {
                        if (kDebugMode) {
                          print('Code to open file manager');
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Tooltip(
                            message: globals.objSesion.emailAcces,
                            child: Container(
                              width: 130,
                              height: 130,
                              margin: const EdgeInsets.only(bottom: 15),
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: CircleAvatar(
                                backgroundImage: MemoryImage(bytes),
                                radius: 65,
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
                const SizedBox(height: 16),
                Text(
                  "Nom: ${utilisateur.nomUtils}",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Prenom: ${utilisateur.prenomUtils}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Date: $formattedDate',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
