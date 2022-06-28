import 'package:familien_pedersen_app/pages/signup_page.dart';
import 'package:familien_pedersen_app/main.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Log ind'),
        ),
        body: Center(
          child: SizedBox(
            width: 256,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Adgangskode',
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: signIn,
                  child: const Text(
                    'Log ind',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 16),
                RichText(
                    text: TextSpan(
                        text: 'Ny bruger? ',
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const SignUpPage()),
                                (Route<dynamic> route) => false);
                          },
                        text: 'Opret konto',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    ])),
              ],
            ),
          ),
        ),
      );

  Future signIn() async {
    showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()));

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
