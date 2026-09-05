import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wandastock/generated/app_localizations.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback onLoginClicked;
  final ValueChanged<Locale> onLocaleChange;

  const RegisterPage({
    super.key,
    required this.onLoginClicked,
    required this.onLocaleChange,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _enterpriseController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _register() async {
    final t = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = t.passwordsDontMatch;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
        'email': _emailController.text.trim(),
        'enterpriseName': _enterpriseController.text.trim(),
        'role': 'user',
        'isBlocked': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await FirebaseAuth.instance.signOut();
      widget.onLoginClicked();
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _enterpriseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.registerTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                if (_errorMessage != null) ...[
                  Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 10),
                ],
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: t.email),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      value == null || !value.contains('@') ? t.invalidEmail : null,
                ),
                TextFormField(
                  controller: _enterpriseController,
                  decoration: InputDecoration(labelText: t.enterpriseName),
                  validator: (value) =>
                      value == null || value.isEmpty ? t.requiredField : null,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: t.password),
                  obscureText: true,
                  validator: (value) =>
                      value == null || value.length < 6 ? t.minPasswordLength : null,
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(labelText: t.confirmPassword),
                  obscureText: true,
                  validator: (value) =>
                      value == null || value.length < 6 ? t.minPasswordLength : null,
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _register,
                        child: Text(t.signUp),
                      ),
                TextButton(
                  onPressed: widget.onLoginClicked,
                  child: Text(t.alreadyHaveAccount),
                ),
                TextButton(
                  onPressed: () {
                    final newLocale = Localizations.localeOf(context).languageCode == 'fr'
                        ? const Locale('en')
                        : const Locale('fr');
                    widget.onLocaleChange(newLocale);
                  },
                  child: Text(t.changeLanguage),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
