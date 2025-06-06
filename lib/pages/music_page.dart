import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicPage extends StatefulWidget {
  const MusicPage({super.key});

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  final player = AudioPlayer();
  String? currentTrack;
  bool isPlaying = false;

  final List<String> playlist = [
    'assets/music/lofi1.mp3',
    'assets/music/lofi2.mp3',
    'assets/music/lofi3.mp3',
  ];

  void togglePlayPause(String path) async {
    if (currentTrack != path) {
      await player.stop();
      await player.play(AssetSource(path.replaceFirst('assets/', '')));
      setState(() {
        currentTrack = path;
        isPlaying = true;
      });
    } else {
      if (isPlaying) {
        await player.pause();
        setState(() => isPlaying = false);
      } else {
        await player.resume();
        setState(() => isPlaying = true);
      }
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LoFi Music')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView.builder(
          itemCount: playlist.length,
          itemBuilder: (context, index) {
            final path = playlist[index];
            final name = path.split('/').last;

            return ListTile(
              title: Text(name, style: const TextStyle(color: Colors.white70)),
              trailing: IconButton(
                icon: Icon(
                  currentTrack == path && isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: Colors.tealAccent,
                ),
                onPressed: () => togglePlayPause(path),
              ),
            );
          },
        ),
      ),
    );
  }
}
