import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 206, 230, 214),
        ),
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 30),
              child: Text(
                'Parler avec le corps',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'MonstserratBlack',
                  color: Color.fromARGB(255, 0, 80, 75),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Container(
                width: 230,
                height: 190,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                  shape: BoxShape.rectangle,
                  image: const DecorationImage(
                    image: AssetImage('images/base/Frame4.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Card(
                  margin: const EdgeInsets.all(0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    width: double.infinity,
                    height: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: const Color.fromARGB(255, 0, 80, 75),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Container(
                            width: 300,
                            alignment: Alignment
                                .center, // Ajout pour centrer le texte horizontalement
                            padding: const EdgeInsets.all(8.0),
                            child: const Text(
                              'Apprenez des expressions figées en français!',
                              textAlign: TextAlign
                                  .center, // Ajout pour centrer le texte
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'DidotRegular',
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Container(
                            width: 300,
                            alignment: Alignment
                                .center, // Ajout pour centrer le texte horizontalement
                            padding: const EdgeInsets.all(8.0),
                            child: const Text(
                              'Examinons ensemble ce qui a été dit pour en déduire ce qui peut se dire',
                              textAlign: TextAlign
                                  .center, // Ajout pour centrer le texte
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'MonstserratLight',
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.white),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  minimumSize: const Size(50, 40),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/registre');
                                },
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      "S'inscrire  ",
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                    ),
                                    Icon(
                                      FontAwesomeIcons.caretRight,
                                      size: 20,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.white),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  minimumSize: const Size(50, 40),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/login');
                                },
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      "Se connecter ",
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 0, 80, 75),
                                      ),
                                    ),
                                    Icon(
                                      FontAwesomeIcons.caretRight,
                                      size: 20,
                                      color: Color.fromARGB(255, 0, 80, 75),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
