import 'dart:convert';
import 'package:ccfs/app/models/partieCorps.dart';
import 'package:ccfs/app/models/sequence.dart';
import 'package:ccfs/app/servicios/servicioSequence.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class SequencexCorps extends StatefulWidget {
  final PartieduCorps codCorps;

  const SequencexCorps({super.key, required this.codCorps});

  @override
  State<SequencexCorps> createState() => _SequencexCorpsState();
}

class _SequencexCorpsState extends State<SequencexCorps> {
  final SequenceService misServicios = SequenceService();
  Future<List<Sequence>> objSequence = Future(() => []);
  List<Sequence>? arrSequence = [];

  @override
  void initState() {
    super.initState();
    objSequence = misServicios.obtenerSequenceCorps(widget.codCorps.codCorps);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/welcome');
            },
          ),
          title: const Align(
            alignment: Alignment.topRight,
            child: Text(
              "Sequences",
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
        child: FutureBuilder<List<Sequence>>(
            future: objSequence,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                arrSequence = snapshot.data;
                return ListView(
                  children: List.generate(arrSequence!.length, (index) {
                    Sequence objSequence = arrSequence!.elementAt(index);
                    return _generarCard(context, objSequence);
                  }),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            }),
      ),
    );
  }

  Widget _generarCard(BuildContext context, Sequence objSequence) {
    var documentoSequence =
        const Base64Decoder().convert(objSequence.base64Sequence);
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
        height: 700,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(255, 129, 111, 51),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(
              objSequence.prenomSequence,
              style: const TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 0, 80, 74),
                fontFamily: 'DidotBold',
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Expanded(
              child: SfPdfViewer.memory(
                documentoSequence,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
