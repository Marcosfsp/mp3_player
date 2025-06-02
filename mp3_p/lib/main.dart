import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/audio_service.dart';
import 'services/download_service.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AudioService>(create: (_) => AudioService()),
        Provider<DownloadService>(create: (_) => DownloadService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MP3 Player',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.light(
            primary: const Color(0xFF6200EA), // Roxo vibrante
            onPrimary: Colors.white,
            secondary: const Color(0xFF03DAC6), // Ciano
            onSecondary: Colors.black,
            surface: const Color(0xFFFAFAFA),
            background: const Color(0xFFF5F5F5),
            error: const Color(0xFFB00020),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF6200EA),
            foregroundColor: Colors.white,
            elevation: 4,
            centerTitle: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
            ),
          ),
          cardTheme: CardThemeData(
            elevation: 6,
            margin: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
            shadowColor: Colors.purple.withOpacity(0.2),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFF6200EA),
            foregroundColor: Colors.white,
            elevation: 8,
            shape: CircleBorder(),
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.dark(
            primary: const Color(0xFFBB86FC), // Roxo claro
            onPrimary: Colors.black,
            secondary: const Color(0xFF03DAC6), // Ciano
            onSecondary: Colors.black,
            surface: const Color(0xFF121212),
            background: const Color(0xFF000000),
            error: const Color(0xFFCF6679),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1E1E1E),
            foregroundColor: Colors.white,
            elevation: 4,
            centerTitle: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
            ),
          ),
          cardTheme: CardThemeData(
            elevation: 6,
            margin: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(
                color: Colors.grey.shade800,
                width: 1,
              ),
            ),
            shadowColor: Colors.purple.withOpacity(0.3),
            color: const Color(0xFF1E1E1E),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFFBB86FC),
            foregroundColor: Colors.black,
            elevation: 8,
            shape: CircleBorder(),
          ),
        ),
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}
