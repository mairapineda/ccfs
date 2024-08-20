// ignore_for_file: dead_code

import 'dart:convert';
import 'dart:typed_data';
import 'package:ccfs/app/models/activites.dart';
import 'package:ccfs/app/models/questionActivites.dart';
import 'package:ccfs/app/models/responseActividad.dart';
import 'package:ccfs/app/servicios/servicioQuestionActivites.dart';
import 'package:ccfs/app/servicios/servicioResponseActividad.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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

  @override
  void initState() {
    super.initState();
    print(widget.codActivites+'');
    _audioPlayer = AudioPlayer();

    objQuestionActivites =
        misServicios.obtenerQuestionxActivites(widget.codActivites);
    objQuestionActivites.then((questions) {
      setState(() {
        arrQuestionActivites = questions;
      });
    });

    _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        setState(() {
          _isPlaying = false;
        });
        _audioPlayer.stop();
      }
    });
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
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
      userResponses.add(ReponseActividad(
        codQuestion: objActivites.codQuestion ?? '',
        reponseUtilsActi: objActivites.selectedOption!,
      ));
    });
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
        const SizedBox(),
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
    const SizedBox();
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

  Widget _generarCard(BuildContext context, QuestionActivites objActivites,
      int index, Uint8List? archivo, String? tipoArchivo) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Card(
          margin: const EdgeInsets.all(0),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              width: double.infinity,
              height: 400,
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
                      objActivites.prenomReponActivites ?? '',
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
                          child: Text(
                            objActivites.questionsActivites ?? '',
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
                    const SizedBox(height: 10),
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
                                tipoArchivo == 'audio')
                              Center(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: FaIcon(
                                            _isPlaying
                                                ? FontAwesomeIcons
                                                    .solidCirclePause
                                                : FontAwesomeIcons
                                                    .solidCirclePlay,
                                            color: const Color.fromARGB(
                                                255, 0, 80, 74),
                                            size: 26,
                                          ),
                                          onPressed: () async {
                                            try {
                                              final audioUri =
                                                  Uri.dataFromBytes(archivo,
                                                      mimeType: 'audio/mpeg');
                                              await _audioPlayer.setAudioSource(
                                                  AudioSource.uri(audioUri));
                                              if (_isPlaying) {
                                                _audioPlayer.pause();
                                              } else {
                                                _audioPlayer.play();
                                              }
                                              setState(() {
                                                _isPlaying = !_isPlaying;
                                              });
                                            } catch (e) {
                                              print(
                                                  'Error al reproducir el audio: $e');
                                            }
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(MdiIcons.turtle,
                                              color: Color.fromARGB(
                                                  255, 0, 80, 74),
                                              size: 26),
                                          onPressed: () async {
                                            try {
                                              await _audioPlayer.setSpeed(0.7);
                                            } catch (e) {
                                              print(
                                                  'Error al cambiar la velocidad: $e');
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
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
                            child: TextField(
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
                        children: objActivites.optionsActivites!.map((option) {
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
                                    ? const Color.fromARGB(255, 206, 230, 214)
                                    : const Color.fromARGB(0, 176, 107, 107),
                                border: Border.all(
                                  color: objActivites.selectedOption == option
                                      ? const Color.fromARGB(255, 20, 239, 137)
                                      : Colors.transparent,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: SelectableText(
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
                    ] else if (objActivites.tipo == 'Selmultiple' ||
                        objActivites.tipo == 'vr/fa' ||
                        objActivites.tipo == 'vr/fa-audio') ...[
                      const SizedBox(height: 10),
                      Column(
                        children: objActivites.optionsActivites!.map((option) {
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
                                    ? const Color.fromARGB(255, 206, 230, 214)
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
                              final item = objActivites.optionsActivites!
                                  .removeAt(oldIndex);
                              objActivites.optionsActivites!
                                  .insert(newIndex, item);
                              objActivites.hasMovedOption = true;
                              objActivites.selectedOption =
                                  objActivites.optionsActivites!.join('|');
                            });
                          },
                          children: objActivites.optionsActivites!
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
                                    final item = objActivites.optionsActivites!
                                        .removeAt(data as int);
                                    objActivites.optionsActivites!
                                        .insert(idx, item);
                                    objActivites.hasMovedOption = true;
                                    objActivites.selectedOption =
                                        objActivites.optionsActivites!.join('|');
                                  });
                                },
                                builder:
                                    (context, candidateData, rejectedData) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.transparent,
                                      ),
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
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
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 130,
                            child: _currentPage <
                                    arrQuestionActivites!.length - 1
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
                                      minimumSize: const Size(50, 40),
                                    ),
                                    onPressed: () {
                                      _pauseAudio();
                                      if (_isAnswerValid(objActivites)) {
                                        saveUserResponse(objActivites);
                                        if (_pageController.page != null &&
                                            _pageController.page!.toInt() <
                                                arrQuestionActivites!.length -
                                                    1) {
                                          _pageController.nextPage(
                                            duration: const Duration(
                                                milliseconds: 10),
                                            curve: Curves.easeIn,
                                          );
                                        }
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
                                                    color: const Color.fromARGB(
                                                        255, 0, 80, 74),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: const Text(
                                                    'Veuillez répondre à la question.',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Color.fromARGB(
                                                          255, 248, 248, 248),
                                                      fontFamily:
                                                          'DidotRegular',
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    0, 136, 42, 42),
                                            duration:
                                                const Duration(seconds: 4),
                                            behavior: SnackBarBehavior.floating,
                                            margin: const EdgeInsets.all(10),
                                            padding: EdgeInsets.zero,
                                          ),
                                        );
                                      }
                                    },
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          "Suivant",
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 0, 80, 74),
                                            fontFamily: 'DidotRegular',
                                          ),
                                        ),
                                        Icon(
                                          FontAwesomeIcons.caretRight,
                                          size: 20,
                                          color: Color.fromARGB(255, 0, 80, 74),
                                        ),
                                      ],
                                    ),
                                  )
                                : OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.black,
                                      backgroundColor: Colors.white,
                                      side:
                                          const BorderSide(color: Colors.white),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      minimumSize: const Size(50, 40),
                                    ),
                                    onPressed: () async {
                                      saveUserResponse(objActivites);
                                      try {
                                        final decodedToken = jsonDecode(
                                            utf8.decode(base64Url.decode(
                                                base64Url.normalize(globals
                                                    .token
                                                    .split(".")[1]))));
                                        final codUtils = decodedToken['id'];
                                        ResponseUtilisateurActivitesService
                                            services =
                                            ResponseUtilisateurActivitesService();

                                        ReponseUtilisateurActivites
                                            objResponse =
                                            ReponseUtilisateurActivites(
                                          codActivites: widget.codActivites,
                                          codUtils: codUtils,
                                          reponseActividad: userResponses,
                                        );

                                        await services
                                            .guardarResponse(objResponse);
                                      } catch (e) {
                                        // Manejo de errores
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
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
                                                Color.fromARGB(255, 0, 80, 75),
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

bool _isAnswerValid(QuestionActivites objActivites) {
  if (objActivites.tipo == 'écrire' ||
      objActivites.tipo == 'écrire-image' ||
      objActivites.tipo == 'écrire-audio' ||
      objActivites.tipo == 'soulignez') {
    return objActivites.selectedOption != null &&
        objActivites.selectedOption!.isNotEmpty;
  } else if (objActivites.tipo == 'Selmultiple' ||
      objActivites.tipo == 'vr/fa' ||
      objActivites.tipo == 'vr/fa-audio') {
    return objActivites.selectedOption != null;
/*   } else if (objActivites.tipo == 'ordre') {
    return objActivites.optionsActivites.isNotEmpty &&
        objActivites.hasMovedOption; */
  } else if (objActivites.tipo == 'audio') {
    return true;
  }
  return false;
}
