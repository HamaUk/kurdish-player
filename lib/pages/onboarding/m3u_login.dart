import 'package:api/api.dart';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../validators/validators.dart';
import '../components/form_group.dart';
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
  late final _urlController = TextEditingController();
  late final _formGroup = FormGroupController([
    FormItem(
      'title',
      labelText: "Name / ناو",
      prefixIcon: Icons.label_important_outline,
      validator: (value) => requiredValidator(context, value),
    ),
    FormItem(
      'url',
      labelText: AppLocalizations.of(context)!.liveCreateFormItemLabelUrl,
      helperText: AppLocalizations.of(context)!.liveCreateFormItemHelperUrl,
      prefixIcon: Icons.link,
      controller: _urlController,
      validator: (value) => urlValidator(context, value, true),
    ),
  ]);

  bool _loadingPicker = false;

  @override
  void dispose() {
    _urlController.dispose();
    _formGroup.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFileMode = widget.mode == M3uLoginMode.file;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isFileMode
              ? AppLocalizations.of(context)!.onboardingM3uFile
              : AppLocalizations.of(context)!.onboardingM3uUrl,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
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
                SizedBox(height: 280, child: FormGroup(controller: _formGroup)),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton.icon(
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
    if (!_formGroup.validate()) return;
    final resp = await showNotification(
      context,
      Api.playlistInsert(_formGroup.data['url'], _formGroup.data['title']),
    );
    if (resp?.error == null && context.mounted) {
      Navigator.of(
        context,
      ).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const HomeView()), (route) => false);
    }
  }
}
