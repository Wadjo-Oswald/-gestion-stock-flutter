import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:wandastock/generated/app_localizations.dart';

class SalesHistoryPage extends StatelessWidget {
  const SalesHistoryPage({super.key});

  String formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    return '${date.day}/${date.month}/${date.year} à ${date.hour}:${date.minute}';
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        body: Center(child: Text(t.userNotLoggedIn)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(t.salesHistory)),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('sales')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final ventes = snapshot.data?.docs ?? [];

          if (ventes.isEmpty) {
            return Center(child: Text(t.noSalesRecorded));
          }

          return ListView.builder(
            itemCount: ventes.length,
            itemBuilder: (context, index) {
              final vente = ventes[index].data() as Map<String, dynamic>;
              final date = formatDate(vente['date']);
              final total = vente['total'];
              final items = List<Map<String, dynamic>>.from(vente['items']);

              return Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${t.date}: $date', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      ...items.map((item) => Text(
                          '- ${item['nom']} (x${item['quantite']}) : ${item['prix']} FCFA')),
                      const Divider(),
                      Text('${t.total}: $total FCFA', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final enterpriseName = await _getEnterpriseName();
                            _generateAndPrintReceipt(items, total, date, enterpriseName);
                          },
                          icon: const Icon(Icons.print),
                          label: Text(t.print),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/product');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/dashboard');
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/restock');
          }
        },
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: t.products),
          BottomNavigationBarItem(icon: const Icon(Icons.dashboard), label: t.dashboard),
          BottomNavigationBarItem(icon: const Icon(Icons.history), label: t.sales),
          BottomNavigationBarItem(icon: const Icon(Icons.inventory), label: t.restockShort),
        ],
      ),
    );
  }
}

Future<String> _getEnterpriseName() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return 'Entreprise inconnue';

  final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  if (!doc.exists) return 'Entreprise inconnue';

  final data = doc.data();
  return data?['enterpriseName'] ?? 'Entreprise inconnue';
}

void _generateAndPrintReceipt(
    List<Map<String, dynamic>> items, dynamic total, String date, String enterpriseName) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("🧾 Reçu de vente", style: pw.TextStyle(fontSize: 20)),
            pw.SizedBox(height: 10),
            pw.Text("Entreprise : $enterpriseName"),
            pw.Text("Date : $date"),
            pw.Divider(),
            ...items.map((item) => pw.Text(
                "- ${item['nom']} x${item['quantite']} : ${item['prix']} FCFA")),
            pw.Divider(),
            pw.Text("Total : $total FCFA",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ],
        );
      },
    ),
  );

  await Printing.layoutPdf(onLayout: (format) async => pdf.save());
}
