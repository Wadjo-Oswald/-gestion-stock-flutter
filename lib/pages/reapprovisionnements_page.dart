// lib/pages/reapprovisionnements_page.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:wandastock/generated/app_localizations.dart';

class ReapprovisionnementsPage extends StatelessWidget {
  const ReapprovisionnementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Center(
        child: Text(t.userNotLoggedIn),
      );
    }

    final restocksStream = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('restocks')
        .orderBy('date', descending: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text(t.restockHistory),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: restocksStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('${t.error}: ${snapshot.error}'));
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return Center(
              child: Text(t.noRestocksFound),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              final String nom = data['nom'] ?? t.unknownProduct;
              final int ancienneQuantite = data['ancienneQuantite'] ?? 0;
              final int nouvelleQuantite = data['nouvelleQuantite'] ?? 0;
              final Timestamp timestamp = data['date'] ?? Timestamp.now();
              final DateTime date = timestamp.toDate();

              final dateFormatted = DateFormat('dd/MM/yyyy – HH:mm').format(date);

              return ListTile(
                title: Text(nom, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                  '${t.oldQuantity}: $ancienneQuantite\n${t.newQuantity}: $nouvelleQuantite',
                ),
                trailing: Text(dateFormatted),
                isThreeLine: true,
              );
            },
          );
        },
      ),
    );
  }
}
