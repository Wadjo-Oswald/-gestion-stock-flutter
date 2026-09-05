import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wandastock/generated/app_localizations.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  void _launchEmail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.about),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              t.appName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(t.aboutDescription),
            const SizedBox(height: 20),
            Text(
              t.featuresTitle,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...[
              t.feature1,
              t.feature2,
              t.feature3,
              t.feature4,
              t.feature6,
            ].map((f) => ListTile(
                  leading: const Icon(Icons.check, color: Colors.green),
                  title: Text(f),
                )),
            const SizedBox(height: 20),
            Text(
              t.contactMe,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            InkWell(
              onTap: () => _launchEmail("wadjooswald22@gmail.com"),
              child: Text(
                "wadjooswald22@gmail.com",
                style: const TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
