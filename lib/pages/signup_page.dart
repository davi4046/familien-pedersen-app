import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:familien_pedersen_app/main.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  final VoidCallback onClickedSignIn;

  const SignUpPage({
    Key? key,
    required this.onClickedSignIn,
  }) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Opret konto'),
        ),
        body: Center(
          child: SizedBox(
            width: 256,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Kaldenavn',
                    ),
                    validator: (value) =>
                        value == null ? 'Feltet må ikke være tomt' : null,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                    validator: (email) =>
                        email != null && !EmailValidator.validate(email)
                            ? 'Ugyldig email'
                            : null,
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Adgangskode',
                    ),
                    validator: (value) => value != null && value.length < 8
                        ? 'Din adgangskode skal være på min. 8 tegn'
                        : null,
                  ),
                  TextFormField(
                    controller: repeatPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Gentag adgangskode',
                    ),
                    validator: (value) => value != passwordController.text
                        ? 'Indtastet adgangskoder er ikke ens'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: signUp,
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
                            ..onTap = widget.onClickedSignIn,
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
        ),
      );

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()));

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          )
          .then((value) =>
              value.user?.updateDisplayName(nameController.text.trim()));
    } on FirebaseAuthException catch (e) {
      print(e);

      utilsInstance.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
