import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 183, 208, 24)),
        useMaterial3: true,
      ),
      home: const MainPage(title: "Contacoccole"),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});
  final String title;
  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  String currentTime = "00:00:00";
  Timer? countdownTimer;
  int remainingTime = 0;
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    startWaitingPeriod();
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    audioPlayer.dispose();
    super.dispose();
  }

  void startRandomCountdown() {
    remainingTime = 180;
    playAudio('start.mp3');

    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
          currentTime = formatTime(remainingTime);
        } else {
          timer.cancel();
          playAudio('end.mp3');
          currentTime = "00:00:00";
          remainingTime = 0;
          startWaitingPeriod();
        }
      });
    });
  }

  void startWaitingPeriod() {
    Timer(Duration(seconds: 120), () {
      startRandomCountdown();
    });
  }

  String formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void playAudio(String fileName) async {
    await audioPlayer.play(AssetSource(fileName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.bold
          )
        ),
        leading: Image.asset("images/frog_icon.png"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
                'images/hug.gif'
            ),
            SizedBox(height: 50),
            Text(
              currentTime,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 70,
              )
            ),
            SizedBox(height: 50),
            Image.asset(
                'images/frog.png',
              width: 256,
              height: 256
            ),
          ],
        ),
      ),
    );
  }
}
