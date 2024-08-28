import 'dart:convert';
import 'package:ccfs/app/models/partieCorps.dart';
import 'package:ccfs/app/servicios/servicioCorps.dart';
import 'package:ccfs/app/widgets/contenido/examen.dart';
import 'package:flutter/material.dart';

class Corps extends StatefulWidget {
  const Corps({super.key});

  @override
  State<Corps> createState() => _ExpresionxCorpsState();
}

class _ExpresionxCorpsState extends State<Corps> {
  final CorpsService misServicios = CorpsService();
  late Future<List<PartieduCorps>> objPartieduCorps = Future(() => []);
  List<PartieduCorps> arrPartieduCorps = [];
  final List<String> _imagePaths = [
    'images/img/Corps.png',
    'images/img/Corps1.png',
    'images/img/corps2.png',
    'images/img/corps3.png',
    'images/img/corps4.png',
    'images/img/corps5.png',
    'images/img/corps6.png',
  ];

  @override
  void initState() {
    super.initState();
    objPartieduCorps = misServicios.obtenerCorps();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Align(
            alignment: Alignment.topRight,
            child: Text(
              "L'examens du corps",
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'DidotBold',
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 0, 80, 74)),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<List<PartieduCorps>>(
          future: objPartieduCorps,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              arrPartieduCorps = snapshot.data!;
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: List.generate(arrPartieduCorps.length, (index) {
                        PartieduCorps objPartieduCorps =
                            arrPartieduCorps[index];
                        return _generarCard(context, objPartieduCorps, index);
                      }),
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Widget _generarCard(BuildContext context, PartieduCorps corps, int index) {
    var imagenCorps = const Base64Decoder().convert(corps.base64Corps);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExamenxCorps(codCorps: corps),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(255, 0, 0, 0),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Center(
                  child: Container(
                    width: 150,
                    height: 150,
                    margin: const EdgeInsets.only(top: 10.0),
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image:
                            AssetImage(_imagePaths[index % _imagePaths.length]),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 150,
                    height: 100,
                    margin: const EdgeInsets.only(top: 10.0),
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: MemoryImage(imagenCorps),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 40),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  corps.prenomCorps,
                  style: const TextStyle(
                    fontSize: 30,
                    color: Color.fromARGB(255, 0, 80, 74),
                    fontFamily: 'DidotBold',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(width: 50, height: 4),
                const Text(
                  'Examen',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 0, 80, 74),
                    fontFamily: 'DidotRegular',
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
