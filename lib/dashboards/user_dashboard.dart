import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

  @override
Widget build(BuildContext context) {
  final ref = FirebaseFirestore.instance
      .collection('app_data/public_content/items')
      .orderBy('timestamp', descending: true);

  return Scaffold(
    backgroundColor: const Color(0xFFF5F9F7),
    appBar: AppBar(
      title: const Text('User Dashboard'),
      backgroundColor: Colors.green.shade700,
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.pop(context);
          },
        ),
      ],
    ),
    body: StreamBuilder(
      stream: ref.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        if (docs.isEmpty) {
          return const Center(child: Text("No content available"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: docs.length,
          itemBuilder: (_, i) {
            final doc = docs[i];

            return Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFE8F5E9),
                      Color(0xFFA5D6A7),
                    ], // Light to soft green
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  leading:
                      doc.data().containsKey('imageUrl') &&
                          doc['imageUrl'] != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            doc['imageUrl'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(Icons.image_not_supported, size: 50),
                  title: Text(
                    doc.data().containsKey('title') ? doc['title'] : 'No Title',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    doc.data().containsKey('description')
                        ? doc['description']
                        : 'No Description',
                  ),
                ),
              );

          },
        );
      },
    ),
  );
}
}
