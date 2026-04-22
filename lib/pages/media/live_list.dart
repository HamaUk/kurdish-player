import 'package:api/api.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:video_player/player.dart';

import '../../components/async_image.dart';
import '../../components/logo.dart';
import '../../components/no_data.dart';
import '../../components/playing_icon.dart';
import '../../l10n/app_localizations.dart';
import '../../models/models.dart';
import '../../providers/iptv_provider.dart';
import '../components/image_card.dart';
import '../components/loading.dart';
import '../player/player_controls_lite.dart';
import '../utils/notification.dart';
import 'dialogs/live_edit.dart';

class LiveListPage extends StatefulWidget {
  const LiveListPage({super.key});

  @override
  State<LiveListPage> createState() => _LiveListPageState();
}

class _LiveListPageState extends State<LiveListPage> {
  final _controller = PlayerController<Channel>();
  Playlist? _selectedPlaylist;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    // Prevent auto-advancing to next channel on Live TV
    // Set status to idle or error rather than jumping to next if stream drops
    _controller.status.addListener(() {
      if (_controller.status.value == PlayerStatus.ended) {
        _controller.pause(); // Stop instead of advancing
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadPlaylist(Playlist playlist) async {
    if (_selectedPlaylist?.id == playlist.id) return;
    setState(() => _loading = true);
    try {
      final channels = await Api.playlistChannelsQueryById(playlist.id);
      _controller.setPlaylist(channels.map(FromMedia.fromChannel).toList());
      _selectedPlaylist = playlist;
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IptvCubit, List<Playlist>?>(
      builder: (context, items) {
        if (items == null) return const Loading();
        if (items.isEmpty) return const NoData();

        // Auto-load first playlist if none selected
        if (_selectedPlaylist == null && !_loading) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _loadPlaylist(items.first));
        }

        return Row(
          children: [
            // Main content: Player + Channel Selection
            Expanded(
              child: Column(
                children: [
                  // Professional Player Preview
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: ClipRect(
                      child: PlayerControlsLite(
                        _controller,
                        artwork: const Logo(size: 80),
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  // Grouped Categories and Channels List
                  Expanded(
                    child: _loading
                        ? const Loading()
                        : _ChannelListGrouped(
                          controller: _controller,
                          onTap: (index) async {
                            await _controller.next(index);
                            await _controller.play();
                          },
                        ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addPlaylist(BuildContext context) async {
    final flag = await showDialog(context: context, builder: (context) => const LiveEditPage());
    if (flag == true && context.mounted) context.read<IptvCubit>().update();
  }

  void _showBottomSheet<T>({required BuildContext context, required WidgetBuilder builder}) {
    final constraints = BoxConstraints(
      maxHeight: (Scaffold.of(context).context.findRenderObject()! as RenderBox).size.height + 104,
    );
    showBottomSheet(
      context: context,
      constraints: constraints,
      enableDrag: true,
      showDragHandle: true,
      builder: builder,
    );
  }
}

class _ChannelList extends StatefulWidget {
  const _ChannelList({required this.playlist, required this.onTap, this.activeIndex});

  final List<PlaylistItemDisplay<Channel>> playlist;
  final int? activeIndex;
  final Function(int) onTap;

  @override
  State<_ChannelList> createState() => _ChannelListState();
}

class _ChannelListState extends State<_ChannelList> {
  final _scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant _ChannelList oldWidget) {
    if (widget.playlist != oldWidget.playlist) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(0, duration: const Duration(milliseconds: 400), curve: Curves.easeOut);
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          widget.playlist.isEmpty
              ? const NoData()
              : Scrollbar(
                interactive: true,
                controller: _scrollController,
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverSafeArea(
                      sliver: SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverGrid.builder(
                          itemCount: widget.playlist.length,
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 120,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 16,
                          ),
                          itemBuilder: (context, index) {
                            final item = widget.playlist[index].source;
                            return ImageCard(
                              item.image,
                              fit: BoxFit.contain,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              title: item.title != null ? Text(item.title!) : null,
                              subtitle: item.category != null ? Text(item.category!) : null,
                              floating:
                                  widget.activeIndex == index
                                      ? ColoredBox(
                                        color: Theme.of(context).scaffoldBackgroundColor.withAlpha(0x66),
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: PlayingIcon(color: Theme.of(context).colorScheme.primary),
                                        ),
                                      )
                                      : null,
                              onTap: () => widget.onTap(index),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}

class _ChannelListGrouped extends StatefulWidget {
  const _ChannelListGrouped({required this.controller, required this.onTap, this.activeIndex});

  final PlayerController<Channel> controller;
  final int? activeIndex;
  final Function(int) onTap;

  @override
  State<_ChannelListGrouped> createState() => _ChannelListGroupedState();
}

class _ChannelListGroupedState extends State<_ChannelListGrouped> {
  late final _groupedPlaylist = widget.controller.playlist.value.groupListsBy((channel) => channel.source.category);
  late final _playlist = ValueNotifier<List<PlaylistItemDisplay<Channel>>>([]);
  final _groupName = ValueNotifier<String?>(null);

  @override
  void dispose() {
    _groupName.dispose();
    _playlist.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Flexible(
            flex: 2,
            child: ListenableBuilder(
              listenable: _groupName,
              builder: (context, _) {
                return ListView.builder(
                  itemCount: _groupedPlaylist.keys.length,
                  itemBuilder: (context, index) {
                    final name = _groupedPlaylist.keys.elementAt(index);
                    return ListTile(
                      dense: true,
                      selected: _groupName.value == name,
                      selectedColor: Theme.of(context).colorScheme.onPrimaryContainer,
                      selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
                      title: Text(name ?? AppLocalizations.of(context)!.tagUnknown),
                      onTap: () {
                        _groupName.value = name;
                        _playlist.value = _groupedPlaylist[name]!;
                      },
                    );
                  },
                );
              },
            ),
          ),
          const VerticalDivider(),
          Flexible(
            flex: 3,
            child: ListenableBuilder(
              listenable: Listenable.merge([_playlist, widget.controller.index]),
              builder: (context, _) {
                return _playlist.value.isNotEmpty
                    ? ListView.builder(
                      itemCount: _playlist.value.length,
                      itemBuilder: (context, index) {
                        final item = _playlist.value.elementAt(index);
                        return ListTile(
                          dense: true,
                          leading:
                              item.poster != null ? AsyncImage(item.poster!, width: 40, showErrorWidget: false) : null,
                          trailing:
                              item == widget.controller.currentItem
                                  ? PlayingIcon(color: Theme.of(context).colorScheme.primary)
                                  : null,
                          selected: item == widget.controller.currentItem,
                          selectedColor: Theme.of(context).colorScheme.onPrimaryContainer,
                          selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
                          title: Text(item.title ?? ''),
                          onTap: () => widget.onTap(widget.controller.playlist.value.indexOf(item)),
                        );
                      },
                    )
                    : const NoData();
              },
            ),
          ),
        ],
      ),
    );
  }
}

