import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:wandastock/generated/app_localizations.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  Future<int> _getTotalProduits() async {
    final user = FirebaseAuth.instance.currentUser;
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('products')
        .get();
    return snapshot.docs.length;
  }

  Future<int> _getTotalVentes() async {
    final user = FirebaseAuth.instance.currentUser;
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('sales')
        .get();
    return snapshot.docs.length;
  }

  Future<int> _getTotalReapprovisionnements() async {
    final user = FirebaseAuth.instance.currentUser;
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('restocks')
        .get();
    return snapshot.docs.length;
  }

  Future<double> _getTotalVentesAujourdHui() async {
    final user = FirebaseAuth.instance.currentUser;
    final today = DateTime.now();
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('sales')
        .get();

    double total = 0;
    for (var doc in snapshot.docs) {
      final data = doc.data();
      final date = (data['date'] as Timestamp).toDate();
      if (date.year == today.year && date.month == today.month && date.day == today.day) {
        total += (data['total'] ?? 0).toDouble();
      }
    }
    return total;
  }

  Future<double> _getTotalVentesSemaine() async {
    final user = FirebaseAuth.instance.currentUser;
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('sales')
        .get();

    double total = 0;
    for (var doc in snapshot.docs) {
      final data = doc.data();
      final date = (data['date'] as Timestamp).toDate();
      if (date.isAfter(weekAgo)) {
        total += (data['total'] ?? 0).toDouble();
      }
    }
    return total;
  }

  Future<List<Map<String, dynamic>>> _getTopProduitsVendus() async {
    final user = FirebaseAuth.instance.currentUser;
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('sales')
        .get();

    final Map<String, num> produitQuantites = {};
    for (var doc in snapshot.docs) {
      final data = doc.data();
      final items = List<Map<String, dynamic>>.from(data['items'] ?? []);
      for (var item in items) {
        final nom = item['nom'];
        final quantite = item['quantite'] ?? 0;
        produitQuantites[nom] = (produitQuantites[nom] ?? 0) + quantite;
      }
    }

    final sorted = produitQuantites.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(3).map((e) => {'nom': e.key, 'quantite': e.value}).toList();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.activitySummary,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            FutureBuilder(
              future: Future.wait([
                _getTotalProduits(),
                _getTotalVentes(),
                _getTotalReapprovisionnements(),
                _getTotalVentesAujourdHui(),
                _getTotalVentesSemaine(),
                _getTopProduitsVendus(),
              ]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.hasError) {
                  return Text(t.loadingError);
                }
                final data = snapshot.data as List<dynamic>;
                final topProduits = data[5] as List<Map<String, dynamic>>;

                return Column(
                  children: [
                    _buildStatCard(t.products, data[0], Colors.blue),
                    _buildStatCard(t.sales, data[1], Colors.green),
                    _buildStatCard(t.restocks, data[2], Colors.orange),
                    _buildStatCard(t.totalSoldToday, '${data[3].toStringAsFixed(0)} FCFA', Colors.purple),
                    _buildStatCard(t.totalSoldThisWeek, '${data[4].toStringAsFixed(0)} FCFA', Colors.teal),
                    const SizedBox(height: 20),
                    Text(t.top3SoldProducts, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ...topProduits.map((prod) => ListTile(
                          title: Text(prod['nom']),
                          trailing: Text('${prod['quantite']} ${t.sold}'),
                        )),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, dynamic value, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(Icons.bar_chart, color: color),
        title: Text(title),
        trailing: Text('$value', style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
