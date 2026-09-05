// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wandastock/generated/app_localizations.dart';
import 'provider/locale_provider.dart';

// Import des pages
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';
import 'pages/admin_dashboard_page.dart';
import 'pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  try {
    await FirebaseFirestore.instance.enablePersistence();
    print('Persistance Firestore activée');
  } catch (e) {
    print('Erreur lors de l’activation de la persistance : \$e');
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => LocaleProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() => _isReady = true);
    });
  }

  void _setLocale(Locale locale) {
    final provider = Provider.of<LocaleProvider>(context, listen: false);
    provider.setLocale(locale);
  }

  void _finishSplash() {
    setState(() => _isReady = true);
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      title: 'WandaStock',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      locale: localeProvider.locale,
      supportedLocales: const [
        Locale('fr'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: _isReady
          ? AuthGate(onLocaleChange: _setLocale)
          : SplashScreen(onInitializationComplete: _finishSplash),
    );
  }
}

class AuthGate extends StatefulWidget {
  final void Function(Locale) onLocaleChange;

  const AuthGate({super.key, required this.onLocaleChange});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool showRegister = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (!snapshot.hasData) {
          if (showRegister) {
            return RegisterPage(
              onLoginClicked: () => setState(() => showRegister = false),
              onLocaleChange: widget.onLocaleChange,
            );
          } else {
            return LoginPage(
              onRegisterClicked: () => setState(() => showRegister = true),
              onLocaleChange: widget.onLocaleChange,
            );
          }
        }

        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('users').doc(snapshot.data!.uid).get(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
              return const Scaffold(body: Center(child: Text('Erreur: utilisateur non trouvé')));
            }

            final data = userSnapshot.data!.data() as Map<String, dynamic>;
            final role = data['role'] ?? 'user';
            final isBlocked = data['isBlocked'] ?? false;

            if (isBlocked) {
              FirebaseAuth.instance.signOut();
              return const Scaffold(
                body: Center(
                  child: Text(
                    "Votre compte est bloqué. Veuillez contacter l’administrateur.",
                    style: TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            if (role == 'admin') {
              return AdminDashboardPage(onLocaleChange: widget.onLocaleChange);
            } else {
              return HomePage(onLocaleChange: widget.onLocaleChange);
            }
          },
        );
      },
    );
  }
}
