import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../components/logo.dart';
import '../../l10n/app_localizations.dart';
import '../../validators/validators.dart';
import '../home.dart';
import '../utils/notification.dart';
import '../utils/utils.dart';

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

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
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
          // Subtle Decorative Blobs
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
            ).animate(onPlay: (controller) => controller.repeat(reverse: true))
             .fadeIn(duration: 1000.ms)
             .scale(begin: const Offset(0.8, 0.8))
             .slideY(begin: -0.05, end: 0.05, duration: 3.seconds, curve: Curves.easeInOut),
          
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                                ),
                                textAlign: TextAlign.center,
                              ).animate().fadeIn(delay: 200.ms, duration: 600.ms)
                               .shimmer(duration: 1500.ms, delay: 800.ms),
                              const SizedBox(height: 32),
                              TextFormField(
                                controller: _titleController,
                                decoration: InputDecoration(
                                  labelText: l10n.buttonName,
                                  prefixIcon: const Icon(Icons.drive_file_rename_outline),
                                ),
                                validator: (value) => requiredValidator(context, value),
                              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0, duration: 400.ms, curve: Curves.easeOutQuad),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _urlController,
                                decoration: InputDecoration(
                                  labelText: isFileMode ? l10n.titleEditM3U : l10n.liveCreateFormItemLabelUrl,
                                  prefixIcon: Icon(isFileMode ? Icons.file_present : Icons.link),
                                  suffixIcon: isFileMode 
                                      ? IconButton(
                                          onPressed: _loadingPicker ? null : _pickM3uFile,
                                          icon: _loadingPicker
                                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                                              : const Icon(Icons.folder_open),
                                        )
                                      : null,
                                ),
                                validator: (value) => isFileMode ? requiredValidator(context, value) : urlValidator(context, value, true),
                              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0, duration: 400.ms, curve: Curves.easeOutQuad),
                              const SizedBox(height: 40),
                              SizedBox(
                                height: 56,
                                child: FilledButton(
                                  onPressed: () => _submit(context),
                                  child: Text(
                                    l10n.buttonSubmit,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                               .shimmer(duration: 2000.ms, delay: 1000.ms)
                               .scaleXY(end: 1.02, duration: 1500.ms, curve: Curves.easeInOut),
                            ],
                          ),
                        ).animate().fadeIn(duration: 800.ms),
                      ).animate().slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
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
    if (!(_formKey.currentState?.validate() ?? false)) return;
    
    String url = _urlController.text.trim();
    
    final resp = await showNotification(
      context,
      Api.playlistInsert(url, _titleController.text.trim()),
    );
    if (resp?.error == null && context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const HomeView()), (route) => false);
    }
  }
}
