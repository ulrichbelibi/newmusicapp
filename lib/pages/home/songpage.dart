import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../models/song.dart';

class SongPage extends StatefulWidget {
  final Song song;

  const SongPage({super.key, required this.song});

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  late final AudioPlayer _audioPlayer;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration?>? _durationSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isPlaying = false;
  bool _isLoading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _positionSubscription = _audioPlayer.positionStream.listen((position) {
      if (mounted) setState(() => _position = position);
    });
    _durationSubscription = _audioPlayer.durationStream.listen((duration) {
      if (mounted && duration != null) setState(() => _duration = duration);
    });
    _playerStateSubscription = _audioPlayer.playerStateStream.listen((state) {
      if (mounted) setState(() => _isPlaying = state.playing);
    });
    _loadAudio();
  }

  Future<void> _loadAudio() async {
    try {
      await _audioPlayer.setAsset(widget.song.audioUrl);
      if (mounted) setState(() => _isLoading = false);
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _loadError = 'Impossible de charger ce fichier audio.';
        });
      }
      debugPrint(
        'Erreur de chargement audio (${widget.song.audioUrl}): $error',
      );
    }
  }

  Future<void> _togglePlayback() async {
    try {
      if (_audioPlayer.playing) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play();
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('La lecture audio a échoué.')),
        );
      }
      debugPrint('Erreur de lecture audio: $error');
    }
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.song.titre,
          style: const TextStyle(fontFamily: 'ebrima'),
        ),
        backgroundColor: const Color.fromARGB(255, 250, 139, 109),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.asset(
              widget.song.imageUrl,
              width: 250,
              height: 250,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 30),
          Text(
            widget.song.titre,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.pink,
            ),
          ),
          Text(
            widget.song.artiste,
            style: const TextStyle(
              fontFamily: 'times new roman',
              color: Color.fromARGB(255, 47, 46, 46),
              fontSize: 23,
            ),
          ),
          const SizedBox(height: 20),
          if (_loadError != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                _loadError!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black),
              ),
            )
          else ...[
            Slider(
              value: _position.inMilliseconds
                  .clamp(0, _duration.inMilliseconds)
                  .toDouble(),
              max: _duration.inMilliseconds > 0
                  ? _duration.inMilliseconds.toDouble()
                  : 1,
              onChanged: _isLoading || _duration == Duration.zero
                  ? null
                  : (value) => _audioPlayer.seek(
                      Duration(milliseconds: value.round()),
                    ),
            ),
            Text(
              '${_formatDuration(_position)} / ${_formatDuration(_duration)}',
              style: const TextStyle(color: Colors.black),
            ),
            IconButton(
              icon: Icon(
                _isLoading
                    ? Icons.hourglass_empty
                    : _isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
              ),
              iconSize: 60,
              color: Colors.pink,
              onPressed: _isLoading ? null : _togglePlayback,
            ),
          ],
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
