// ignore_for_file: file_names

import 'dart:convert';

import 'package:ccfs/app/models/expressionFigges.dart';
import 'package:ccfs/app/servicios/servicioFigges.dart';
import 'package:ccfs/app/widgets/contenido/expressionDetalle.dart';
import 'package:flutter/material.dart';

class ExpresionListar extends StatefulWidget {
  const ExpresionListar({super.key});

  @override
  State<ExpresionListar> createState() => _ExpresionListarState();
}

class _ExpresionListarState extends State<ExpresionListar> {
  final FiggesService misServicios = FiggesService();
  Future<List<Expression>> objExpression = Future(() => []);
  List<Expression>? arrExpression = [];
  @override
  void initState() {
    super.initState();
    objExpression = misServicios.obtenerFigges();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
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
              "Expressions Figees",
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
        child: FutureBuilder<List<Expression>>(
            future: objExpression,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                arrExpression = snapshot.data;
                return ListView(
                  children: List.generate(arrExpression!.length, (index) {
                    Expression objfigees = arrExpression!.elementAt(index);
                    return _generarCard(context, objfigees);
                  }),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            }),
      ),
    );
  }
}

Widget _generarCard(BuildContext context, Expression objfigees) {
  var imagenFigees = const Base64Decoder().convert(objfigees.base64Figees);
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FigeesDetalles(objfigees: objfigees),
        ),
      );
    },
    child: Container(
      height: 80,
      width: 120,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(172, 218, 218, 218),
        /*  border: Border.all(
                    color: Color.fromARGB(255, 0, 0, 0),
                  ), */
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                objfigees.prenomFigees,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 0, 80, 74),
                  fontFamily: 'DidotBold',
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                "${objfigees.originFigees} · ${objfigees.definitionFigees}",
                style: const TextStyle(
                  fontSize: 11,
                  color: Color.fromARGB(255, 0, 80, 74),
                  fontFamily: 'DidotRegular',
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [].map((e) {
                  return InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(e, size: 16),
                    ),
                  );
                }).toList(),
              )
            ],
          )),
          Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 80, 74),
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: MemoryImage(imagenFigees),
                  )
              )
          ),
        ],
      ),
    ),
  );
}
