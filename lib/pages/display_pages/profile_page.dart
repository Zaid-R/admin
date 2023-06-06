import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            var currentUser = snapshot.data!.docs.firstWhere(
              (element) => element['email'] == FirebaseAuth.instance.currentUser!.email,
            );
            return Container(
              color: Colors.blueGrey[100],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.person_pin,
                        size: 70,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentUser['username'],
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),Text(
                            currentUser['email'],
                            style: const TextStyle(
                                fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 3,
                    color: Colors.grey[600],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextButton(
                        onPressed: () {}, child: const Text('Change email')),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextButton(
                        onPressed: () {}, child: const Text('Change password')),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextButton(
                      onPressed: () async =>
                          await FirebaseAuth.instance.signOut(),
                      child: const Text('Logout'),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}