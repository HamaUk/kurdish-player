import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../l10n/app_localizations.dart';
import '../../validators/validators.dart';
import '../utils/notification.dart';
import '../home.dart';

class XtreamLoginPage extends StatefulWidget {
  const XtreamLoginPage({super.key});

  @override
  State<XtreamLoginPage> createState() => _XtreamLoginPageState();
}

class _XtreamLoginPageState extends State<XtreamLoginPage> {
  static const _darkTop = Color(0xFF0B1020);
  static const _darkBottom = Color(0xFF05070F);
  static const _panelColor = Color(0xFF141A2A);
  static const _accent = Color(0xFF5E7BFF);

  final _formKey = GlobalKey<FormState>();
  late final _titleController = TextEditingController();
  late final _hostController = TextEditingController();
  late final _usernameController = TextEditingController();
  late final _passwordController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _hostController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.onboardingXtream),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_darkTop, _darkBottom],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 100, bottom: 24, left: 24, right: 24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              decoration: BoxDecoration(
                color: _panelColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white10),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.cloud_download_rounded,
                    size: 64,
                    color: _accent,
                  ).animate().fadeIn().scale(delay: 100.ms),
                  const SizedBox(height: 24),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            isDense: true,
                            labelText: "Playlist Name",
                            prefixIcon: const Icon(Icons.label_important_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                            ),
                          ),
                          validator: (value) => requiredValidator(context, value),
                        ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),
                        const SizedBox(height: 18),
                        TextFormField(
                          controller: _hostController,
                          decoration: InputDecoration(
                            isDense: true,
                            labelText: "Server URL (Host)",
                            hintText: "http://example.com:8080",
                            prefixIcon: const Icon(Icons.dns_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                            ),
                          ),
                          validator: (value) => requiredValidator(context, value),
                        ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.1),
                        const SizedBox(height: 18),
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            isDense: true,
                            labelText: "Username",
                            prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                            ),
                          ),
                          validator: (value) => requiredValidator(context, value),
                        ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1),
                        const SizedBox(height: 18),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            isDense: true,
                            labelText: "Password",
                            prefixIcon: const Icon(Icons.password_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                            ),
                          ),
                          obscureText: true,
                          validator: (value) => requiredValidator(context, value),
                        ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.1),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: _accent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                        shadowColor: _accent.withOpacity(0.4),
                      ),
                      onPressed: () => _onSubmit(context),
                      icon: const Icon(Icons.login),
                      label: Text(
                        AppLocalizations.of(context)!.buttonSubmit,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ).animate().fadeIn(delay: 600.ms).scale(begin: const Offset(0.8, 0.8)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSubmit(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final host = _hostController.text.trim();
      final user = _usernameController.text.trim();
      final pass = _passwordController.text.trim();
      final title = _titleController.text.trim();

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
