import 'package:chat_app/screens/register_screen.dart';
import 'package:chat_app/screens/signin_screen.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/widgets/my_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String screenRoute = 'welcome_screen';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Image.asset('assets/images/chat_icon.jpeg'),
                ),
                const Text('MessageMe',
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Color(0xff2e386b)),
                ),

              ],
            ),
            const SizedBox(height: 20),
            MyButton(
              color: Colors.yellow[900]!,
              title: 'Sign in',
              onPressed: (){
                Navigator.pushNamed(context, SignInScreen.screenRoute);
              },
            ),
            MyButton(
              color: Colors.blue[800]!,
              title: 'Register',
              onPressed: (){
                Navigator.pushNamed(context, RegisterScreen.screenRoute);
              },
            ),

          ],
        ),
      ),
    );
  }
}



