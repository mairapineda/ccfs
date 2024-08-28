import 'package:flutter/material.dart';

class SubrayadoTexto extends StatefulWidget {
  final String enunciado;
  const SubrayadoTexto({super.key, required this.enunciado});

  @override
  _SubrayadoTextoState createState() => _SubrayadoTextoState();
}

class _SubrayadoTextoState extends State<SubrayadoTexto> {
 

  String textoSeleccionado = "";
  List<String> textosSubrayados = [];
  List<Color> coloresSubrayados = [];

  final List<Color> coloresDisponibles = [
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.pink,
    Colors.orange,
    Colors.purple,
  ];

  Color _obtenerColor() {
    return coloresDisponibles[(textosSubrayados.length) % coloresDisponibles.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Subrayar Texto")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 20.0),
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SelectableText.rich(
                TextSpan(
                  children: _buildTextSpans(),
                ),
                textAlign: TextAlign.justify,
                onSelectionChanged: (selection, cause) {
                  setState(() {
                    textoSeleccionado = selection.textInside(widget.enunciado);
                    print("Texto seleccionado: $textoSeleccionado");
                  });
                },
              ),
            ),
            if (textoSeleccionado.isNotEmpty)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (textoSeleccionado.isNotEmpty) {
                      textosSubrayados.add(textoSeleccionado);
                      coloresSubrayados.add(_obtenerColor());
                      textoSeleccionado = "";
                      print("Textos subrayados: $textosSubrayados");
                      print("Colores subrayados: $coloresSubrayados");
                    }
                  });
                },
                child: const Text("Aceptar texto seleccionado"),
              ),
          ],
        ),
      ),
    );
  }

  List<TextSpan> _buildTextSpans() {
    List<TextSpan> spans = [];
    int start = 0;

    for (int i = 0; i < textosSubrayados.length; i++) {
      String subrayado = textosSubrayados[i];
      int index = widget.enunciado.indexOf(subrayado, start);
      if (index >= 0) {
        if (index > start) {
          spans.add(TextSpan(
            text: widget.enunciado.substring(start, index),
            style: const TextStyle(color: Colors.black),
          ));
        }
        spans.add(TextSpan(
          text: subrayado,
          style: TextStyle(color: coloresSubrayados[i]),
        ));
        start = index + subrayado.length;
      }
    }

    if (start < widget.enunciado.length) {
      spans.add(TextSpan(
        text: widget.enunciado.substring(start),
        style: const TextStyle(color: Colors.black),
      ));
    }

    return spans;
  }
}
