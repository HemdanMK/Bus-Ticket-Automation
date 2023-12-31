import 'package:busti007/screens/singup_conductor.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'c_home.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController busIDController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login(BuildContext context) async {
    try {
      String busID = busIDController.text;
      String password = passwordController.text;

      // Check if the provided bus ID exists in Firestore
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('conductors')
          .where('busID', isEqualTo: busID)
          .get();

      if (querySnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid bus ID or password'),
          ),
        );
        return;
      }

      // Get the first document from the query result
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = querySnapshot.docs.first;

      // Verify the password
      String storedPassword = documentSnapshot.get('password');
      if (password != storedPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid bus ID or password'),
          ),
        );
        return;
      }

      // Login successful
      // Perform additional actions if needed

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ConductorHomePage(busID: busIDController.text)),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: ${error.toString()}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conductor Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: busIDController,
              decoration: InputDecoration(labelText: 'Bus ID'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {
                login(context);
              },
              child: Text('Login'),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpConductor()),
                );
              },
              child: Text(
                'Don\'t have an account? Sign up',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
