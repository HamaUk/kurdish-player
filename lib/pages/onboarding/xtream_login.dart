import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../components/logo.dart';
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
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(l10n.onboardingXtream, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: theme.brightness == Brightness.dark ? Colors.white : Colors.black,
      ),
      body: Stack(
        children: [
          // Premium Background Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: theme.brightness == Brightness.dark
                      ? [const Color(0xFF141A2A), const Color(0xFF05070F)]
                      : [const Color(0xFFF8F9FA), const Color(0xFFE9ECEF)],
                ),
              ),
            ),
          ),
          // Decorative Blobs
          Positioned(
            bottom: -120,
            left: -120,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.secondary.withOpacity(0.05),
              ),
            ),
            ).animate(onPlay: (controller) => controller.repeat(reverse: true))
             .fadeIn(duration: 1200.ms)
             .scale(begin: const Offset(0.8, 0.8))
             .slideY(begin: -0.05, end: 0.05, duration: 3.seconds, curve: Curves.easeInOut),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Column(
                    children: [
                      const Logo(size: 150)
                          .animate()
                          .fadeIn(duration: 600.ms)
                          .slideY(begin: -0.2, end: 0, curve: Curves.easeOutBack),
                      const SizedBox(height: 32),
                      Container(
                        decoration: BoxDecoration(
                          color: theme.brightness == Brightness.dark 
                              ? Colors.white.withOpacity(0.05) 
                              : Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: theme.brightness == Brightness.dark 
                                ? Colors.white.withOpacity(0.08) 
                                : Colors.black.withOpacity(0.05),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              l10n.onboardingXtream,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                              ),
                              textAlign: TextAlign.center,
                            ).animate().fadeIn(delay: 200.ms, duration: 600.ms)
                             .shimmer(duration: 1500.ms, delay: 800.ms),
                            const SizedBox(height: 32),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _titleController,
                                    decoration: InputDecoration(
                                      labelText: l10n.buttonName,
                                      prefixIcon: const Icon(Icons.label_important_outline),
                                    ),
                                    validator: (value) => requiredValidator(context, value),
                                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0, duration: 400.ms, curve: Curves.easeOutQuad),
                                  const SizedBox(height: 18),
                                  TextFormField(
                                    controller: _hostController,
                                    decoration: InputDecoration(
                                      labelText: l10n.serverFormItemLabelServer,
                                      hintText: "http://example.com:8080",
                                      prefixIcon: const Icon(Icons.dns_outlined),
                                    ),
                                    validator: (value) => requiredValidator(context, value),
                                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0, duration: 400.ms, curve: Curves.easeOutQuad),
                                  const SizedBox(height: 18),
                                  TextFormField(
                                    controller: _usernameController,
                                    decoration: InputDecoration(
                                      labelText: l10n.loginFormItemLabelUsername,
                                      prefixIcon: const Icon(Icons.person_outline),
                                    ),
                                    validator: (value) => requiredValidator(context, value),
                                  ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1, end: 0, duration: 400.ms, curve: Curves.easeOutQuad),
                                  const SizedBox(height: 18),
                                  TextFormField(
                                    controller: _passwordController,
                                    decoration: InputDecoration(
                                      labelText: l10n.loginFormItemLabelPwd,
                                      prefixIcon: const Icon(Icons.password_outlined),
                                    ),
                                    obscureText: true,
                                    validator: (value) => requiredValidator(context, value),
                                  ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1, end: 0, duration: 400.ms, curve: Curves.easeOutQuad),
                                ],
                              ),
                            ),
                            const SizedBox(height: 40),
                            SizedBox(
                              height: 56,
                              child: FilledButton.icon(
                                onPressed: () => _onSubmit(context),
                                icon: const Icon(Icons.login),
                                label: Text(
                                  l10n.buttonSubmit,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                             .shimmer(duration: 2000.ms, delay: 1000.ms)
                             .scaleXY(end: 1.02, duration: 1500.ms, curve: Curves.easeInOut),
                          ],
                        ),
                      ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onSubmit(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final host = _hostController.text.trim();
      final user = _usernameController.text.trim();
      final pass = _passwordController.text.trim();
      final title = _titleController.text.trim();

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
