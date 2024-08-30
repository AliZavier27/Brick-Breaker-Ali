import 'dart:developer' as dev; 
 
import 'package:brick_breaker/src/widgets/game_app.dart';
import 'package:flutter/foundation.dart'; 
import 'package:flutter/material.dart'; 
import 'package:logging/logging.dart'; 
 
import 'audio/audio_controller.dart'; 
 
void main() async { 
  
  Logger.root.level = kDebugMode ? Level.FINE : Level.INFO; 
  Logger.root.onRecord.listen((record) { 
    dev.log( 
      record.message, 
      time: record.time, 
      level: record.level.value, 
      name: record.loggerName, 
      zone: record.zone, 
      error: record.error, 
      stackTrace: record.stackTrace, 
    ); 
  }); 
 
  WidgetsFlutterBinding.ensureInitialized(); 
 
  final audioController = AudioController(); 
  await audioController.initialize(); 
 
  runApp( 
    MyApp(audioController: audioController), 
  ); 
} 
 
class MyApp extends StatelessWidget { 
  const MyApp({required this.audioController, super.key}); 
 
  final AudioController audioController; 
 
  @override 


  Widget build(BuildContext context) { 
    runApp (const GameApp());
    return MaterialApp( 
      title: 'Flutter SoLoud Demo', 
      theme: ThemeData( 
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown), 
        useMaterial3: true, 
      ), 
      home: MyHomePage(audioController: audioController), 
    ); 
  } 
} 
 
class MyHomePage extends StatefulWidget { 
  const MyHomePage({super.key, required this.audioController}); 
 
  final AudioController audioController; 
 
  @override 
  State<MyHomePage> createState() => _MyHomePageState(); 
} 
 
class _MyHomePageState extends State<MyHomePage> { 
  static const _gap = SizedBox(height: 16); 
 
  bool filterApplied = false; 
  @override  
  void initState() {  
    super.initState();  
    // Start the music automatically when the app starts  
    widget.audioController.playSound('assets/music/looped-song.ogg');  
  } 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar(title: const Text('Flutter SoLoud Demo')), 
      body: Center( 
        child: Column( 
          mainAxisAlignment: MainAxisAlignment.center, 
          children: <Widget>[ 
            OutlinedButton( 
              onPressed: () { 
                widget.audioController.playSound('assets/sounds/pew1.mp3'); 
              }, 
              child: const Text('Play Sound'), 
            ), 
            _gap, 
            OutlinedButton( 
              onPressed: () { 
                widget.audioController.startMusic(); 
              }, 
              child: const Text('Start Music'), 
            ), 
            _gap, 
            OutlinedButton( 
              onPressed: () { 
                widget.audioController.fadeOutMusic(); 
              }, 
              child: const Text('Fade Out Music'), 
            ), 
            _gap, 
            Row( 
              mainAxisSize: MainAxisSize.min, 
              children: [ 
                const Text('Apply Filter'), 
                Checkbox( 
                  value: filterApplied, 
                  onChanged: (value) { 
                    setState(() { 
                      filterApplied = value!; 
                    }); 
                    if (filterApplied) { 
                      widget.audioController.applyFilter(); 
                    } else { 
                      widget.audioController.removeFilter(); 
                    } 
                  }, 
                ), 
              ], 
            ), 
          ], 
        ), 
      ), 
    ); 
  } 
}