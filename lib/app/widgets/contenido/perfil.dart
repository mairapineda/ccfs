

import 'package:ccfs/app/models/utilisateur.dart';
import 'package:ccfs/app/servicios/serviciosPerfil.dart';
import 'package:flutter/material.dart';


class Perfil extends StatefulWidget {
  final Utilisateur codUtils;
  const Perfil({super.key, required this.codUtils});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final ServiciosPerfil misServiciosPerfil = ServiciosPerfil();
  late Future<Utilisateur> objUtilisateur =
      Future(() => Utilisateur('', '', '', '','',''));

  @override
  void initState() {
    super.initState();
    objUtilisateur = misServiciosPerfil.obtenerInfoPerfil();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.topRight,
          child: Text(
            "Perfil Usuario",
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
          future: objUtilisateur,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Text('Error al cargar el perfil');
            } else if (snapshot.hasData) {
              return _buildUserProfile(snapshot.data!);
            } else {
              return const Text('No hay datos disponibles');
            }
          },
        ),
      ),
    );
  }

  Widget _buildUserProfile(Utilisateur utilisateur) {

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: 300, // Set the desired width
        height: 500, // Set the desired height
        child: Card(
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          color: const Color(0xFF002A3A), // Add color to the Card
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
             
              ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Nombre: ${utilisateur.nomUtils}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Apellido: ${utilisateur.prenomUtils}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Documento: ${utilisateur.dateUtils}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 255, 254, 254),
                  ),
                ),
                const SizedBox(height: 8),
                
                IconButton(
                  icon: const Icon(Icons.edit),
                   color: const Color.fromARGB(255, 255, 255, 255), 
                  onPressed: () {
                      Navigator.pushNamed(context, '/edit');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
