// ignore_for_file: file_names

import 'package:flutter/material.dart';

class InicioListar extends StatelessWidget {
  const InicioListar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 80, 74),
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            const Text(
              'Parler avec le corps',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'DidotRegular',
              ),
            ),
            const SizedBox(width: 10),
            Image.asset(
              'images/base/palc.png',
              fit: BoxFit.contain,
              height: 40,
              width: 40,
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 206, 230, 214),
        ),
        child: Center(
          child: Stack(
            children: [
              Positioned(
                top: 150, // Set the right position to 0
                child: Container(
                  width: 500,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 39, 109, 105),
                  ),
                ),
              ),
              Positioned(
                left: 30,
                right: 30,
                top: 80,
                child: Container(
                  width: 100,
                  height: 230,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    shape: BoxShape.rectangle,
                    image: const DecorationImage(
                      image: NetworkImage(
                        "https://media.istockphoto.com/id/1130116320/es/foto/parque-principal-jaime-rook-paipa-boyaca-colombia.jpg?s=612x612&w=0&k=20&c=t20lPaC91_U38cKvjY_mseZwP0HcXQfd-j7nWhjBnyA=",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          backgroundColor: const Color(0xFF002A3A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(
                              color: Color.fromRGBO(33, 158, 155, 1.0),
                              width: 2.0,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/list');
                          // Add your button's onPressed logic here
                        },
                        child: const Text('Parques'),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 50, right: 50),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          backgroundColor: const Color(0xFF002A3A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(
                              color: Color.fromRGBO(33, 158, 155, 1.0),
                              width: 2.0,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/gal');
                          // Add your button's onPressed logic here
                        },
                        child: const Text('Museo'),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          backgroundColor: const Color(0xFF002A3A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(
                              color: Color.fromRGBO(33, 158, 155, 1.0),
                              width: 2.0,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/map');
                        },
                        child: const Text('Entrada'),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 290, left: 20, right: 20),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        '¿No sabes por dónde  empezar?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 330, left: 20, right: 20),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Descubre los lugares mas populares de Boyacá',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 360, left: 20, right: 20),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Divider(
                        color: Colors.white,
                        thickness: 2,
                        indent: 30,
                        endIndent: 30,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 200, left: 20, right: 20),
                child: Stack(
                  children: [
                    Align(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          backgroundColor: const Color(0xFF002A3A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                              color: Color.fromARGB(255, 255, 255, 255),
                              width: 1.0,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/map');
                          // Add your button's onPressed logic here
                        },
                        child: const Text('Déjate Inspirar'),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 450, left: 80, right: 20),
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 39, 109, 105),
                      ),
                    ),
                    Positioned(
                      child: Container(
                        width: 100,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          shape: BoxShape.rectangle,
                          border: Border.all(
                            color: const Color.fromARGB(255, 252, 252,
                                252), // Replace with your desired color
                            width: 1.0,
                          ),
                          image: const DecorationImage(
                            image: NetworkImage(
                              "https://media.istockphoto.com/id/1134242262/es/foto/paramo-de-oceta-in-boyaco-colombia.jpg?s=612x612&w=0&k=20&c=d8dXy9W8dMSEVllFyp0u5t6J05pvHn2HhsxqAbA0Jm0=",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 450, left: 310, right: 20),
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 39, 109, 105),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 100,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          shape: BoxShape.rectangle,
                          border: Border.all(
                            color: const Color.fromARGB(255, 252, 252, 252),
                            width: 1.0,
                          ),
                          image: const DecorationImage(
                            image: NetworkImage(
                              "https://media.istockphoto.com/id/1655572465/es/foto/raquira-colombia-5-de-enero-de-2023-colorida-fachada-de-un-restaurante-de-cazuela-boyacense-en.jpg?s=612x612&w=0&k=20&c=gqUzfmVbmDwSgzcMmzWXU-qefOLdxt45qnOlB4qohbw=",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
