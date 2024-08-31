import 'dart:convert';
import 'dart:typed_data';
import 'package:ccfs/app/models/partieCorps.dart';
import 'package:ccfs/app/servicios/servicioCorps.dart';
import 'package:ccfs/app/utilities/globals.dart' as globals;
import 'package:ccfs/app/widgets/contenido/expresionxcorps.dart';

import 'package:flutter/material.dart';

class CorpsPage extends StatefulWidget {
  const CorpsPage({super.key});

  @override
  State<CorpsPage> createState() => _CorpsPageState();
}

class _CorpsPageState extends State<CorpsPage> {
  final CorpsService misServicios = CorpsService();
  late Future<List<PartieduCorps>> objPartieduCorps;
  List<PartieduCorps>? arrPartieduCorps = [];
  final List<String> _imagePaths = [
    'images/img/COP1.png',
    'images/img/COP2.png',
    'images/img/COP3.png',
    'images/img/COP4.png',
    'images/img/COP5.png',
    'images/img/COP6.png',
    'images/img/COP7.png',
  ];

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
              return CustomScrollView(
                slivers: [
                  SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 3,
                      mainAxisSpacing: 3,
                      childAspectRatio: 0.65,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        PartieduCorps objPartieduCorps =
                            arrPartieduCorps!.elementAt(index);
                        return Align(
                          alignment: Alignment.center,
                          child: _generarTarjeta(
                              context, objPartieduCorps, index, _imagePaths),
                        );
                      },
                      childCount: arrPartieduCorps!.length,
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                strokeWidth: 4.0,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _generarTarjeta(BuildContext context, PartieduCorps corps, int index,
      List<String> imagePaths) {
    var imagenCorps = const Base64Decoder().convert(corps.base64Corps);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ExpresionxCorps(codCorps: corps)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  width: 100,
                  height: 130,
                  margin: const EdgeInsets.only(top: 10.0),
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: AssetImage(imagePaths[index % imagePaths.length]),
                    ),
                  ),
                ),
                Container(
                  width: 90,
                  height: 90,
                  margin: const EdgeInsets.only(top: 10.0),
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: MemoryImage(imagenCorps),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 2),
                  child: Text(
                    corps.prenomCorps,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'DidotBold',
                      color: Color.fromARGB(255, 129, 111, 51),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
