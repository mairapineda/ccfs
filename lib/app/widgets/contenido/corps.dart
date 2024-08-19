import 'dart:convert';
import 'dart:typed_data';

import 'package:ccfs/app/models/partieCorps.dart';
import 'package:ccfs/app/servicios/servicioCorps.dart';
import 'package:ccfs/app/widgets/contenido/expressions%20copy.dart';
import 'package:ccfs/app/utilities/globals.dart' as globals;

import 'package:flutter/material.dart';

class CorpsPage extends StatefulWidget {
  const CorpsPage({super.key});

  @override
  State<CorpsPage> createState() => _CorpsPageState();
}

class _CorpsPageState extends State<CorpsPage> {
  final CorpsService misServicios = CorpsService();
  late Future<List<PartieduCorps>> objPartieduCorps = Future(() => []);
  List<PartieduCorps>? arrPartieduCorps = [];

  @override
  void initState() {
    super.initState();
    objPartieduCorps = misServicios.obtenerCorps();
  }

  @override
  Widget build(BuildContext context) {
    final Uint8List bytes =
        const Base64Decoder().convert(globals.base64Usuario);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 15),
              child: SizedBox(
                width: 35,
                height: 35,
                child: Image.asset(
                  'images/base/palc.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const Text(
              "Le Corps",
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'DidotBold',
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 15),
              child: SizedBox(
                width: 55,
                height: 55,
                child: IconButton(
                  icon: CircleAvatar(
                    backgroundImage: MemoryImage(bytes),
                    radius: 15,
                  ),
                  tooltip: globals.objSesion.emailAcces,
                  onPressed: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 0, 80, 74),
      ),
      body: Container(
        color: const Color.fromARGB(255, 255, 255, 255),
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<List<PartieduCorps>>(
          future: objPartieduCorps,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              arrPartieduCorps = snapshot.data;
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      childAspectRatio: 1,
                    ),
                    itemCount: arrPartieduCorps!.length,
                    itemBuilder: (context, index) {
                      PartieduCorps objPartieduCorps =
                          arrPartieduCorps!.elementAt(index);
                      return Align(
                        alignment: Alignment.center,
                        child: _generarTarjeta(context, objPartieduCorps),
                      );
                    },
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
              strokeWidth: 4.0,
            );
          },
        ),
      ),
    );
  }
}

Widget _generarTarjeta(BuildContext context, PartieduCorps corps) {
  var imagenCorps = const Base64Decoder().convert(corps.base64Corps);
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExpresionxCorps(codCorps: corps),
        ),
      );
    },
    child: Container(
      width: 120,
      height: 120,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 206, 230, 214),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 0, 80, 74).withOpacity(0.5),
            offset: const Offset(3, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.memory(
                  imagenCorps,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                corps.prenomCorps,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'DidotBold',
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
