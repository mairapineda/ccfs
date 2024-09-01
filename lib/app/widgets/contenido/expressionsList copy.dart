import 'dart:convert';
import 'dart:typed_data';
import 'package:ccfs/app/servicios/servicioFigges.dart';
import 'package:ccfs/app/widgets/contenido/actividades.dart';
import 'package:ccfs/app/widgets/utils/slider.dart';
import 'package:flutter/material.dart';
import 'package:ccfs/app/models/expressionFigges.dart';
import 'package:just_audio/just_audio.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExpressionsList2 extends StatefulWidget {
  final Expression codFigees;

  const ExpressionsList2({
    super.key,
    required this.codFigees,
  });

  @override
  _ExpressionsList2State createState() => _ExpressionsList2State();
}

class _ExpressionsList2State extends State<ExpressionsList2> {
  final FiggesService misServicios = FiggesService();
  late Future<Expression> objExpression =
      Future(() => Expression('', '', '', '', '', '', '', '', ''));

  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isPaused = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  late Uint8List _imageBytes;

  @override
  void initState() {
    super.initState();
    objExpression = misServicios.obtenerExpression(widget.codFigees.codFigees);
    _audioPlayer = AudioPlayer();

    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _position = position;
      });
    });

    _audioPlayer.durationStream.listen((duration) {
      setState(() {
        _duration = duration ?? Duration.zero;
      });
    });

    _audioPlayer.playerStateStream.listen((state) {
      setState(() {
        _isPlaying = state.playing;
        _isPaused =
            state.processingState == ProcessingState.ready && !state.playing;
        if (state.processingState == ProcessingState.completed) {
          _isPlaying = false;
        }
      });
    });

    // Precargar la imagen
    _imageBytes = const Base64Decoder().convert(widget.codFigees.base64Figees);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(MemoryImage(_imageBytes), context);
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playPauseAudio() async {
    print("Reproduciendo audio");
    try {
      if (_isPlaying) {
        print("Audio pausadp");
        await _audioPlayer.pause();
      } else if (_isPaused) {
        print("Audio iniciado");
        await _audioPlayer.play();
      } else {
        Uint8List bytes =
            const Base64Decoder().convert(widget.codFigees.base64MultiFigees);
        await _audioPlayer.setAudioSource(
            AudioSource.uri(Uri.dataFromBytes(bytes, mimeType: 'audio/mpeg')));
        await _audioPlayer.play();
      }
    } catch (e) {
      print('Error al reproducir/pausar el audio: $e');
    }
  }

  void _seekAudio(Duration position) async {
    try {
      await _audioPlayer.seek(position);
      setState(() {
        _position = position;
      });
    } catch (e) {
      ('Error al buscar en el audio: $e');
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 80, 74),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 340,
                  child: ClipRRect(
                    child: Image.memory(
                      _imageBytes,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: FaIcon(
                              _isPlaying
                                  ? FontAwesomeIcons.solidCirclePause
                                  : FontAwesomeIcons.solidCirclePlay,
                              color: Colors.white,
                              size: 26,
                            ),
                            onPressed: _playPauseAudio,
                          ),
                          Expanded(
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor:
                                    const Color.fromARGB(255, 129, 111, 51),
                                inactiveTrackColor:
                                    const Color.fromARGB(255, 255, 255, 255),
                                trackHeight: 5,
                                thumbShape: SliderComponentShape.noThumb,
                                overlayColor:
                                    const Color.fromARGB(255, 255, 255, 255)
                                        .withAlpha(22),
                                trackShape: RoundedTrackShape(),
                              ),
                              child: Slider(
                                value: _position.inSeconds.toDouble(),
                                min: 0.0,
                                max: _duration.inSeconds.toDouble(),
                                onChanged: (value) {
                                  _seekAudio(Duration(seconds: value.toInt()));
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 7),
                          Text(
                            _formatDuration(_duration - _position),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.codFigees.prenomFigees,
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'DidotBold',
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      Card(
                        color: const Color.fromARGB(255, 255, 255, 255)
                            .withOpacity(0.4),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Définition",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'DidotBold',
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                widget.codFigees.definitionFigees,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'DidotRegular',
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                textAlign: TextAlign.justify,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "Origine",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'DidotBold',
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                widget.codFigees.originFigees,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'DidotRegular',
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
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
                              Navigator.pushNamed(context, '/roles');
                            },
                            child: const Text(
                              "Example",
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ),
                          const SizedBox(
                              width: 20), // Espacio entre los botones
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ActivitesxFigees(
                                      codFigees: widget.codFigees),
                                ),
                              );
                            },
                            child: const Text(
                              "Activites",
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
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
                          Navigator.pop(context);
                        },
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
          ],
        ),
      ),
    );
  }
}
