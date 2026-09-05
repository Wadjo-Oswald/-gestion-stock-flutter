// lib/pages/admin_dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class AdminDashboardPage extends StatefulWidget {
  final void Function(Locale) onLocaleChange;

  const AdminDashboardPage({super.key, required this.onLocaleChange});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection('users');

  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _isOnline = (result != ConnectivityResult.none);
      });
    });
  }

  Future<void> _checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    setState(() {
      _isOnline = (result != ConnectivityResult.none);
    });
  }

  Future<void> _toggleRole(String userId, String currentRole) async {
    try {
      final newRole = currentRole == 'admin' ? 'user' : 'admin';
      await usersRef.doc(userId).update({'role': newRole});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rôle modifié en $newRole')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors du changement de rôle')),
      );
    }
  }

  Future<void> _toggleBlock(String userId, bool isBlocked) async {
    try {
      await usersRef.doc(userId).update({'isBlocked': !isBlocked});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isBlocked ? 'Utilisateur débloqué' : 'Utilisateur bloqué'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    }
  }

  Future<void> _deleteUser(String userId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Voulez-vous vraiment supprimer cet utilisateur ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await usersRef.doc(userId).delete();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Utilisateur supprimé')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de la suppression')),
        );
      }
    }
  }

  Future<void> _confirmSignOut() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Déconnexion"),
        content: const Text("Voulez-vous vraiment vous déconnecter ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Oui"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseAuth.instance.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de bord Admin'),
        actions: [
          Icon(
            _isOnline ? Icons.cloud_done : Icons.cloud_off,
            color: _isOnline ? Colors.green : Colors.grey,
          ),
          // Menu pour changer la langue
          PopupMenuButton<Locale>(
            onSelected: (locale) {
              widget.onLocaleChange(locale);
            },
            icon: const Icon(Icons.language),
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: Locale('fr'),
                child: Text('Français'),
              ),
              PopupMenuItem(
                value: Locale('en'),
                child: Text('English'),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Déconnexion',
            onPressed: _confirmSignOut,
          ),
        ],
      ),
      body: Column(
        children: [
          if (!_isOnline)
            Container(
              color: Colors.red[400],
              padding: const EdgeInsets.all(8),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Mode hors-ligne. Les actions seront synchronisées plus tard.',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: usersRef.orderBy('createdAt').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Erreur: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final users = snapshot.data!.docs;
                if (users.isEmpty) {
                  return const Center(child: Text('Aucun utilisateur trouvé.'));
                }

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final userDoc = users[index];
                    final data = userDoc.data() as Map<String, dynamic>;

                    final email = data['email'] ?? 'Email inconnu';
                    final enterprise = data['enterpriseName'] ?? '-';
                    final role = data['role'] ?? 'user';
                    final isBlocked = data['isBlocked'] ?? false;

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: Icon(
                          role == 'admin' ? Icons.admin_panel_settings : Icons.person,
                          color: role == 'admin' ? Colors.red : Colors.blue,
                        ),
                        title: Text(email),
                        subtitle: Text(
                            'Entreprise: $enterprise\nRôle: $role\nStatut: ${isBlocked ? "Bloqué" : "Actif"}'),
                        isThreeLine: true,
                        trailing: SizedBox(
                          width: 170,
                          child: Wrap(
                            spacing: 4,
                            children: [
                              ElevatedButton(
                                onPressed: () => _toggleRole(userDoc.id, role),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      role == 'admin' ? Colors.orange : Colors.green,
                                ),
                                child: Text(role == 'admin' ? 'Rétrograder' : 'Promouvoir'),
                              ),
                              OutlinedButton(
                                onPressed: () => _toggleBlock(userDoc.id, isBlocked),
                                child: Text(isBlocked ? 'Débloquer' : 'Bloquer'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: isBlocked ? Colors.green : Colors.red,
                                ),
                              ),
                              IconButton(
                                onPressed: () => _deleteUser(userDoc.id),
                                icon: const Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
