// lib/pages/ajouter_produit.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AjouterProduitPage extends StatefulWidget {
  const AjouterProduitPage({super.key});

  @override
  State<AjouterProduitPage> createState() => _AjouterProduitPageState();
}

class _AjouterProduitPageState extends State<AjouterProduitPage> {
  final TextEditingController nomController = TextEditingController();
  final TextEditingController prixController = TextEditingController();
  final TextEditingController quantiteController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> ajouterProduit() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Utilisateur non connecté")),
        );
        return;
      }

      final produit = {
        'nom': nomController.text,
        'prix': double.parse(prixController.text),
        'quantite': int.parse(quantiteController.text),
        'date': Timestamp.now(),
      };

      await FirebaseFirestore.instance
    .collection('users')
    .doc(user.uid)
    .collection('products')
    .add(produit);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Produit ajouté avec succès")),
      );

      nomController.clear();
      prixController.clear();
      quantiteController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un produit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nomController,
                decoration: const InputDecoration(labelText: "Nom du produit"),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: prixController,
                decoration: const InputDecoration(labelText: "Prix"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: quantiteController,
                decoration: const InputDecoration(labelText: "Quantité"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Champ requis' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: ajouterProduit,
                child: const Text("Ajouter"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
