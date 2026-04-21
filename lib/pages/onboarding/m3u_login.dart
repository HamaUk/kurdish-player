import 'package:api/api.dart';
import 'package:flutter/material.dart';

import '../../components/logo.dart';
import '../../l10n/app_localizations.dart';
import '../../validators/validators.dart';
import '../home.dart';
import '../utils/notification.dart';
import '../utils/utils.dart';
import 'onboarding_inputs.dart';

enum M3uLoginMode { url, file }

class M3uLoginPage extends StatefulWidget {
  const M3uLoginPage({super.key, required this.mode});

  final M3uLoginMode mode;

  @override
  State<M3uLoginPage> createState() => _M3uLoginPageState();
}

class _M3uLoginPageState extends State<M3uLoginPage> {
  final _formKey = GlobalKey<FormState>();
  late final _titleController = TextEditingController();
  late final _urlController = TextEditingController();

  bool _loadingPicker = false;

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();

    final isFileMode = widget.mode == M3uLoginMode.file;
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: theme.brightness == Brightness.dark ? Colors.white : Colors.black,
        title: Text(
          isFileMode ? l10n.onboardingM3uFile : l10n.onboardingM3uUrl,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
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
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primary.withOpacity(0.05),
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
                                isFileMode ? l10n.onboardingM3uFile : l10n.onboardingM3uUrl,
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
                              const SizedBox(height: 20),
                              OnboardingLabeledField(
                                label: isFileMode ? l10n.titleEditM3U : l10n.liveCreateFormItemLabelUrl,
                                controller: _urlController,
                                hintText: isFileMode ? null : 'https://',
                                suffixIcon: isFileMode
                                    ? IconButton(
                                        style: IconButton.styleFrom(foregroundColor: const Color(0xFFF2F5FF)),
                                        onPressed: _loadingPicker ? null : _pickM3uFile,
                                        icon: _loadingPicker
                                            ? const SizedBox(
                                                width: 22,
                                                height: 22,
                                                child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFF2F5FF)),
                                              )
                                            : const Icon(Icons.folder_open),
                                      )
                                    : null,
                                validator: (value) =>
                                    isFileMode ? requiredValidator(context, value) : urlValidator(context, value, true),
                              ),
                              const SizedBox(height: 36),
                              SizedBox(
                                height: 56,
                                child: FilledButton(
                                  onPressed: () => _submit(context),
                                  child: Text(
                                    l10n.buttonSubmit,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

  Future<void> _pickM3uFile() async {
    setState(() => _loadingPicker = true);
    try {
      final res = await showDriverFilePicker(
        context,
        AppLocalizations.of(context)!.titleEditM3U,
        selectableType: FileType.file,
      );
      if (res != null) {
        final file = res.$2;
        _urlController.text = 'driver://${res.$1}/${file.id}';
      }
    } finally {
      if (mounted) {
        setState(() => _loadingPicker = false);
      }
    }
  }

  Future<void> _submit(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return;

    if (!(_formKey.currentState?.validate() ?? false)) {
      if (!context.mounted) return;
      final msg = _titleController.text.trim().isEmpty ? l10n.formValidatorRequired : l10n.formValidatorUrl;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(behavior: SnackBarBehavior.floating, content: Text(msg)),
      );
      setState(() {});
      return;
    }

    String url = normalizeHttpUrlForFetch(_urlController.text.trim());

    final resp = await showNotification(
      context,
      Api.playlistInsert(url, _titleController.text.trim()),
    );
    if (resp?.error == null && context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const HomeView()), (route) => false);
    }
  }
}
