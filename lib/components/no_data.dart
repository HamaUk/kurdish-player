import 'package:flutter/material.dart';

import '../const.dart';
import '../l10n/app_localizations.dart';

class NoData extends StatelessWidget {
  const NoData({super.key, this.action});

  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Opacity(
            opacity: 0.5,
            child: Image.asset(assetsLogo, width: 120, height: 120, fit: BoxFit.contain),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: action == null ? const EdgeInsets.only(bottom: 16) : EdgeInsets.zero,
            child: Text(AppLocalizations.of(context)!.noData),
          ),
          if (action != null) Padding(padding: const EdgeInsets.all(8), child: action),
        ],
      ),
    );
  }
}
