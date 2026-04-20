import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/iptv_provider.dart';
import '../components/loading.dart';
import '../media/dialogs/live_edit.dart';
import '../utils/notification.dart';
import '../utils/utils.dart';

class PlaylistSettingsPage extends StatelessWidget {
  const PlaylistSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => IptvCubit(),
      child: const _PlaylistSettingsView(),
    );
  }
}

class _PlaylistSettingsView extends StatelessWidget {
  const _PlaylistSettingsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingsItemAccount),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            onPressed: () => _addPlaylist(context),
          ),
        ],
      ),
      body: BlocBuilder<IptvCubit, List<Playlist>?>(
        builder: (context, items) {
          if (items == null) return const Loading();
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.playlist_add_rounded, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(AppLocalizations.of(context)!.noData),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => _addPlaylist(context),
                    child: Text(AppLocalizations.of(context)!.pageTitleAdd),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _PlaylistTile(item: item).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.1);
            },
          );
        },
      ),
    );
  }

  Future<void> _addPlaylist(BuildContext context) async {
    final flag = await showDialog(context: context, builder: (context) => const LiveEditPage());
    if (flag == true && context.mounted) {
      context.read<IptvCubit>().update();
    }
  }
}

class _PlaylistTile extends StatelessWidget {
  const _PlaylistTile({required this.item});

  final Playlist item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Slidable(
        endActionPane: ActionPane(
          extentRatio: 0.5,
          motion: const BehindMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _refresh(context),
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              icon: Icons.refresh_rounded,
            ),
            SlidableAction(
              onPressed: (_) => _edit(context),
              backgroundColor: Colors.orangeAccent,
              foregroundColor: Colors.white,
              icon: Icons.edit_rounded,
            ),
            SlidableAction(
              onPressed: (_) => _delete(context),
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              icon: Icons.delete_rounded,
              borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(item.title ?? 'No Name', style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(item.url, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Icon(Icons.playlist_play_rounded, color: Theme.of(context).colorScheme.primary),
          ),
          onTap: () => _edit(context),
        ),
      ),
    );
  }

  Future<void> _refresh(BuildContext context) async {
    final resp = await showNotification(context, Api.playlistRefreshById(item.id));
    if (resp?.error == null && context.mounted) {
      context.read<IptvCubit>().update();
    }
  }

  Future<void> _edit(BuildContext context) async {
    final flag = await showDialog(context: context, builder: (context) => LiveEditPage(item: item));
    if (flag == true && context.mounted) {
      context.read<IptvCubit>().update();
    }
  }

  Future<void> _delete(BuildContext context) async {
    final confirm = await showConfirm(context, AppLocalizations.of(context)!.deleteConfirmText);
    if (confirm != true) return;
    if (!context.mounted) return;
    final resp = await showNotification(context, Api.playlistDeleteById(item.id));
    if (resp?.error == null && context.mounted) {
      context.read<IptvCubit>().update();
    }
  }
}
