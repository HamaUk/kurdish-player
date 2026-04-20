import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/logo.dart';
import '../l10n/app_localizations.dart';
import '../providers/iptv_provider.dart';
import 'components/mobile_builder.dart';
import 'media/live_list.dart';
import 'media/movie_list.dart';
import 'media/tv_list.dart';
import 'settings/settings.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int index = 0;

  Widget get child => AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: switch (index) {
          0 => BlocProvider(key: const ValueKey(0), create: (_) => IptvCubit(), child: const LiveListPage()),
          1 => const MovieListPage(key: ValueKey(1)),
          2 => const TVListPage(key: ValueKey(2)),
          3 => const SettingsPage(key: ValueKey(3)),
          _ => const Placeholder(),
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: MobileBuilder(
        builder: (context, isMobile, child) => isMobile ? child : null,
        child: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (index) => setState(() => this.index = index),
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations:
              _destinations(context).map((_TabDestination destination) {
                return NavigationDestination(
                  label: destination.label,
                  icon: destination.icon,
                  selectedIcon: destination.selectedIcon,
                  tooltip: '',
                );
              }).toList(),
        ),
      ),
      backgroundColor: index == 0 ? Colors.transparent : null,
      body: Row(
        children: <Widget>[
          MobileBuilder(
            builder: (context, isMobile, child) => isMobile ? null : child,
            child: Row(
              children: [
                NavigationRail(
                  leading: const Padding(padding: EdgeInsets.symmetric(vertical: 24), child: Logo(size: 48)),
                  labelType: NavigationRailLabelType.selected,
                  destinations:
                      _destinations(context)
                          .map(
                            (destination) => NavigationRailDestination(
                              label: Text(destination.label),
                              icon: destination.icon,
                              selectedIcon: destination.selectedIcon,
                            ),
                          )
                          .toList(),
                  selectedIndex: index,
                  useIndicator: true,
                  onDestinationSelected: (index) => setState(() => this.index = index),
                ),
                VerticalDivider(color: Theme.of(context).colorScheme.surfaceContainerHighest, width: 1),
              ],
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }

  List<_TabDestination> _destinations(BuildContext context) {
    return [
      _TabDestination(
        AppLocalizations.of(context)!.homeTabLive,
        const Icon(Icons.live_tv_rounded).animate().fadeIn(),
        const Icon(Icons.live_tv_rounded, color: Colors.redAccent).animate().scale(duration: 200.ms).shake(hz: 4),
      ),
      _TabDestination(
        AppLocalizations.of(context)!.homeTabMovie,
        const Icon(Icons.movie_filter_rounded).animate().fadeIn(),
        const Icon(Icons.movie_filter_rounded).animate().scale(duration: 200.ms),
      ),
      _TabDestination(
        AppLocalizations.of(context)!.homeTabTV,
        const Icon(Icons.video_library_rounded).animate().fadeIn(),
        const Icon(Icons.video_library_rounded).animate().scale(duration: 200.ms),
      ),
      _TabDestination(
        AppLocalizations.of(context)!.homeTabSettings,
        const Icon(Icons.settings_suggest_rounded).animate().fadeIn(),
        const Icon(Icons.settings_suggest_rounded).animate().rotate(duration: 300.ms),
      ),
    ];
  }
}

class _TabDestination {
  const _TabDestination(this.label, this.icon, this.selectedIcon);

  final String label;
  final Widget icon;
  final Widget selectedIcon;
}
