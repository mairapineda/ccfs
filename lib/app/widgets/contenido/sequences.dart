import 'dart:convert';
import 'package:ccfs/app/models/partieCorps.dart';
import 'package:ccfs/app/models/sequence.dart';
import 'package:ccfs/app/servicios/servicioSequence.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';

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
  bool _isLoading = false;
  bool _isDownloaded = false;

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
              Navigator.pop(context);
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

  Future<void> _downloadFile(String base64Data, String fileName) async {
    try {
      if (Platform.isAndroid) {
        print('Solicitando permisos de almacenamiento en Android...');
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
        }
        if (!status.isGranted) {
          print('Permiso de almacenamiento denegado');
          return;
        }
        print('Permiso concedido.');
      }

      var bytes;
      try {
        bytes = const Base64Decoder().convert(base64Data);
        print('Base64 convertido a bytes.');
      } catch (e) {
        print('Error al convertir base64: $e');
        return;
      }

      Directory? dir;
      if (Platform.isAndroid) {
        dir = Directory('/storage/emulated/0/Download');
      } else if (Platform.isIOS) {
        dir = await getApplicationDocumentsDirectory();
      }

      String filePath = '${dir?.path}/$fileName';
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Guardando Documento')),
      );

      File file = File(filePath);
      await file.writeAsBytes(bytes);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Archivo guardado en la carpeta de descargas')),
      );
      setState(() {
        _isDownloaded = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al descargar el documento $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: _isDownloaded
                          ? const Icon(Icons.download_done_rounded,
                              color: Color.fromARGB(255, 0, 80, 74))
                          : const Icon(Icons.download_rounded,
                              color: Color.fromARGB(255, 0, 80, 74)),
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        await _downloadFile(objSequence.base64Sequence,
                            '${objSequence.prenomSequence}.pdf');
                      },
                    ),
                    if (_isLoading)
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Color.fromARGB(255, 0, 80, 74)),
                      ),
                  ],
                )
              ],
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
