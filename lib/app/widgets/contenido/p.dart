import 'package:flutter/material.dart';

class ExpressionsPage extends StatelessWidget {
  const ExpressionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 255, 255, 255),
        padding: const EdgeInsets.all(10),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 1,
            ),
            itemCount: _articles.length,
            itemBuilder: (BuildContext context, int index) {
              final item = _articles[index];
              return _generarTarjeta(context, item);
            },
          ),
        ),
      ),
    );
  }
}

Widget _generarTarjeta(BuildContext context, PartieduCorps corps) {
  return GestureDetector(
    onTap: () {},
    child: Container(
      width: 120,
      height: 120,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 206, 230, 214),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            offset: const Offset(3, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  corps.imageUrl,
                  fit: BoxFit.contain,
                  height: 60,
                  width: 60,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                corps.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class PartieduCorps {
  final String title;
  final String imageUrl;

  PartieduCorps({
    required this.title,
    required this.imageUrl,
  });
}

final List<PartieduCorps> _articles = [
  PartieduCorps(
    title: "option",
    imageUrl: "https://picsum.photos/id/1000/960/540",
  ),
  PartieduCorps(
    title: "Google Search ",
    imageUrl: "https://picsum.photos/id/1010/960/540",
  ),
  PartieduCorps(
    title: "Check your",
    imageUrl: "https://picsum.photos/id/1001/960/540",
  ),
  PartieduCorps(
    title: "central Europe",
    imageUrl: "https://picsum.photos/id/1002/960/540",
  ),
  PartieduCorps(
    title: "Panasonic's",
    imageUrl: "https://picsum.photos/id/1020/960/540",
  ),
  PartieduCorps(
    title: "Samsung Galaxy ",
    imageUrl: "https://picsum.photos/id/1021/960/540",
  ),
  PartieduCorps(
    title: "Snapchat ",
    imageUrl: "https://picsum.photos/id/1060/960/540",
  ),
];
