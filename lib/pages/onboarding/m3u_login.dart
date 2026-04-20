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
  static const _darkTop = Color(0xFF0B1020);
  static const _darkBottom = Color(0xFF05070F);
  static const _panelColor = Color(0xFF141A2A);
  static const _accent = Color(0xFF5E7BFF);

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
    final isFileMode = widget.mode == M3uLoginMode.file;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: Text(
          isFileMode
              ? AppLocalizations.of(context)!.onboardingM3uFile
              : AppLocalizations.of(context)!.onboardingM3uUrl,
        ),
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _panelColor,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white10),
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isFileMode)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: FilledButton.icon(
                                    onPressed: _loadingPicker ? null : _pickM3uFile,
                                    style: FilledButton.styleFrom(backgroundColor: _accent),
                                    icon: _loadingPicker
                                        ? const SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          )
                                        : const Icon(Icons.folder_open_rounded),
                                    label: Text(AppLocalizations.of(context)!.titleEditM3U),
                                  ),
                                ),
                              ),
                            const Logo(size: 140).animate().fadeIn().scale(delay: 100.ms),
                            const SizedBox(height: 24),
                            Text(
                              isFileMode
                                  ? AppLocalizations.of(context)!.onboardingM3uFile
                                  : AppLocalizations.of(context)!.onboardingM3uUrl,
                              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, duration: 400.ms),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _titleController,
                              decoration: _inputDecoration(context, "Playlist Name"),
                              validator: (value) => requiredValidator(context, value),
                            ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2, duration: 400.ms),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _urlController,
                              decoration: _inputDecoration(context, AppLocalizations.of(context)!.liveCreateFormItemLabelUrl),
                              validator: (value) => urlValidator(context, value, true),
                            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, duration: 400.ms),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: FilledButton(
                                onPressed: () => _submit(context),
                                style: FilledButton.styleFrom(
                                  backgroundColor: _accent,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  elevation: 4,
                                  shadowColor: _accent.withOpacity(0.4),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.buttonSubmit,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, duration: 400.ms),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
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
    final resp = await showNotification(
      context,
      Api.playlistInsert(_urlController.text.trim(), _titleController.text.trim()),
    );
    if (resp?.error == null && context.mounted) {
      Navigator.of(
        context,
      ).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const HomeView()), (route) => false);
    }
  }

  InputDecoration _inputDecoration(BuildContext context, String label) {
    return InputDecoration(
      labelText: label,
      isDense: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
