import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wandastock/generated/app_localizations.dart'; // 🔥 Import des traductions

class LoginPage extends StatefulWidget {
  final VoidCallback onRegisterClicked;
  final ValueChanged<Locale> onLocaleChange; // Pour changer la langue

  const LoginPage({
    super.key,
    required this.onRegisterClicked,
    required this.onLocaleChange,
  });

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? AppLocalizations.of(context)!.loginError)),
      );
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.login), // Traduction du titre
        actions: [
          PopupMenuButton<Locale>(
            onSelected: widget.onLocaleChange,
            icon: const Icon(Icons.language),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: const Locale('fr'),
                child: const Text('Français'),
              ),
              PopupMenuItem(
                value: const Locale('en'),
                child: const Text('English'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: t.email),
                validator: (val) =>
                    val == null || !val.contains('@') ? t.invalidEmail : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: t.password),
                obscureText: true,
                validator: (val) =>
                    val == null || val.length < 6 ? t.passwordTooShort : null,
              ),
              const SizedBox(height: 20),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      child: Text(t.loginButton),
                    ),
              TextButton(
                onPressed: widget.onRegisterClicked,
                child: Text(t.registerButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
