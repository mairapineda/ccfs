// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ExpressionsList extends StatefulWidget {
  const ExpressionsList({super.key});

  @override
  State<ExpressionsList> createState() => _ExpressionsListState();
}

class _ExpressionsListState extends State<ExpressionsList>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _selectedColor = const Color.fromARGB(255, 0, 80, 74);
  final _unselectedColor = const Color.fromARGB(255, 133, 133, 133);
  final _tabs = const [
    Tab(text: 'Tab1'),
    Tab(text: 'Tab2'),
    Tab(text: 'Tab3'),
  ];

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 260,
                child: ClipRRect(
                  child: Image.network(
                    'https://images.pexels.com/photos/2662116/pexels-photo-2662116.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: SizedBox(
                height: 56.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_rounded,
                          color: Color.fromARGB(255, 255, 255, 255)),
                      onPressed: () {
                        Navigator.pushNamed(context, '/welcome');
                      },
                    ),
                    const Text(
                      "Expressions Figées",
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'DidotBold',
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    const Opacity(
                      opacity: 0.0,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios_rounded),
                        onPressed: null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 260,
            left: 0,
            right: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 0, 80, 74),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 255, 255, 255)
                        .withOpacity(0.1),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: const Text(
                'Green Leafy Vegetable Dish - 1500 Cal, 25 min\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255)),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned(
            top: 340,
            left: 0,
            right: 0,
            child: ListView(
              shrinkWrap: true,
              children: [
                Container(
                  color: const Color.fromARGB(255, 206, 230, 214),
                  child: TabBar(
                    controller: _tabController,
                    tabs: _tabs,
                    labelColor: _selectedColor,
                    indicatorColor: _selectedColor,
                    unselectedLabelColor: _unselectedColor,
                    indicatorSize: TabBarIndicatorSize.label,
                  ),
                ),
              ]
                  .map((item) => Column(
                        children: [
                          item,
                          const Divider(color: Color.fromARGB(0, 190, 117, 117))
                        ],
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
