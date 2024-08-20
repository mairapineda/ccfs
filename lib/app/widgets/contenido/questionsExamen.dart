// ignore_for_file: dead_code

import 'dart:convert';
import 'dart:typed_data';
import 'package:ccfs/app/models/examen.dart';
import 'package:ccfs/app/models/questionExamen.dart';
import 'package:ccfs/app/models/responseExamen.dart';
import 'package:ccfs/app/servicios/servicioQuestionExamen.dart';
import 'package:ccfs/app/servicios/servicioResponseExamen.dart';
import 'package:ccfs/app/widgets/contenido/responseExamen.dart';
/* import 'package:ccfs/app/widgets/utils/slider.dart'; */
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ccfs/app/utilities/globals.dart' as globals;

class QuestionExamenPage extends StatefulWidget {
  final Examen codExamen;

  const QuestionExamenPage({super.key, required this.codExamen});

  @override
  State<QuestionExamenPage> createState() => _QuestionExamenPageState();
}

class _QuestionExamenPageState extends State<QuestionExamenPage> {
  final QuestionsExamenService misServicios = QuestionsExamenService();
  Future<List<QuestionExamen>> objQuestionExamen = Future(() => []);
  List<QuestionExamen>? arrQuestionExamen = [];
  final PageController _pageController = PageController();
  int _currentPage = 0;
  List<ReponseRepExa> userResponses = [];
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  double _currentSliderValue = 0.0;
  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    objQuestionExamen =
        misServicios.obtenerQuestionxExamen(widget.codExamen.codExamen);
    objQuestionExamen.then((questions) {
      setState(() {
        arrQuestionExamen = questions;
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
    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _currentSliderValue = position.inMilliseconds.toDouble();
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

  void saveUserResponse(QuestionExamen objExamen) {
    setState(() {
      userResponses.add(ReponseRepExa(
        codQuestion: objExamen.codQuestion,
        reponseUtilsExamen: objExamen.selectedOption!,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 253, 253, 253),
        ),
        child: FutureBuilder<List<QuestionExamen>>(
          future: objQuestionExamen,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return Column(
                children: [
                  _buildHeaderWithProgress(),
                  _buildPageView(),
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
        const SizedBox(height: 25),
        Stack(
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: Image.asset(
                'images/base/palc.png',
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 0, 80, 74),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text(
                'Question ${_pageController.hasClients ? _pageController.page!.toInt() + 1 : 1}/${arrQuestionExamen!.length}',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontFamily: 'DidotBold',
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(0),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 0, 80, 74),
            borderRadius: BorderRadius.circular(15),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 12,
              child: LinearProgressIndicator(
                value: (_pageController.hasClients && arrQuestionExamen != null)
                    ? _pageController.page! / (arrQuestionExamen!.length - 1)
                    : 0,
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
        itemCount: arrQuestionExamen!.length,
        itemBuilder: (context, index) {
          QuestionExamen objExamen = arrQuestionExamen![index];
          Uint8List? archivo;
          String? tipoArchivo;

          if (objExamen.base64Fichier != null &&
              objExamen.base64Fichier!.isNotEmpty) {
            try {
              archivo = const Base64Decoder().convert(objExamen.base64Fichier!);
              tipoArchivo = objExamen.tipo;
            } catch (e) {
              archivo = null;
              tipoArchivo = null;
            }
          }

          return _generarCard(context, objExamen, index, archivo, tipoArchivo);
        },
      ),
    );
  }

  void _pauseAudio() {
    if (_isPlaying) {
      _audioPlayer.pause();
      setState(() {
        _isPlaying = false;
        _currentSliderValue = 0.0;
      });
    }
  }

  Widget _generarCard(BuildContext context, QuestionExamen objExamen, int index,
      Uint8List? archivo, String? tipoArchivo) {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          width: double.infinity,
          height: 600,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(255, 0, 80, 74),
          ),
          child: IntrinsicHeight(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Text(
                  objExamen.prenomReponExamen,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontFamily: 'DidotBold',
                  ),
                  maxLines: 20,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 25),
                IntrinsicWidth(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 255, 255, 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        objExamen.questions,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 0, 80, 74),
                          fontFamily: 'DidotRegular',
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
                            tipoArchivo == 'vr/fa-audio')
                          Center(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: FaIcon(
                                        _isPlaying
                                            ? FontAwesomeIcons.solidCirclePause
                                            : FontAwesomeIcons.solidCirclePlay,
                                        color: Colors.white,
                                        size: 26,
                                      ),
                                      onPressed: () async {
                                        try {
                                          final audioUri = Uri.dataFromBytes(
                                              archivo,
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
                                    Expanded(
                                      child: SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                          activeTrackColor:
                                              const Color.fromARGB(
                                                  255, 206, 230, 214),
                                          inactiveTrackColor:
                                              const Color.fromARGB(
                                                  255, 129, 111, 51),
                                          trackHeight: 5,
                                          thumbShape:
                                              SliderComponentShape.noThumb,
                                          overlayColor: const Color.fromARGB(
                                                  255, 129, 111, 51)
                                              .withAlpha(22),
                                          /*  trackShape:
                                              RoundedInactiveTrackShape(), */
                                        ),
                                        child: Slider(
                                          value: _currentSliderValue.clamp(
                                              0.0,
                                              _audioPlayer
                                                      .duration?.inMilliseconds
                                                      .toDouble() ??
                                                  1.0),
                                          min: 0.0,
                                          max: _audioPlayer
                                                  .duration?.inMilliseconds
                                                  .toDouble() ??
                                              1.0,
                                          onChanged: (value) async {
                                            await _audioPlayer.seek(Duration(
                                                milliseconds: value.toInt()));
                                            setState(() {
                                              _currentSliderValue = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(MdiIcons.turtle,
                                          color: Colors.white, size: 26),
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
                if (objExamen.tipo == 'écrire' ||
                    objExamen.tipo == 'écrire-image' ||
                    objExamen.tipo == 'écrire-audio') ...[
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: const Color.fromARGB(255, 255, 255, 255),
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
                              objExamen.selectedOption = value;
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
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'DidotRegular',
                          ),
                          textAlign: TextAlign.justify,
                          maxLines: null,
                        ),
                      ),
                    ),
                  ),
                ] else if (objExamen.tipo == 'Selmultiple' ||
                    objExamen.tipo == 'vr/fa' ||
                    objExamen.tipo == 'vr/fa-audio') ...[
                  const SizedBox(height: 20),
                  Column(
                    children: objExamen.options.map((option) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            objExamen.selectedOption = option;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 10),
                          decoration: BoxDecoration(
                            color: objExamen.selectedOption == option
                                ? const Color.fromARGB(255, 206, 230, 214)
                                : Colors.transparent,
                            border: Border.all(
                              color: objExamen.selectedOption == option
                                  ? const Color.fromARGB(255, 255, 255, 255)
                                  : Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: 14,
                              color: objExamen.selectedOption == option
                                  ? const Color.fromARGB(255, 0, 80, 74)
                                  : Colors.white,
                              fontFamily: 'DidotRegular',
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ] else if (objExamen.tipo == 'ordre') ...[
                  const SizedBox(height: 20),
                  Expanded(
                    child: ReorderableListView(
                      buildDefaultDragHandles: false,
                      onReorder: (int oldIndex, int newIndex) {
                        setState(() {
                          if (newIndex > oldIndex) {
                            newIndex -= 1;
                          }
                          final item = objExamen.options.removeAt(oldIndex);
                          objExamen.options.insert(newIndex, item);
                          objExamen.hasMovedOption = true;
                          objExamen.selectedOption =
                              objExamen.options.join('|');
                        });
                      },
                      children: objExamen.options.asMap().entries.map((entry) {
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
                                final item =
                                    objExamen.options.removeAt(data as int);
                                objExamen.options.insert(idx, item);
                                objExamen.hasMovedOption = true;
                                objExamen.selectedOption =
                                    objExamen.options.join('|');
                              });
                            },
                            builder: (context, candidateData, rejectedData) {
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.transparent,
                                  ),
                                  color: const Color.fromARGB(255, 0, 80, 74),
                                ),
                                child: ListTile(
                                  title: Text(
                                    '${idx + 1}. $option',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 255, 255, 255),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 130,
                        child: _currentPage < arrQuestionExamen!.length - 1
                            ? OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.white),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  minimumSize: const Size(50, 40),
                                ),
                                onPressed: () {
                                  _pauseAudio();
                                  if (_isAnswerValid(objExamen)) {
                                    saveUserResponse(objExamen);
                                    if (_pageController.page != null &&
                                        _pageController.page!.toInt() <
                                            arrQuestionExamen!.length - 1) {
                                      _pageController.nextPage(
                                        duration:
                                            const Duration(milliseconds: 10),
                                        curve: Curves.easeIn,
                                      );
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: SingleChildScrollView(
                                          child: IntrinsicWidth(
                                            child: Container(
                                              width: 20,
                                              height: 40,
                                              padding: const EdgeInsets.all(12),
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
                                },
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      "Suivant",
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        fontFamily: 'DidotRegular',
                                      ),
                                    ),
                                    Icon(
                                      FontAwesomeIcons.caretRight,
                                      size: 20,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ],
                                ),
                              )
                            : OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.white),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  minimumSize: const Size(50, 40),
                                ),
                                onPressed: () async {
                                  saveUserResponse(objExamen);
                                  try {
                                    final decodedToken = jsonDecode(utf8.decode(
                                        base64Url.decode(base64Url.normalize(
                                            globals.token.split(".")[1]))));
                                    final codUtils = decodedToken['id'];
                                    ResponseUtilisateurExamenService services =
                                        ResponseUtilisateurExamenService();

                                    // Verifica que codExamen no sea nulo
                                    if (widget.codExamen.codExamen == null) {
                                      print("Error: codExamen es nulo");
                                      return;
                                    }

                                    ReponseUtilisateurExamen objResponse =
                                        ReponseUtilisateurExamen(
                                      codExamen: widget.codExamen.codExamen,
                                      codUtils: codUtils,
                                      reponseRepExa: userResponses,
                                    );

                                    await services.guardarResponse(objResponse);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ResponseExamen(
                                          userResponses: userResponses,
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

bool _isAnswerValid(QuestionExamen objExamen) {
  if (objExamen.tipo == 'écrire' ||
      objExamen.tipo == 'écrire-image' ||
      objExamen.tipo == 'écrire-audio') {
    return objExamen.selectedOption != null &&
        objExamen.selectedOption!.isNotEmpty;
  } else if (objExamen.tipo == 'Selmultiple' ||
      objExamen.tipo == 'vr/fa' ||
      objExamen.tipo == 'vr/fa-audio') {
    return objExamen.selectedOption != null;
  } else if (objExamen.tipo == 'ordre') {
    return objExamen.options.isNotEmpty && objExamen.hasMovedOption;
  }
  return false;
}
