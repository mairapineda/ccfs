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
  bool _allAssociated = false;
  List<ReponseActividad> userResponses = [];
  bool isAnswerValid = false;
  bool isAnswerCorrect = false;
  int correctAnswers = 0;
  bool _showFeedback = false;
  String textoSeleccionado = "";
  List<String> textosSubrayados = [];
  List<Color> coloresSubrayados = [];
  Map<String, dynamic>? fichierData;
  Set<String> elementosRelacionados = {};
  Map<String, String> relacion = {};

  List<List<String>> relaciones = [];
  int relacionShipIndex = 0;
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
      print('Guardando respuesta: codQuestion=${objActivites.codQuestion}, selectedOption=${objActivites.selectedOption}');
      userResponses.add(ReponseActividad(
        codQuestion: objActivites.codQuestion,
        reponseUtilsActi: objActivites.selectedOption ?? "",
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
    const SizedBox(height: 20 ,);
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
          return _generarCard(context, objActivites, index, archivo, tipoArchivo);
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
  void validateSingleAnswer(int questionIndex, List<QuestionActivites> questions) {
    List<String> userResponseList = userResponses[questionIndex].reponseUtilsActi.split(',');
    print("Probando resultado individual");
    String rawResponse = userResponses[questionIndex].reponseUtilsActi;
    print(rawResponse);
    print(questions[questionIndex].reponseActivites);
    if (rawResponse == questions[questionIndex].reponseActivites.toString()) {
      correctAnswers++;
    }else if(userResponseList.toString() == questions[questionIndex].reponseActivites.toString()){
      correctAnswers++;
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
                  objActivites.selectedOption = acceptedOptions
                      .where((element) => element != null)
                      .join(',');
                  objActivites.hasMovedOption = true;
                });
                print(acceptedOptions);
                print(objActivites.selectedOption);
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


  bool _isAnswerValid(QuestionActivites objActivites) {
    print(objActivites.tipo);
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
      case 'associé':
        return objActivites.selectedOption != null && _allAssociated;
      default:
        return false;
    }
  }


  Uint8List base64ToUint8List(String base64String) {
    final base64Data = base64String.split(',').last;
    return base64Decode(base64Data);
  }

  Widget _generarCard(BuildContext context, QuestionActivites objActivites, int index, Uint8List? archivo, String? tipoArchivo) {


    List? imageAssociationReponse = objActivites.imageAssociationReponse;
    List<String>? base64Strings = imageAssociationReponse?.cast<String>();


    const String defaultBase64Image = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==';


    final Uint8List defaultImage = base64ToUint8List(defaultBase64Image);
    List<Uint8List>? images = base64Strings?.map((base64String) {
      return base64Decode(base64String);
    }).toList();
    List<String> data = objActivites.optionsActivites.toList();
    List<String> dataRelationship = objActivites.reponseActivites.toList();

    bool todasRelacionadas = relaciones.length == data.length;
    List<String> userResponse =[];
    if (todasRelacionadas) {
      int aciertos = 0;

      for (int i = 0; i < relaciones.length; i++) {
        String dataSeleccionada = relaciones[i][0];
        String relacionSeleccionada = relaciones[i][1];

        print("Dato original: ${dataSeleccionada}");
        print("Dato relacionado: ${relacionSeleccionada}");


        userResponse.add(relacionSeleccionada);


        objActivites.selectedOption = userResponse.toString();
        _allAssociated = true;

        int index = data.indexOf(dataSeleccionada);

        print(objActivites.selectedOption);

        if (index != -1 && dataRelationship[index] == relacionSeleccionada) {
          aciertos++;
        }
      }

      print(userResponse.toString());
      double porcentaje = (data.length > 0) ? (aciertos / data.length) * 100 : 0;

      print('Aciertos: $aciertos de ${data.length} (${porcentaje.toStringAsFixed(2)}%)');

      // getResult(points, "Aciertos: $aciertos de ${data.length} (${porcentaje.toStringAsFixed(2)}%)", porcentaje, 1, context, "null");
    }


    const SizedBox(height: 0);
    return Flexible(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          width: double.infinity,
          height: 1100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
          child: IntrinsicHeight(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 70),
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

                                  print("Texto seleccionado: $textoSeleccionado");
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
                                    print("Textos subrayados: $textosSubrayados");
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
                                  print('Will accept: ${data.data}');
                                  return data.data == data.data;
                                },
                                onAcceptWithDetails: (data) {
                                  setState(() {

                                    objActivites.hasMovedOption = true;
                                    objActivites.selectedOption =
                                        objActivites.optionsActivites.join(',');
                                  });
                                  print('Accepted: ${data.data}');
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
                ]  else if (objActivites.tipo == 'associé') ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 300),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final item = data[index];
                              if(!elementosRelacionados.contains(item)){
                                return Draggable(
                                  feedback: Material(
                                    elevation: 4.0,
                                    child: Container(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(item),
                                    ),
                                  ),
                                  data: item,
                                  child: ListTile(
                                    title: Text(item),
                                  ),
                                );
                              }else{

                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 300),
                          child: DragTarget(
                            onAcceptWithDetails: (data) {

                            },
                            builder: (context, candidateData, rejectedData) {
                              return ListView.builder(

                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: dataRelationship.length,

                                itemBuilder: (context, index) {
                                  final item = dataRelationship[index];
                                  Uint8List imageToShow = images != null && images!.isNotEmpty
                                      ? images![index]
                                      : defaultImage;
                                  return DragTarget<String>(
                                    onWillAcceptWithDetails: (data) => true,
                                    onAcceptWithDetails: (data) {
                                      setState(() {
                                        print("Aceptando un dato: ${data.data}");
                                        elementosRelacionados.add(data.data);
                                        relaciones.add([data.data, item]);
                                        print(relaciones.toString());
                                      });
                                    },
                                    builder: (context, candidateData, rejectedData) {
                                      return ListTile(
                                        title: Column(
                                          children: [
                                            Container(
                                              width: 50,
                                              height: 50,
                                              margin: const EdgeInsets.only(top: 10.0),
                                              padding: const EdgeInsets.all(5.0),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8.0),
                                                image: DecorationImage(
                                                  fit: BoxFit.contain,
                                                  image: MemoryImage(imageToShow),
                                                ),
                                              ),
                                            ),
                                            //Text(item),

                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },

                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                ],
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        child: _currentPage < arrQuestionActivites!.length - 1
                            ? OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor:
                                      const Color.fromARGB(255, 0, 80, 74),
                                  side: const BorderSide(
                                    color: Color.fromARGB(255, 0, 80, 74),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  minimumSize: const Size(30, 20),
                                ),
                                onPressed: () {
                                  print("Boton de check");
                                  if(_showFeedback){
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
                                  }else{
                                    _pauseAudio();
                                    if (_isAnswerValid(objActivites) != false) {
                                      saveUserResponse(objActivites);
                                      validateSingleAnswer(
                                          _currentPage, arrQuestionActivites!);
                                      setState(() {
                                        _showFeedback = true;
                                      });
                                    } else {
                                      print("Error false");
                                      /*ScaffoldMessenger.of(context)
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
                                      );*/
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
                            : GestureDetector(
                          onTap: () async {
                            saveUserResponse(objActivites);
                            try {
                              final decodedToken = jsonDecode(utf8.decode(
                                  base64Url.decode(base64Url.normalize(
                                      globals.token.split(".")[1]))));
                              final codUtils = decodedToken['id'];
                              ResponseUtilisateurActivitesService services =
                              ResponseUtilisateurActivitesService();

                              // Verifica que codExamen no sea nulo
                              if (widget.codActivites == null) {
                                print("Error: codExamen es nulo");
                                return;
                              }

                              ReponseUtilisateurActivites objResponse = ReponseUtilisateurActivites(
                                codActivites: widget.codActivites,
                                codUtils: codUtils,
                                reponseActividad: userResponses,
                              );

                              if(await services.guardarResponse(objResponse)){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ResponseActivites(
                                      userResponses: userResponses,
                                      codActivites: widget.codActivites,
                                    ),
                                  ),
                                );
                              }

                            } catch (e) {
                              // Manejo de errores
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Error al guardar la respuesta: $e')),
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color:const Color.fromARGB(255, 0, 80, 74),

                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Terminer",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Icon(
                                  FontAwesomeIcons.caretRight,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),



                        /*OutlinedButton(
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
                              ),*/
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
              ],
            ),
          ),
        ),
      ),
    );
  }
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


