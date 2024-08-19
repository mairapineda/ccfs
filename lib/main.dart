import 'package:flutter/material.dart';
import 'package:ccfs/app/widgets/router/ruteo.dart';

void main() {
  runApp(const Pprincipal());


}

class Pprincipal extends StatelessWidget {
  const Pprincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: obtenerRutas(context),
      debugShowCheckedModeBanner: false,
    );
  }
}
