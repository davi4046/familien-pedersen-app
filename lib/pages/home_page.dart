import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// tmp
import 'package:familien_pedersen_app/pages/foodplan_creation_page.dart';

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
            Text(user.displayName!),
            ElevatedButton(
                onPressed: () => FirebaseAuth.instance.signOut(),
                child: const Text('Log ud'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FoodplanCreationPage()),
                );
              },
              child: const Text('Opret madplan'),
            ),
          ],
        ),
      ),
    );
  }
}
