import 'package:api/api.dart';
import 'package:flutter/material.dart';

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
  static const _panelColor = Color(0x99141A2A);
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
        child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 100, bottom: 24, left: 24, right: 24),
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
                          icon:
                              _loadingPicker
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
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: "Name / ناو",
                      prefixIcon: const Icon(Icons.label_important_outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) => requiredValidator(context, value),
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _urlController,
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: AppLocalizations.of(context)!.liveCreateFormItemLabelUrl,
                      helperText: AppLocalizations.of(context)!.liveCreateFormItemHelperUrl,
                      prefixIcon: const Icon(Icons.link),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) => urlValidator(context, value, true),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(backgroundColor: _accent),
                      onPressed: () => _submit(context),
                      icon: const Icon(Icons.check),
                      label: Text(AppLocalizations.of(context)!.buttonSubmit),
                    ),
                  ),
                  ],
                ),
              ),
            ),
          ),
        ),
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
}
