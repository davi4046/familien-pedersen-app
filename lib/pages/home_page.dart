import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'signin_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Familien Pedersen App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(user.email!),
            ElevatedButton(
                onPressed: () => FirebaseAuth.instance.signOut(),
                child: const Text('Log ud'),
            ),
          ],
        ),
      ),
    );
  }
}
