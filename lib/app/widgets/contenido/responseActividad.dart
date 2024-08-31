import 'package:ccfs/app/models/questionActivites.dart';
import 'package:ccfs/app/models/responseActividad.dart';
import 'package:ccfs/app/servicios/servicioQuestionActivites.dart';
import 'package:flutter/material.dart';

class ResponseActivites extends StatefulWidget {
  final List<ReponseActividad> userResponses;
  final String codActivites;
  const ResponseActivites({
    super.key,
    required this.userResponses,
    required this.codActivites,
  });

  @override
  State<ResponseActivites> createState() => _ResponseActivitesState();
}

class _ResponseActivitesState extends State<ResponseActivites> {
  int correctAnswers = 0;
  final QuestionsActivitesService misServicios = QuestionsActivitesService();
  late Future<List<QuestionActivites>> objQuestionActivites;

  @override
  void initState() {
    super.initState();
    objQuestionActivites =
        misServicios.obtenerQuestionxActivites(widget.codActivites);
  }

  void calculateScore(List<QuestionActivites> questions) {
    correctAnswers = 0;

    for (int i = 0; i < questions.length; i++) {

      List<String> userResponseList = widget.userResponses[i].reponseUtilsActi.split(',');
      String rawResponse = widget.userResponses[i].reponseUtilsActi;
      if (!rawResponse.startsWith('[') || !rawResponse.endsWith(']')) {
        rawResponse = '[$rawResponse]';
      }
      List<String> correctAnswersList = questions[i].reponseActivites;
      print("Usuario: ${userResponseList.toString()}");
      print("Sin corchetes: ${rawResponse}");
      print("Correctas: ${correctAnswersList.toString()}");
      if (rawResponse == correctAnswersList.toString()) {
        print("Correcta: $rawResponse");
        correctAnswers++;
      }


    }

    print("$correctAnswers");

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<QuestionActivites>>(
        future: objQuestionActivites,
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
            int incorrectAnswers = questions.length - correctAnswers;
            const SizedBox(height: 60);
            return Column(
              children: [
                const SizedBox(height: 50,),
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
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Le résultat de l'Activites",
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 0, 80, 74),
                            fontFamily: 'DidotBold',
                          ),
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
                                List<String> userResponseList = response.reponseUtilsActi.split(',');
                                List<String> correctAnswersList = question.reponseActivites;
                                String rawResponse = response.reponseUtilsActi;
                                if (!rawResponse.startsWith('[') || !rawResponse.endsWith(']')) {
                                  rawResponse = '[$rawResponse]';
                                }

                                bool isCorrect = rawResponse == correctAnswersList.toString()
                                    ;
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
                                      'Réponse: ${response.reponseUtilsActi}',
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
