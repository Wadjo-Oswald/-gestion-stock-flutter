import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:wandastock/generated/app_localizations.dart';

import 'product_page.dart';
import 'sales_history.dart';
import 'dashboard_page.dart';
import 'reapprovisionnements_page.dart';
import 'about_page.dart';

class HomePage extends StatefulWidget {
  final void Function(Locale) onLocaleChange;

  const HomePage({super.key, required this.onLocaleChange});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _isOnline = true;

  final List<Widget> _pages = const [
    ProductPage(),
    SalesHistoryPage(),
    DashboardPage(),
    ReapprovisionnementsPage(),
  ];

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _confirmSignOut() async {
    final t = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.logout),
        content: Text(t.logoutConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(t.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(t.yes),
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
    final t = AppLocalizations.of(context)!;

    final List<String> titles = [
      t.products,
      t.salesHistory,
      t.dashboard,
      t.restock,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_selectedIndex]),
        actions: [
          Icon(
            _isOnline ? Icons.cloud_done : Icons.cloud_off,
            color: _isOnline ? Colors.green : Colors.grey,
          ),
          PopupMenuButton<Locale>(
            onSelected: (locale) {
              Future.microtask(() {
                if (mounted) {
                  widget.onLocaleChange(locale);
                }
              });
            },
            icon: const Icon(Icons.language),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: const Locale('fr'),
                child: Text(t.french),
              ),
              PopupMenuItem(
                value: const Locale('en'),
                child: Text(t.english),
              ),
            ],
          ),
          IconButton(
                icon: const Icon(Icons.info_outline),
                tooltip: t.about,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AboutPage()),
                  );
                },
              ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: t.logout,
            onPressed: _confirmSignOut,
          ),
        ],
      ),
      body: Column(
        children: [
          if (!_isOnline)
            Container(
              color: Colors.red[300],
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.warning, color: Colors.white),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      t.offlineWarning,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.inventory),
            label: t.products,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.receipt),
            label: t.sales,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard),
            label: t.dashboard,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.add_box),
            label: t.restockShort,
          ),
        ],
      ),
    );
    
  }
}
