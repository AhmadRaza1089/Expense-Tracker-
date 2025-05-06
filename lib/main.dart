import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track/firebase/firebase_options.dart';
import 'package:track/home/bloc/app_bloc_obsever.dart';
import 'package:track/screen/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Bloc.observer = AppBlocObserver();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          // primary: Color(0x0000128b),
          // secondary: Color(0x00003f88),
          // tertiary: Color(0x00001fdd),
        ),
      ),
      home: Signup(),
    );
  }
}
