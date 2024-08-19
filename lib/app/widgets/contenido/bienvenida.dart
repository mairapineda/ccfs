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
                '¿Qué es Flutter? Flutter permite a los desarrolladores crear aplicaciones hermosas compiladas de manera nativa a partir de una única base de código tanto para Android como para iOS. Flutter es actualmente uno de los frameworks más populares para el desarrollo de aplicaciones móviles multiplataforma. Además de ser una plataforma de primer nivel para Material Design, los desarrolladores lo consideran una gran alternativa a los frameworks multiplataforma populares como React Native, Ionic, etc. Los widgets de Flutter sustraen todas las diferencias críticas de la plataforma, como el desplazamiento, la navegación, los íconos y las fuentes para ofrecer un desempeño nativo completo tanto en iOS como en Android. En CodeCanyon, encontrarás todas las herramientas que necesitas para empezar a crear tu aplicación con Flutter. Con las plantillas de Flutter, toda la codificación se ha hecho con anticipación, tú solo tienes que concentrarte en hacer que tu aplicación sea única.',
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
                items: imgList
                    .map((item) => Container(
                          margin: const EdgeInsets.all(15),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                            child: Stack(
                              children: <Widget>[
                                Image.network(item,
                                    fit: BoxFit.cover, width: 1000),
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
                                    child: const Text(
                                      'Parler avec le corps',
                                      style: TextStyle(
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
                        ))
                    .toList(),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 12, right: 15.0, bottom: 20.0, left: 15.0),
              child: Text(
                '¿Qué es Flutter? Flutter permite a los desarrolladores crear aplicaciones hermosas compiladas de manera nativa a partir de una única base de código tanto para Android como para iOS. Flutter es actualmente uno de los frameworks más populares para el desarrollo de aplicaciones móviles multiplataforma. Además de ser una plataforma de primer nivel para Material Design, los desarrolladores lo consideran una gran alternativa a los frameworks multiplataforma populares como React Native, Ionic, etc. Los widgets de Flutter sustraen todas las diferencias críticas de la plataforma, como el desplazamiento, la navegación, los íconos y las fuentes para ofrecer un desempeño nativo completo tanto en iOS como en Android. En CodeCanyon, encontrarás todas las herramientas que necesitas para empezar a crear tu aplicación con Flutter. Con las plantillas de Flutter, toda la codificación se ha hecho con anticipación, tú solo tienes que concentrarte en hacer que tu aplicación sea única.',
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
