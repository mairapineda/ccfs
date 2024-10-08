import 'package:ccfs/app/models/questionExamen.dart';
import 'package:ccfs/app/models/responseExamen.dart';
import 'package:ccfs/app/servicios/servicioQuestionExamen.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ResponseExamen extends StatefulWidget {
  final List<ReponseRepExa> userResponses;
  final String codExamen;

  const ResponseExamen({
    super.key,
    required this.userResponses,
    required this.codExamen,
  });

  @override
  State<ResponseExamen> createState() => _ResponseExamenState();
}

class _ResponseExamenState extends State<ResponseExamen> {
  int correctAnswers = 0;
  final QuestionsExamenService misServicios = QuestionsExamenService();
  late Future<List<QuestionExamen>> objQuestionExamen;

  @override
  void initState() {
    super.initState();
    objQuestionExamen = misServicios.obtenerQuestionxExamen(widget.codExamen);
  }

  void calculateScore(List<QuestionExamen> questions) {
    correctAnswers = 0;
    for (int i = 0; i < widget.userResponses.length; i++) {
      if (widget.userResponses[i].reponseUtilsExamen ==
          questions[i].reponseExamen) {
        correctAnswers++;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<QuestionExamen>>(
        future: objQuestionExamen,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay preguntas disponibles.'));
          } else {
            final questions = snapshot.data!;
            calculateScore(questions);
            double scorePercentage = (correctAnswers / questions.length) * 100;
            int incorrectAnswers = questions.length - correctAnswers;
            const SizedBox(height: 40);
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close,
                          color: Color.fromARGB(255, 0, 80, 74)),
                      onPressed: () {
                        Navigator.pushNamed(context, '/examen');
                      },
                    ),
                  ],
                ),
                Container(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Le résultat de l'examen",
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 0, 80, 74),
                            fontFamily: 'DidotBold',
                          ),
                        ),
                        const SizedBox(height: 12),
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(
                              begin: 0, end: scorePercentage / 100),
                          duration: const Duration(seconds: 2),
                          builder: (context, value, child) {
                            return CircularPercentIndicator(
                              radius: 80,
                              lineWidth: 16.0,
                              animation: true,
                              percent: value,
                              center: Text(
                                '${(value * 100).toStringAsFixed(1)}%',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                      color:
                                          const Color.fromARGB(255, 0, 80, 74),
                                      fontFamily: 'DidotBold',
                                    ),
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor:
                                  const Color.fromARGB(255, 210, 209, 209),
                              backgroundColor:
                                  const Color.fromARGB(255, 0, 80, 74),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      color: const Color.fromARGB(255, 230, 255, 250),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'Correctas: $correctAnswers',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 0, 80, 74),
                            fontFamily: 'DidotRegular',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 5,
                      color: const Color.fromARGB(255, 255, 230, 230),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'Incorrectas: $incorrectAnswers',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 211, 141, 141),
                            fontFamily: 'DidotBold',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 80, 74),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Le score: $correctAnswers/${questions.length}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontFamily: 'DidotBold',
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: ListView.builder(
                              itemCount: widget.userResponses.length,
                              itemBuilder: (context, index) {
                                final response = widget.userResponses[index];
                                final question = questions[index];
                                bool isCorrect = response.reponseUtilsExamen ==
                                    question.reponseExamen;
                                return Card(
                                  color: isCorrect
                                      ? const Color.fromARGB(255, 253, 253, 253)
                                      : const Color.fromARGB(
                                          255, 255, 230, 230),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      'Question ${index + 1}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Color.fromARGB(255, 0, 80, 74),
                                        fontFamily: 'DidotBold',
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Réponse: ${response.reponseUtilsExamen}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color.fromARGB(255, 0, 80, 74),
                                        fontFamily: 'DidotRegular',
                                      ),
                                    ),
                                    trailing: Icon(
                                      isCorrect
                                          ? Icons.check_circle
                                          : Icons.cancel,
                                      color:
                                          isCorrect ? Colors.green : Colors.red,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
