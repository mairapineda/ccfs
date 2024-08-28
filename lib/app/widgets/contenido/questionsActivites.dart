// ignore_for_file: dead_code

import 'dart:convert';
import 'dart:typed_data';
import 'package:ccfs/app/models/questionActivites.dart';
import 'package:ccfs/app/models/responseActividad.dart';
import 'package:ccfs/app/servicios/servicioQuestionActivites.dart';
import 'package:ccfs/app/servicios/servicioResponseActividad.dart';
import 'package:ccfs/app/widgets/contenido/responseActividad.dart';
import 'package:ccfs/app/widgets/utils/AudioPlayer.dart';
import 'package:ccfs/app/widgets/utils/video.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ccfs/app/utilities/globals.dart' as globals;

class QuestionActivitesPage extends StatefulWidget {
  final String codActivites;

  const QuestionActivitesPage({super.key, required this.codActivites});

  @override
  State<QuestionActivitesPage> createState() => _QuestionActivitesPageState();
}

class _QuestionActivitesPageState extends State<QuestionActivitesPage> {
  final QuestionsActivitesService misServicios = QuestionsActivitesService();
  Future<List<QuestionActivites>> objQuestionActivites = Future(() => []);
  List<QuestionActivites>? arrQuestionActivites = [];
  final PageController _pageController = PageController();
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  int _currentPage = 0;
  List<ReponseActividad> userResponses = [];
  bool isAnswerValid = false;
  bool isAnswerCorrect = false;
  int correctAnswers = 0;
  bool _showFeedback = false;
  String textoSeleccionado = "";
  List<String> textosSubrayados = [];
  List<Color> coloresSubrayados = [];
  Map<String, dynamic>? fichierData;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    objQuestionActivites =
        misServicios.obtenerQuestionxActivites(widget.codActivites);
    objQuestionActivites.then((questionsActivites) {
      setState(() {
        arrQuestionActivites = questionsActivites;
        print('arrQuestionActivites: $arrQuestionActivites');
      });
    });
    misServicios.obtenerFichier(widget.codActivites).then((data) {
      setState(() {
        fichierData = data;
      });
    });
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
        print('Current Page: $_currentPage');
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<String?> getCodUtils() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('codUtils');
  }

  void saveUserResponse(QuestionActivites objActivites) {
    setState(() {
      print(
          'Guardando respuesta: codQuestion=${objActivites.codQuestion}, selectedOption=${objActivites.selectedOption}');
      userResponses.add(ReponseActividad(
        codQuestion: objActivites.codQuestion,
        reponseUtilsActi: objActivites.selectedOption!,
      ));
    });
  }

  List<TextSpan> _buildTextSpans(String textoCompleto) {
    List<TextSpan> spans = [];
    int start = 0;

    for (int i = 0; i < textosSubrayados.length; i++) {
      String subrayado = textosSubrayados[i];
      int index = textoCompleto.indexOf(subrayado, start);
      while (index >= 0) {
        if (index > start) {
          spans.add(TextSpan(
            text: textoCompleto.substring(start, index),
            style: const TextStyle(
              color: Color.fromARGB(255, 0, 80, 74),
              fontSize: 14,
              fontFamily: 'DidotRegular',
            ),
          ));
        }
        spans.add(TextSpan(
          text: subrayado,
          style: const TextStyle(
            backgroundColor: Color.fromARGB(255, 129, 111, 51),
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ));
        start = index + subrayado.length;
        index = textoCompleto.indexOf(subrayado, start);
      }
    }

    if (start < textoCompleto.length) {
      spans.add(TextSpan(
        text: textoCompleto.substring(start),
        style: const TextStyle(
          color: Color.fromARGB(255, 0, 80, 74),
          fontSize: 14,
          fontFamily: 'DidotRegular',
        ),
      ));
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 0, 80, 74),
        ),
        child: FutureBuilder<List<QuestionActivites>>(
          future: objQuestionActivites,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        _buildPageView(),
                        _buildHeaderWithProgress(),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildHeaderWithProgress() {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Container(
          margin: const EdgeInsets.all(0),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(15),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 12,
              child: LinearProgressIndicator(
                value: (_pageController.hasClients &&
                        arrQuestionActivites != null)
                    ? _pageController.page! / (arrQuestionActivites!.length - 1)
                    : 0,
                backgroundColor: const Color.fromARGB(255, 0, 80, 74),
                valueColor: const AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 159, 159, 159)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPageView() {
    const SizedBox(
      height: 15,
    );
    return Expanded(
      child: PageView.builder(
        controller: _pageController,
        itemCount: arrQuestionActivites!.length,
        itemBuilder: (context, index) {
          QuestionActivites objActivites = arrQuestionActivites![index];
          Uint8List? archivo;
          String? tipoArchivo;

          if (objActivites.base64Fichier != null &&
              objActivites.base64Fichier!.isNotEmpty) {
            try {
              archivo =
                  const Base64Decoder().convert(objActivites.base64Fichier!);
              tipoArchivo = objActivites.tipo;
            } catch (e) {
              archivo = null;
              tipoArchivo = null;
            }
          }
          return _generarCard(
              context, objActivites, index, archivo, tipoArchivo);
        },
      ),
    );
  }

  void _pauseAudio() {
    if (_isPlaying) {
      _audioPlayer.pause();
      setState(() {
        _isPlaying = false;
      });
    }
  }

/*   bool validateSingleAnswer(
      ReponseActividad userResponse, QuestionActivites question) {
    return userResponse.reponseUtilsActi == question.reponseActivites;
  } */
  void validateSingleAnswer(
      int questionIndex, List<QuestionActivites> questions) {
    if (userResponses[questionIndex].reponseUtilsActi ==
        questions[questionIndex].reponseActivites) {
      correctAnswers++;
    }
  }

  Widget _generarCard(BuildContext context, QuestionActivites objActivites,
      int index, Uint8List? archivo, String? tipoArchivo) {
    const SizedBox(height: 20);
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          width: double.infinity,
          height: 700,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
          child: IntrinsicHeight(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Text(
                  objActivites.prenomReponActivites,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 0, 80, 74),
                    fontFamily: 'DidotBold',
                  ),
                  maxLines: 20,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 10),
                IntrinsicWidth(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 80, 74),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: SingleChildScrollView(
                      child: objActivites.tipo == 'deplacer'
                          ? _buildDragTargetText(objActivites)
                          : Text(
                              objActivites.questionsActivites,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontFamily: 'DidotRegular',
                              ),
                              textAlign: TextAlign.justify,
                            ),
                    ),
                  ),
                ),
                if (archivo != null && tipoArchivo != null) ...[
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        if (tipoArchivo == 'écrire-image')
                          Visibility(
                            visible: true,
                            child: Image.memory(
                              archivo,
                              gaplessPlayback: true,
                            ),
                          ),
                        if (tipoArchivo == 'écrire-audio' ||
                            tipoArchivo == 'vr/fa-audio' ||
                            tipoArchivo == 'audio' ||
                            tipoArchivo == 'complet-audio' ||
                            tipoArchivo == 'Selmultiple-audio')
                          Center(
                            child: AudioPlayerWidget(archivo: archivo),
                          ),
                        if (tipoArchivo == 'video' && fichierData != null)
                          VideoPlayerScreen(
                              videoUrl: fichierData!['prenomFichier']),
                      ],
                    ),
                  ),
                ],
                if (objActivites.tipo == 'écrire' ||
                    objActivites.tipo == 'écrire-image' ||
                    objActivites.tipo == 'écrire-audio') ...[
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: const Color.fromARGB(255, 0, 80, 74),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 100,
                        ),
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                              objActivites.selectedOption = value;
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'Inscrivez votre réponse ici',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'DidotRegular',
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                          ),
                          style: const TextStyle(
                            color: Color.fromARGB(255, 0, 80, 74),
                            fontSize: 14,
                            fontFamily: 'DidotRegular',
                          ),
                          textAlign: TextAlign.justify,
                          maxLines: null,
                        ),
                      ),
                    ),
                  ),
                ] else if (objActivites.tipo == 'soulignez') ...[
                  const SizedBox(height: 10),
                  Column(
                    children: objActivites.optionsActivites.map((option) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 20.0),
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: SelectableText.rich(
                              TextSpan(
                                children: _buildTextSpans(option),
                              ),
                              onSelectionChanged: (selection, cause) {
                                setState(() {
                                  textoSeleccionado =
                                      selection.textInside(option);

                                  print(
                                      "Texto seleccionado: $textoSeleccionado");
                                });
                              },
                            ),
                          ),
                          if (textoSeleccionado.isNotEmpty)
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  if (textoSeleccionado.isNotEmpty) {
                                    textosSubrayados.add(textoSeleccionado);
                                    textoSeleccionado = "";
                                    objActivites.selectedOption =
                                        textosSubrayados.join(", ");
                                    print(
                                        "Textos subrayados: $textosSubrayados");
                                  }
                                });
                              },
                              child: const Text("Aceptar texto seleccionado"),
                            ),
                        ],
                      );
                    }).toList(),
                  ),
                ] else if (objActivites.tipo == 'complet-audio') ...[
                  const SizedBox(height: 10),
                  _buildEditableText(objActivites),
                  Expanded(
                    child: ListView.builder(
                      itemCount: objActivites.optionsActivites.length,
                      itemBuilder: (context, idx) {
                        String option = objActivites.optionsActivites[idx];
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                          child: TextField(
                            controller: TextEditingController(text: option),
                            onChanged: (newText) {
                              setState(() {
                                objActivites.optionsActivites[idx] = newText;
                                objActivites.selectedOption =
                                    objActivites.optionsActivites.join(',');
                              });
                            },
                            decoration: InputDecoration(
                              labelText: '${idx + 1}.',
                              labelStyle: const TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 0, 80, 74),
                                fontFamily: 'DidotRegular',
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ] else if (objActivites.tipo == 'deplacer') ...[
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: objActivites.optionsActivites.map((option) {
                      return Row(
                        children: [
                          Draggable<String>(
                            data: option,
                            feedback: Material(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 10),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  option,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 0, 80, 74),
                                    fontFamily: 'DidotRegular',
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 10),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 206, 230, 214),
                                border: Border.all(
                                    color:
                                        const Color.fromARGB(255, 0, 80, 74)),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: DragTarget<String>(
                                onWillAcceptWithDetails: (data) {
                                  print('Will accept: $data');
                                  return data == data;
                                },
                                onAcceptWithDetails: (data) {
                                  setState(() {
                                    objActivites.hasMovedOption = true;
                                    objActivites.selectedOption =
                                        objActivites.optionsActivites.join(',');
                                  });
                                  print('Accepted: $data');
                                },
                                builder:
                                    (context, candidateData, rejectedData) {
                                  return Text(
                                    option,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 0, 80, 74),
                                      fontFamily: 'DidotRegular',
                                    ),
                                    textAlign: TextAlign.justify,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ] else if (objActivites.tipo == 'Selmultiple' ||
                    objActivites.tipo == 'vr/fa' ||
                    objActivites.tipo == 'vr/fa-audio' ||
                    tipoArchivo == 'Selmultiple-audio') ...[
                  const SizedBox(height: 10),
                  Column(
                    children: objActivites.optionsActivites.map((option) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            objActivites.selectedOption = option;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 10),
                          decoration: BoxDecoration(
                            color: objActivites.selectedOption == option
                                ? const Color.fromARGB(255, 0, 80, 74)
                                : Colors.transparent,
                            border: Border.all(
                              color: objActivites.selectedOption == option
                                  ? const Color.fromARGB(255, 255, 255, 255)
                                  : Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: 14,
                              color: objActivites.selectedOption == option
                                  ? const Color.fromARGB(255, 255, 255, 255)
                                  : const Color.fromARGB(255, 0, 80, 74),
                              fontFamily: 'DidotRegular',
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ] else if (objActivites.tipo == 'ordre') ...[
                  const SizedBox(height: 10),
                  Expanded(
                    child: ReorderableListView(
                      buildDefaultDragHandles: false,
                      onReorder: (int oldIndex, int newIndex) {
                        setState(() {
                          if (newIndex > oldIndex) {
                            newIndex -= 1;
                          }
                          final item =
                              objActivites.optionsActivites.removeAt(oldIndex);
                          objActivites.optionsActivites.insert(newIndex, item);
                          objActivites.hasMovedOption = true;
                          objActivites.selectedOption =
                              objActivites.optionsActivites.join('|');
                        });
                      },
                      children: objActivites.optionsActivites
                          .asMap()
                          .entries
                          .map((entry) {
                        int idx = entry.key;
                        String option = entry.value;
                        return ReorderableDragStartListener(
                          key: ValueKey(option),
                          index: idx,
                          child: DragTarget<int>(
                            onWillAcceptWithDetails: (data) {
                              return true;
                            },
                            onAcceptWithDetails: (data) {
                              setState(() {
                                final item = objActivites.optionsActivites
                                    .removeAt(data as int);
                                objActivites.optionsActivites.insert(idx, item);
                                objActivites.hasMovedOption = true;
                                objActivites.selectedOption =
                                    objActivites.optionsActivites.join('|');
                              });
                            },
                            builder: (context, candidateData, rejectedData) {
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.transparent,
                                  ),
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                ),
                                child: ListTile(
                                  title: Text(
                                    '${idx + 1}. $option',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 0, 80, 74),
                                      fontFamily: 'DidotRegular',
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 70,
                        child: _currentPage < arrQuestionActivites!.length - 1
                            ? OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor:
                                      const Color.fromARGB(255, 0, 80, 74),
                                  side: const BorderSide(
                                    color: Color.fromARGB(255, 0, 80, 74),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  minimumSize: const Size(30, 20),
                                ),
                                onPressed: () {
                                  if (_showFeedback) {
                                    if (_pageController.page!.toInt() <
                                        arrQuestionActivites!.length - 1) {
                                      setState(() {
                                        _showFeedback = false;
                                      });
                                      _pageController.nextPage(
                                        duration:
                                            const Duration(milliseconds: 10),
                                        curve: Curves.easeIn,
                                      );
                                    }
                                  } else {
                                    _pauseAudio();
                                    if (_isAnswerValid(objActivites)) {
                                      saveUserResponse(objActivites);
                                      validateSingleAnswer(
                                          _currentPage, arrQuestionActivites!);
                                      setState(() {
                                        _showFeedback = true;
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: SingleChildScrollView(
                                            child: IntrinsicWidth(
                                              child: Container(
                                                width: 20,
                                                height: 40,
                                                padding:
                                                    const EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromRGBO(
                                                      255, 255, 255, 1),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: const Text(
                                                  'Veuillez répondre à la question.',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Color.fromARGB(
                                                        255, 0, 80, 74),
                                                    fontFamily: 'DidotRegular',
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                          backgroundColor: const Color.fromARGB(
                                              0, 136, 42, 42),
                                          duration: const Duration(seconds: 4),
                                          behavior: SnackBarBehavior.floating,
                                          margin: const EdgeInsets.all(10),
                                          padding: EdgeInsets.zero,
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: _showFeedback
                                    ? const Icon(
                                        FontAwesomeIcons.caretRight,
                                        size: 20,
                                        color: Color.fromARGB(255, 0, 80, 74),
                                      )
                                    : const Icon(
                                        FontAwesomeIcons.check,
                                        size: 20,
                                        color: Color.fromARGB(255, 0, 80, 74),
                                      ),
                              )
                            : OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor:
                                      const Color.fromARGB(255, 0, 80, 74),
                                  side: const BorderSide(
                                      color: Color.fromARGB(255, 0, 80, 74)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  minimumSize: const Size(50, 40),
                                ),
                                onPressed: () async {
                                  saveUserResponse(objActivites);
                                  try {
                                    final decodedToken = jsonDecode(utf8.decode(
                                        base64Url.decode(base64Url.normalize(
                                            globals.token.split(".")[1]))));
                                    final codUtils = decodedToken['id'];
                                    ResponseUtilisateurActivitesService
                                        services =
                                        ResponseUtilisateurActivitesService();

                                    // Verifica que codExamen no sea nulo
                                    if (widget.codActivites == null) {
                                      print("Error: codExamen es nulo");
                                      return;
                                    }

                                    ReponseUtilisateurActivites objResponse =
                                        ReponseUtilisateurActivites(
                                      codActivites: widget.codActivites,
                                      codUtils: codUtils,
                                      reponseActividad: userResponses,
                                    );

                                    await services.guardarResponse(objResponse);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ResponseActivites(
                                          userResponses: userResponses,
                                          codActivites: widget.codActivites,
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    // Manejo de errores
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Error al guardar la respuesta: $e')),
                                    );
                                  }
                                },
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      "Terminer",
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
                      ),
                      if (_showFeedback)
                        Card(
                          margin: const EdgeInsets.all(20),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(correctAnswers > 0
                                    ? 'Réponse correcte'
                                    : 'Réponse incorrecte'),
                                Text(objActivites.retourActivites ?? ''),
                              ],
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
      ),
    );
  }
}

Widget _buildDragTargetText(QuestionActivites objActivites) {
  List<String> parts = objActivites.questionsActivites.split('___');
  List<String?> acceptedOptions = List<String?>.filled(parts.length, null);

  return StatefulBuilder(
    builder: (BuildContext context, StateSetter setState) {
      return Wrap(
        children: parts.asMap().entries.map((entry) {
          int index = entry.key;
          String part = entry.value;

          return part == ''
              ? DragTarget<String>(
                  onAccept: (String option) {
                    setState(() {
                      acceptedOptions[index] = option;
                    });
                  },
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        acceptedOptions[index] ?? '___________',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontFamily: 'DidotRegular',
                        ),
                      ),
                    );
                  },
                )
              : Text(
                  part,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontFamily: 'DidotRegular',
                  ),
                );
        }).toList(),
      );
    },
  );
}

Widget _buildEditableText(QuestionActivites objActivites) {
  List<String> parts = objActivites.questionsActivites.split('___');
  List<TextEditingController> controllers =
      List.generate(parts.length, (index) => TextEditingController());

  return StatefulBuilder(
    builder: (BuildContext context, StateSetter setState) {
      return Wrap(
        children: parts.asMap().entries.map((entry) {
          int index = entry.key;
          String part = entry.value;

          return part == ''
              ? Container(
                  height: 30,
                  width: 150,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: controllers[index],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontFamily: 'DidotRegular',
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '________________',
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez répondre à la question.';
                      }
                      return null;
                    },
                  ),
                )
              : Text(
                  part,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontFamily: 'DidotRegular',
                  ),
                );
        }).toList(),
      );
    },
  );
}

bool _isAnswerValid(QuestionActivites objActivites) {
  switch (objActivites.tipo) {
    case 'écrire':
    case 'écrire-image':
    case 'écrire-audio':
    case 'soulignez':
      return objActivites.selectedOption != null &&
          objActivites.selectedOption!.isNotEmpty;

    case 'Selmultiple':
    case 'vr/fa':
    case 'vr/fa-audio':
    case 'Selmultiple-audio':
      return objActivites.selectedOption != null;

    case 'ordre':
    case 'deplacer':
      return objActivites.optionsActivites.isNotEmpty &&
          objActivites.hasMovedOption;

    default:
      return false;
  }
}
