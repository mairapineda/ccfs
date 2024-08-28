import 'dart:typed_data';
import 'package:ccfs/app/widgets/utils/slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';

class AudioPlayerWidget extends StatefulWidget {
  final Uint8List archivo;

  const AudioPlayerWidget({required this.archivo, Key? key}) : super(key: key);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  bool _isPlaying = false;
  final _audioPlayer = AudioPlayer();
  double _currentSliderValue = 0.0;
  @override
  void initState() {
    super.initState();

    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _currentSliderValue = position.inMilliseconds.toDouble();
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
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
                  color: const Color.fromARGB(255, 0, 80, 74),
                  size: 26,
                ),
                onPressed: () async {
                  try {
                    final audioUri = Uri.dataFromBytes(widget.archivo,
                        mimeType: 'audio/mpeg');
                    await _audioPlayer
                        .setAudioSource(AudioSource.uri(audioUri));
                    if (_isPlaying) {
                      _audioPlayer.pause();
                    } else {
                      _audioPlayer.play();
                    }
                    setState(() {
                      _isPlaying = !_isPlaying;
                    });
                  } catch (e) {
                    print('Error al reproducir el audio: $e');
                  }
                },
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: const Color.fromARGB(255, 206, 230, 214),
                    inactiveTrackColor: const Color.fromARGB(255, 129, 111, 51),
                    trackHeight: 5,
                    thumbShape: SliderComponentShape.noThumb,
                    overlayColor:
                        const Color.fromARGB(255, 255, 255, 255).withAlpha(22),
                    trackShape: RoundedTrackShape(),
                  ),
                  child: Slider(
                    value: _currentSliderValue.clamp(
                        0.0,
                        _audioPlayer.duration?.inMilliseconds.toDouble() ??
                            1.0),
                    min: 0.0,
                    max:
                        _audioPlayer.duration?.inMilliseconds.toDouble() ?? 1.0,
                    onChanged: (value) async {
                      await _audioPlayer
                          .seek(Duration(milliseconds: value.toInt()));
                      setState(() {
                        _currentSliderValue = value;
                      });
                    },
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(MdiIcons.turtle,
                    color: Color.fromARGB(255, 0, 80, 74), size: 26),
                onPressed: () async {
                  try {
                    await _audioPlayer.setSpeed(0.7);
                  } catch (e) {
                    print('Error al cambiar la velocidad: $e');
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
