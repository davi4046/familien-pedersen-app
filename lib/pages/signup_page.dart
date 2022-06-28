import 'package:familien_pedersen_app/pages/signin_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Opret konto'),
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
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Gentag adgangskode',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                child: const Text(
                  'Opret konto',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 16),
              RichText(
                  text: TextSpan(
                      text: 'Allerede bruger? ',
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const SignInPage()),
                                      (Route<dynamic> route) => false);
                            },
                          text: 'Log ind',
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
  }
}
