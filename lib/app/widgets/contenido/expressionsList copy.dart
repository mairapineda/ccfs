import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:ccfs/app/models/expressionFigges.dart';
import 'package:just_audio/just_audio.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExpressionsList1 extends StatefulWidget {
  final Expression objfigees;

  const ExpressionsList1({super.key, required this.objfigees});

  @override
  _ExpressionsList1State createState() => _ExpressionsList1State();
}

class _ExpressionsList1State extends State<ExpressionsList1> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isPaused = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  late Uint8List _imageBytes;

  @override
  void initState() {
    super.initState();
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
    _imageBytes = const Base64Decoder().convert(widget.objfigees.base64Figees);
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
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else if (_isPaused) {
        await _audioPlayer.play();
      } else {
        Uint8List bytes =
            const Base64Decoder().convert(widget.objfigees.base64MultiFigees);
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
      print('Error al buscar en el audio: $e');
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
      body: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 260,
                child: ClipRRect(
                  child: Image.memory(
                    _imageBytes,
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
                    Text(
                      widget.objfigees.prenomFigees,
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'DidotBold',
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      textAlign: TextAlign.center,
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
              child: Column(
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Color.fromARGB(255, 89, 135, 172),
                      inactiveTrackColor:
                          const Color.fromARGB(255, 46, 161, 88),
                      trackHeight: 2.0,
                      thumbColor: const Color.fromARGB(255, 255, 255, 255),
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 7),
                      overlayColor: const Color.fromARGB(255, 0, 0, 0).withAlpha(22),
                    
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(_position),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const FaIcon(FontAwesomeIcons.backwardStep,
                                color: Colors.white, size: 13),
                            onPressed: () {
                              _seekAudio(
                                  _position - const Duration(seconds: 5));
                            },
                          ),
                          IconButton(
                            icon: FaIcon(
                              _isPlaying
                                  ? FontAwesomeIcons.pause
                                  : FontAwesomeIcons.play,
                              color: Colors.white,
                              size: 13,
                            ),
                            onPressed: _playPauseAudio,
                          ),
                          IconButton(
                            icon: const FaIcon(FontAwesomeIcons.forwardStep,
                                color: Colors.white, size: 13),
                            onPressed: () {
                              _seekAudio(
                                  _position + const Duration(seconds: 5));
                            },
                          ),
                        ],
                      ),
                      Text(
                        _formatDuration(_duration),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "Définition: ${widget.objfigees.definitionFigees.split('T')[0]}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'DidotRegular',
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      "Origine: ${widget.objfigees.originFigees.split('T')[0]}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'DidotRegular',
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
