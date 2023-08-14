import 'package:flutter/material.dart';
import 'package:podcast_app/screens/home_screen.dart';
import 'screens/auth_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './providers/auth_provider.dart';
import './screens/intro_screen.dart';
import 'package:just_audio_background/just_audio_background.dart';

void main() async {
  // await JustAudioBackground.init(
  //   androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
  //   androidNotificationChannelName: 'Audio playback',
  //   androidNotificationOngoing: true,
  // );
  runApp(const ProviderScope( child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final token = ref.watch(authProvider);

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromRGBO(34, 40, 49, 1)
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(
              width: 2,
              color: Color.fromRGBO(0, 173, 181, 1)
            ),

          ),
          prefixIconColor: const Color.fromRGBO(0, 173, 181, 1),
          suffixIconColor: const Color.fromRGBO(0, 173, 181, 1),
          // labelStyle: TextStyle(
          //   color: Color.fromRGBO(0, 173, 181, 1)
          // )
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color.fromRGBO(34, 40, 49, 1),
          unselectedItemColor: Colors.white,
          selectedItemColor: Color.fromRGBO(238, 238, 238, 1),
          type: BottomNavigationBarType.fixed,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            backgroundColor: const Color.fromRGBO(0, 173, 181, 1)
          )
        )
      ),
      home: const IntroScreen(),
    );
  }
}
