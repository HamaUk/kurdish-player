import 'package:api/api.dart';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../validators/validators.dart';
import '../components/form_group.dart';
import '../utils/notification.dart';
import '../home.dart';

class XtreamLoginPage extends StatefulWidget {
  const XtreamLoginPage({super.key});

  @override
  State<XtreamLoginPage> createState() => _XtreamLoginPageState();
}

class _XtreamLoginPageState extends State<XtreamLoginPage> {
  late final _formGroup = FormGroupController([
    FormItem(
      'title',
      labelText: "Name / ناو",
      prefixIcon: Icons.label_important_outline,
      validator: (value) => requiredValidator(context, value),
    ),
    FormItem(
      'host',
      labelText: "Server URL (Host)",
      hintText: "http://example.com:8080",
      prefixIcon: Icons.dns_outlined,
      validator: (value) => requiredValidator(context, value),
    ),
    FormItem(
      'username',
      labelText: "Username / ناوی بەکارهێنەر",
      prefixIcon: Icons.person_outline,
      validator: (value) => requiredValidator(context, value),
    ),
    FormItem(
      'password',
      labelText: "Password / وشەی نهێنی",
      prefixIcon: Icons.password_outlined,
      obscureText: true,
      validator: (value) => requiredValidator(context, value),
    ),
  ]);

  @override
  void dispose() {
    _formGroup.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.onboardingXtream),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(child: FormGroup(controller: _formGroup)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton.icon(
                  onPressed: () => _onSubmit(context),
                  icon: const Icon(Icons.login),
                  label: Text(
                    AppLocalizations.of(context)!.buttonSubmit,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onSubmit(BuildContext context) async {
    if (_formGroup.validate()) {
      final host = _formGroup.data['host'].toString().trim();
      final user = _formGroup.data['username'].toString().trim();
      final pass = _formGroup.data['password'].toString().trim();
      final title = _formGroup.data['title'].toString().trim();

      // Construct Xtream M3U Plus URL
      final baseUrl = host.endsWith('/') ? host.substring(0, host.length - 1) : host;
      final xtreamUrl = "$baseUrl/get.php?username=$user&password=$pass&type=m3u_plus&output=ts";

      final resp = await showNotification(
        context,
        Api.playlistInsert(xtreamUrl, title),
      );

      if (resp?.error == null && context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeView()),
          (route) => false,
        );
      }
    }
  }
}
