// ignore_for_file: file_names
import 'dart:ui';
import 'package:ccfs/app/widgets/contenido/bienvenida.dart';
import 'package:ccfs/app/widgets/contenido/corps.dart';
import 'package:ccfs/app/widgets/contenido/examenCorps.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class ExamenEtudiant extends StatefulWidget {
  const ExamenEtudiant({super.key});

  @override
  State<ExamenEtudiant> createState() => _BottomBarState();
}

class _BottomBarState extends State<ExamenEtudiant> {
  final PageController _controlPaginas = PageController();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controlPaginas,
        physics: const NeverScrollableScrollPhysics(),
        children: const [Bienvenida(), CorpsPage(), Corps()],
      ),
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                width: 310,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 0, 80, 74),
                ),
                child: SalomonBottomBar(
                  items: [
                    SalomonBottomBarItem(
                      icon: const Icon(Icons.home_rounded),
                      title: const Text(
                        "Bureau",
                        style: TextStyle(fontFamily: 'DidotRegular'),
                      ),
                      selectedColor: const Color.fromARGB(255, 206, 230, 214),
                    ),
                    SalomonBottomBarItem(
                      icon: const Icon(Icons.emoji_people_rounded),
                      title: const Text("Le Corps",
                          style: TextStyle(fontFamily: 'DidotRegular')),
                      selectedColor: const Color.fromARGB(255, 206, 230, 214),
                    ),
                    SalomonBottomBarItem(
                      icon: const Icon(Icons.import_contacts_rounded),
                      title: const Text("Examen",
                          style: TextStyle(fontFamily: 'DidotRegular')),
                      selectedColor: const Color.fromARGB(255, 206, 230, 214),
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  onTap: (index) {
                    setState(() {
                      _selectedIndex = index;
                      _controlPaginas.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.easeInOut,
                      );
                    });
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
