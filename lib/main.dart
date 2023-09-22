import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/register_screen.dart';
import 'package:chat_app/screens/signin_screen.dart';
import 'package:chat_app/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: _auth.currentUser != null
          ? ChatScreen.screenRoute
          : WelcomeScreen.screenRoute,
      routes: {
        WelcomeScreen.screenRoute: (context)=> const WelcomeScreen(),
        SignInScreen.screenRoute: (context)=> const SignInScreen(),
        RegisterScreen.screenRoute: (context)=> const RegisterScreen(),
        ChatScreen.screenRoute: (context)=> const ChatScreen(),
      },
    );
  }
}