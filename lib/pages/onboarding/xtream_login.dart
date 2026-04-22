import 'package:api/api.dart';
import 'package:flutter/material.dart';

import '../../components/logo.dart';
import '../../l10n/app_localizations.dart';
import '../../validators/validators.dart';
import '../home.dart';
import '../utils/notification.dart';
import 'onboarding_inputs.dart';

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

  bool _loading = false;

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
    final titleColor = theme.brightness == Brightness.dark ? Colors.white : Colors.black87;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
        ),
        title: Text(l10n.onboardingXtream, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: theme.brightness == Brightness.dark ? Colors.white : Colors.black,
      ),
      body: Stack(
        children: [
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
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Logo(size: 150),
                      const SizedBox(height: 32),
                      Container(
                        decoration: BoxDecoration(
                          color: theme.brightness == Brightness.dark ? const Color(0xFF1C2230) : Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: theme.brightness == Brightness.dark
                                ? Colors.white24
                                : Colors.black.withOpacity(0.08),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(32),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                l10n.onboardingXtream,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.5,
                                  color: titleColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 28),
                              OnboardingLabeledField(
                                label: l10n.buttonName,
                                controller: _titleController,
                                ltrInput: false,
                                validator: (value) => requiredValidator(context, value),
                              ),
                              const SizedBox(height: 18),
                              OnboardingLabeledField(
                                label: l10n.serverFormItemLabelServer,
                                controller: _hostController,
                                hintText: 'http://example.com:8080',
                                validator: (value) => requiredValidator(context, value),
                              ),
                              const SizedBox(height: 18),
                              OnboardingLabeledField(
                                label: l10n.loginFormItemLabelUsername,
                                controller: _usernameController,
                                validator: (value) => requiredValidator(context, value),
                              ),
                              const SizedBox(height: 18),
                              OnboardingLabeledField(
                                label: l10n.loginFormItemLabelPwd,
                                controller: _passwordController,
                                obscureText: true,
                                validator: (value) => requiredValidator(context, value),
                              ),
                              const SizedBox(height: 36),
                              SizedBox(
                                height: 56,
                                child: FilledButton.icon(
                                  onPressed: _loading ? null : () => _onSubmit(context),
                                  icon: _loading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                        )
                                      : const Icon(Icons.login),
                                  label: Text(
                                    l10n.buttonSubmit,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
    final l10n = AppLocalizations.of(context);
    if (l10n == null || _loading) return;

    if (!(_formKey.currentState?.validate() ?? false)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(behavior: SnackBarBehavior.floating, content: Text(l10n.formValidatorRequired)),
      );
      setState(() {});
      return;
    }

    final host = _hostController.text.trim();
    final user = _usernameController.text.trim();
    final pass = _passwordController.text.trim();
    final title = _titleController.text.trim();

    setState(() => _loading = true);
    try {
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
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
