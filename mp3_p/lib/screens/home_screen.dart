import 'package:flutter/material.dart';
import '../models/song.dart';
import '../services/audio_service.dart';
import '../services/download_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DownloadService _downloadService = DownloadService();
  final AudioService _audioService = AudioService();
  List<Song> _songs = [];
  bool _isLoading = true;
  String? _error;
  Duration _currentPosition = Duration.zero;
  Duration? _totalDuration;
  bool _isBuffering = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
    _setupAudioListeners();
  }

  void _setupAudioListeners() {
    _audioService.positionStream.listen((position) {
      if (position != null) {
        setState(() {
          _currentPosition = position;
        });
      }
    });

    _audioService.durationStream.listen((duration) {
      setState(() {
        _totalDuration = duration;
      });
    });

    _audioService.bufferingStream.listen((buffering) {
      setState(() {
        _isBuffering = buffering;
      });
    });
  }

  Future<void> _initializeApp() async {
    try {
      await _audioService.initialize();
      final songs = await _downloadService.fetchPlaylist();
      setState(() {
        _songs = songs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _downloadSong(Song song) async {
    try {
      await _downloadService.downloadSong(song, (progress) {
        setState(() {
          song.downloadProgress = progress;
        });
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao baixar: $e')),
      );
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: theme.colorScheme.primary,
          ),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red[400], size: 40),
              const SizedBox(height: 16),
              Text('$_error', style: theme.textTheme.bodyMedium),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _initializeApp,
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spotify Dos Crias'),
        centerTitle: true,
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
        elevation: 0,
      ),
      body: Container(
        color: isDark ? Colors.grey[850] : Colors.grey[100],
        child: Column(
          children: [
            if (_audioService.currentSong != null)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      _audioService.currentSong!.title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _audioService.currentSong!.author,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Slider(
                      value: _currentPosition.inSeconds.toDouble(),
                      max: _totalDuration?.inSeconds.toDouble() ?? 0,
                      activeColor: theme.colorScheme.primary,
                      inactiveColor: Colors.grey[300],
                      onChanged: (value) {
                        _audioService.seekTo(Duration(seconds: value.toInt()));
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(_currentPosition),
                            style: TextStyle(
                              color:
                                  isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              _audioService.isPlaying
                                  ? Icons.pause_circle_filled
                                  : Icons.play_circle_filled,
                              size: 40,
                              color: theme.colorScheme.primary,
                            ),
                            onPressed: () {
                              if (_audioService.isPlaying) {
                                _audioService.pause();
                              } else {
                                _audioService.play(_audioService.currentSong!);
                              }
                              setState(() {});
                            },
                          ),
                          Text(
                            _formatDuration(_totalDuration ?? Duration.zero),
                            style: TextStyle(
                              color:
                                  isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _songs.length,
                itemBuilder: (context, index) {
                  final song = _songs[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    color: isDark ? Colors.grey[800] : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            theme.colorScheme.primary.withOpacity(0.1),
                        child: Icon(
                          song.isDownloaded ? Icons.music_note : Icons.download,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      title: Text(
                        song.title,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        '${song.author} • ${song.duration}',
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                      trailing: song.isDownloading
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                value: song.downloadProgress,
                                color: theme.colorScheme.primary,
                              ),
                            )
                          : IconButton(
                              icon: Icon(
                                song.isDownloaded
                                    ? Icons.play_arrow
                                    : Icons.download,
                                color: theme.colorScheme.primary,
                              ),
                              onPressed: () {
                                if (song.isDownloaded) {
                                  _audioService.play(song);
                                } else {
                                  _downloadSong(song);
                                }
                              },
                            ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}
