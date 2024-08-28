import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:ccfs/app/utilities/globals.dart' as globals;
import 'package:carousel_slider/carousel_slider.dart';

class Bienvenida extends StatefulWidget {
  const Bienvenida({super.key});

  @override
  State<Bienvenida> createState() => _BienvenidaState();
}

class _BienvenidaState extends State<Bienvenida> {
  final List<String> imgList = [
    'https://i.ibb.co/c2mfrT1/Im.png',
    'https://i.ibb.co/zG7ygxL/Im1.png',
    'https://i.ibb.co/qRLRbWB/Im4.png'
  ];
  List<String> nombres = [
    'Des outils transformés',
    'Rapprocher les cultures',
    'Bibliothèque linguistique',
  ];
  @override
  Widget build(BuildContext context) {
    final Uint8List bytes =
        const Base64Decoder().convert(globals.base64Usuario);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            stretch: true,
            automaticallyImplyLeading: false,
            backgroundColor: const Color.fromARGB(255, 0, 80, 74),
            actions: <Widget>[
              Expanded(
                child: Row(
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
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              collapseMode: CollapseMode.parallax,
              title: const Text(
                'Parler avec le corps',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'DidotBold',
                  color: Color.fromARGB(255, 255, 255, 255),
                  shadows: [
                    Shadow(
                      offset: Offset(-1.5, -1.5),
                      color: Color.fromARGB(255, 0, 80, 74),
                    ),
                    Shadow(
                      offset: Offset(1.5, -1.5),
                      color: Color.fromARGB(255, 0, 80, 74),
                    ),
                  ],
                ),
              ),
              background: Image.network(
                "https://i.ibb.co/7gHyN2T/Im2.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 12, right: 15.0, bottom: 20.0, left: 15.0),
              child: Text(
                "Ce travail de recherche est ancré dans l’actualité scientifique et offre une ouverture des perspectives alliant la linguistique, la didactique et l’ingénierie des langues. Cette convergence permettra de mettre à profit les compétences numériques, linguistiques et didactiques. Ce travail se veut un facilitateur du processus d'apprentissage, aidant les apprenants à interpréter la langue à l’oral et à prendre conscience de la meilleure façon d’exploiter, d’analyser et de corriger leurs erreurs à partir de leurs propres productions orales. Ce travail adopte une attitude descriptive vis-à-vis de la langue, plutôt que normative, puisque le corpus oral fournit des échantillons de langue dans des contextes authentiques et permet de distinguer la distance entre la norme et l'usage. Ce qui fait encore défaut même aux apprenants les plus avancés, de niveau C1/C2 lors de l’utilisation des expressions figées.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: 'DidotRegular',
                  fontSize: 15,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height:300,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: NetworkImage(
                      'https://i.ibb.co/FHCpQ22/Captura-de-pantalla-2024-05-16-113037.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 2.0,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  pauseAutoPlayOnTouch: true,
                  viewportFraction: 0.7,
                  onPageChanged: (index, reason) {},
                ),
                items: imgList.asMap().entries.map((entry) {
                  int index = entry.key;
                  String item = entry.value;
                  return Container(
                    margin: const EdgeInsets.all(15),
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      child: Stack(
                        children: <Widget>[
                          Image.network(item, fit: BoxFit.cover, width: 1000),
                          Positioned(
                            bottom: 0.0,
                            left: 0.0,
                            right: 0.0,
                            child: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 206, 230, 214),
                                    Color.fromARGB(0, 206, 230, 214)
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              child: Text(
                                nombres[index],
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 0, 80, 74),
                                  fontSize: 20,
                                  fontFamily: 'DidotBold',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 12, right: 15.0, bottom: 80.0, left: 15.0),
              child: Text(
                "La linguistique de corpus oraux appliquée à l'enseignement des langues étrangères est une ligne de recherche relativement récente dont l'application dans la classe ne reçoit toujours pas l'attention qu'elle mérite, en partie pour des raisons pratiques, mais aussi pour le changement d'attitude que cette approche implique, tant chez l'enseignant que chez l'apprenant.  D'un côté, les programmes de consultation des corpus requièrent une expertise approfondie en linguistique outillée et numérique. Par ailleurs, les enseignants restent sceptiques, en grande partie en raison du manque de formation technique et didactique sur les usages possibles de ces outils et sur leur efficacité dans le processus d'enseignement.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: 'DidotRegular',
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
