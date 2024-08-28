import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio Recorder and Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AudioPage(),
    );
  }
}

class AudioPage extends StatefulWidget {
  @override
  _AudioPageState createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> with TickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  bool _isPlaying = false;
  String? _filePath;
  Duration _recordingDuration = Duration.zero;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  Timer? _timer;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _recorder.dispose();
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    final bool isPermissionGranted = await _recorder.hasPermission();
    if (!isPermissionGranted) {
      return;
    }

    final directory = await getApplicationDocumentsDirectory();
    String fileName = 'recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
    _filePath = '${directory.path}/$fileName';

    const config = RecordConfig(
      encoder: AudioEncoder.aacLc,
      sampleRate: 44100,
      bitRate: 128000,
    );

    await _recorder.start(config, path: _filePath!);
    setState(() {
      _isRecording = true;
      _recordingDuration = Duration.zero;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordingDuration =
            Duration(seconds: _recordingDuration.inSeconds + 1);
      });
    });
  }

  Future<void> _stopRecording() async {
    final path = await _recorder.stop();
    setState(() {
      _isRecording = false;
      _timer?.cancel();
    });
  }

  Future<void> _playRecording() async {
    if (_filePath != null) {
      await _audioPlayer.setFilePath(_filePath!);
      _totalDuration = _audioPlayer.duration ?? Duration.zero;
      _audioPlayer.play();
      setState(() {
        _isPlaying = true;
      });

      _audioPlayer.positionStream.listen((position) {
        setState(() {
          _currentPosition = position;
        });
      });

      _audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed ||
            state.playing == false) {
          setState(() {
            _isPlaying = false;
          });
        }
      });
    }
  }

  Future<void> _pauseRecording() async {
    await _audioPlayer.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  Future<void> _deleteRecording() async {
    if (_filePath != null) {
      final file = File(_filePath!);
      if (await file.exists()) {
        await file.delete();
        setState(() {
          _filePath = null;
          _currentPosition = Duration.zero;
          _totalDuration = Duration.zero;
        });
      }
    }
  }

  Future<void> _sendRecording() async {
    if (_filePath != null) {
      final file = File(_filePath!);
      final uri = Uri.parse('upload');
      final request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        print('Archivo subido exitosamente');
      } else {
        print('Error al subir el audio');
      }
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
      appBar: AppBar(
        title: const Text('Modern Audio Recorder'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isRecording ? Icons.mic : Icons.mic_none,
              size: 100,
              color: _isRecording ? Colors.red : Colors.blue,
            ),
            if (_isRecording)
              FadeTransition(
                opacity: _controller,
                child: const Text(
                  'Grabando...',
                  style: TextStyle(color: Colors.red, fontSize: 24),
                ),
              ),
            const SizedBox(height: 20),
            Text(
              _isRecording
                  ? _formatDuration(_recordingDuration)
                  : _formatDuration(_currentPosition),
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _isRecording ? null : _startRecording,
                  icon: Icon(Icons.mic),
                  color: Colors.blue,
                  iconSize: 50,
                ),
                const SizedBox(width: 20),
                IconButton(
                  onPressed: _isRecording ? _stopRecording : null,
                  icon: Icon(Icons.stop),
                  color: Colors.red,
                  iconSize: 50,
                ),
              ],
            ),
            const SizedBox(height: 20),
            IconButton(
              onPressed: !_isRecording
                  ? (_isPlaying ? _pauseRecording : _playRecording)
                  : null,
              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
              color: Colors.green,
              iconSize: 50,
            ),
            Slider(
              value: _currentPosition.inSeconds.toDouble(),
              max: _totalDuration.inSeconds.toDouble(),
              onChanged: (value) {
                setState(() {
                  _currentPosition = Duration(seconds: value.toInt());
                });
                _audioPlayer.seek(_currentPosition);
              },
            ),
            const SizedBox(height: 20),
            if (_filePath != null)
              IconButton(
                onPressed: _deleteRecording,
                icon: const Icon(Icons.delete),
                color: Colors.orange,
                iconSize: 50,
              ),
            const SizedBox(height: 20),
            IconButton(
              onPressed: _sendRecording,
              icon: Icon(Icons.send),
              color: Colors.purple,
              iconSize: 50,
            ),
          ],
        ),
      ),
    );
  }
}
