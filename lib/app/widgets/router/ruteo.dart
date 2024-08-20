import 'package:ccfs/app/widgets/contenido/ExpressionsList.dart';
import 'package:ccfs/app/widgets/contenido/corps.dart';
import 'package:ccfs/app/widgets/contenido/ejem.dart';
import 'package:ccfs/app/widgets/contenido/examenEtudiant.dart';
import 'package:ccfs/app/widgets/contenido/inicio.dart';
import 'package:ccfs/app/widgets/contenido/inicio2.dart';
import 'package:ccfs/app/widgets/contenido/profile.dart';
import 'package:ccfs/app/widgets/contenido/register.dart';
import 'package:ccfs/app/widgets/contenido/roles.dart';
import 'package:ccfs/app/widgets/contenido/sequenceEnseignant.dart';
import 'package:ccfs/app/widgets/contenido/sesion.dart';
import 'package:ccfs/app/widgets/contenido/bottomBar.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext)> obtenerRutas(BuildContext context) {
  return {
    '/': (context) => const OnboardingPage1(),
    '/inicio': (context) => const Inicio(),
    '/login': (context) => const Sesion(),
    '/registre': (context) => const Registrer(),
    '/expressionsList': (context) => const ExpressionsList(),
    '/expressions': (context) => const ExpressionsPage(),
    '/welcome': (context) => const BottomBar(),
    '/corps': (context) => const CorpsPage(),
    '/roles': (context) => const RolesPage(),
    '/profile': (context) => const ProfilePage(),
    '/sequence': (context) => const SequenceEnseignant(),
    '/examen': (context) => const ExamenEtudiant(),

  };
}
