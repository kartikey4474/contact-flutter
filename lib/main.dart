import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_todo/constants.dart';
import 'package:flutter_bloc_todo/contact_bloc/contact_bloc.dart';
import 'package:flutter_bloc_todo/firebase_options.dart';
import 'package:flutter_bloc_todo/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contact App',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          background: Colors.white,
          onBackground: Colors.black,
          primary: Palette.kOrangeColor,
          onPrimary: Colors.black,
          secondary: Colors.lightGreen,
          onSecondary: Colors.white,
        ),
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ContactBloc>(
            create: (context) => ContactBloc()..add(ContactStarted()),
          ),
        ],
        child: const HomeScreen(),
      ),
    );
  }
}
