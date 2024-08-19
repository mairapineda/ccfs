
import 'package:ccfs/app/widgets/contenido/ExpressionsList.dart';
import 'package:ccfs/app/widgets/contenido/corps.dart';
import 'package:ccfs/app/widgets/contenido/corpsList.dart';
import 'package:ccfs/app/widgets/contenido/ejem.dart';
import 'package:ccfs/app/widgets/contenido/inicio.dart';
import 'package:ccfs/app/widgets/contenido/inicio2.dart';
import 'package:ccfs/app/widgets/contenido/register.dart';
import 'package:ccfs/app/widgets/contenido/sesion.dart';
import 'package:ccfs/app/widgets/contenido/sitioCrear.dart';
import 'package:ccfs/app/widgets/contenido/sitioListar.dart';
import 'package:ccfs/app/widgets/contenido/bottomBar.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext)> obtenerRutas(BuildContext context) {
  return {
    '/': (context) => const OnboardingPage1(),
    '/inicio': (context) => const Inicio(),
    '/login': (context) => const Sesion(),
    '/registre': (context) => const Registrar(),
     '/corpslist': (context) => const CorpsList(heroTag:0,),
     '/expressionsList': (context) => const ExpressionsList(),
     '/expressions': (context) => const ExpressionsPage(),
    /* '/welcome': (context) => const Bienvenida(), */
    /* '/map': (context) => const Mapa1(), */
 /*    '/profile': (context) => const ProfilePage(), */
    '/addSite': (context) => const SitioCrear(),
    '/listSite': (context) => const SitioListar(),
    /* '/list': (context) => const Listar(), */
    '/welcome': (context) => const BottomBar(),
    /* '/edit': (context) => const EditarPerfil(), */
    '/corps': (context) => const CorpsPage(),
  };
}
