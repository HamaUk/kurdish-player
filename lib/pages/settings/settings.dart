import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:video_player/player.dart';

import '../../components/logo.dart';
import '../../components/scrollbar.dart';
import '../../const.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/utils.dart';
import '../account/account.dart';
import '../library.dart';
import '../player/singleton_player.dart';
import '../utils/utils.dart';
import 'playlist_settings.dart';
import 'settings_diagnostics.dart';
import 'settings_downloader.dart';
import 'settings_help.dart';
import 'settings_log.dart';
import 'settings_other.dart';
import 'settings_player_history.dart';
import 'settings_server.dart';
import 'settings_sponsor.dart';
import 'settings_updater.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingsTitle),
        leading: isMobile(context) ? const Padding(padding: EdgeInsets.all(12), child: Logo()) : null,
      ),
      body: ScrollbarListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _buildItem(
            context,
            AppLocalizations.of(context)!.settingsItemAccount,
            Icons.view_list_rounded,
            onTap: () => navigateTo(context, const PlaylistSettingsPage()),
          ),
          const Divider(height: 32),
          _buildItem(
            context,
            AppLocalizations.of(context)!.settingsItemDownload,
            Icons.download_for_offline_rounded,
            onTap: () => navigateTo(context, const SystemSettingsDownloader()),
          ),
          _buildItem(
            context,
            AppLocalizations.of(context)!.settingsItemServer,
            Icons.dns_rounded,
            onTap: () => navigateTo(context, const SystemSettingsServer()),
          ),
          _buildItem(
            context,
            AppLocalizations.of(context)!.settingsItemNetworkDiagnostics,
            Icons.signal_cellular_alt_rounded,
            onTap: () => navigateTo(context, const SettingsDiagnostics()),
          ),
          _buildItem(
            context,
            AppLocalizations.of(context)!.settingsItemOthers,
            Icons.tune_rounded,
            onTap: () => navigateTo(context, const SystemSettingsOther()),
          ),
          const Divider(height: 32),
          _buildItem(
            context,
            AppLocalizations.of(context)!.settingsItemHelp,
            Icons.help_center_rounded,
            onTap: () => navigateTo(context, const SettingsHelp()),
          ),
          _buildItem(
            context,
            AppLocalizations.of(context)!.settingsItemInfo,
            Icons.info_rounded,
            onTap: () => navigateTo(context, const SystemSettingsUpdater()),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, String title, IconData icon, {Widget? trailing, GestureTapCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        trailing: onTap == null ? null : Icon(Icons.chevron_right_rounded, color: Theme.of(context).colorScheme.outline),
        onTap: onTap,
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideX(begin: 0.1);
  }
}

class _UrlDialog extends StatefulWidget {
  const _UrlDialog();

  @override
  State<_UrlDialog> createState() => __UrlDialogState();
}

class __UrlDialogState extends State<_UrlDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _controller = TextEditingController();
  String? fileId;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.buttonPlay),
      content: SizedBox(
        width: 600,
        child: Form(
          key: _formKey,
          child: TextFormField(
            autofocus: true,
            controller: _controller,
            decoration: InputDecoration(
              isDense: true,
              border: const UnderlineInputBorder(),
              labelText: 'Link',
              prefixIcon: const Icon(Icons.link),
              suffixIcon: IconButton(
                icon: const Icon(Icons.folder_open_rounded),
                onPressed: () async {
                  final res = await showDriverFilePicker(context, '', selectableType: FileType.file);
                  if (res != null) {
                    final file = res.$2;
                    _controller.text = file.fileId ?? '';
                    fileId = file.fileId;
                    setState(() {});
                  }
                },
              ),
            ),
            validator: (value) {
              if (_controller.text.trim().isEmpty) {
                return AppLocalizations.of(context)!.formValidatorRequired;
              }
              if (fileId != null) {
                return null;
              }
              final uri = Uri.tryParse(_controller.text);
              if (uri == null || !uri.hasScheme) {
                return AppLocalizations.of(context)!.formValidatorUrl;
              }
              return null;
            },
            onChanged: (_) {
              fileId = null;
            },
          ),
        ),
      ),
      actions: [IconButton(icon: const Icon(Icons.check), onPressed: () => _onSubmit(context))],
    );
  }

  Future<void> _onSubmit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, (Uri.tryParse(_controller.text), fileId));
    }
  }
}
