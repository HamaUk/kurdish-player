import 'package:flutter/material.dart';
import '../../components/logo.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/utils.dart';
import '../media/dialogs/live_edit.dart';
import '../media/live_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme.dart';

class SourceSelectionPage extends StatelessWidget {
  const SourceSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.background,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Logo(size: 120),
                const SizedBox(height: 32),
                Text(
                  AppLocalizations.of(context)!.onboardingTitle,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(context)!.onboardingSubtitle,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                _buildSourceOption(
                  context,
                  icon: Icons.link,
                  title: AppLocalizations.of(context)!.onboardingM3uUrl,
                  onTap: () => _addM3uUrl(context),
                ),
                _buildSourceOption(
                  context,
                  icon: Icons.file_present_rounded,
                  title: AppLocalizations.of(context)!.onboardingM3uFile,
                  onTap: () => _addM3uUrl(context), // LiveEdit handles file picker internally
                ),
                _buildSourceOption(
                  context,
                  icon: Icons.cloud_download_rounded,
                  title: AppLocalizations.of(context)!.onboardingXtream,
                  onTap: () => _addXtream(context),
                ),
                _buildSourceOption(
                  context,
                  icon: Icons.play_circle_fill_rounded,
                  title: AppLocalizations.of(context)!.onboardingSinglePlay,
                  onTap: () => _singlePlay(context),
                  isSpecial: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSourceOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSpecial = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 400,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          decoration: BoxDecoration(
            color: isSpecial 
                ? Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5) 
                : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSpecial 
                  ? Theme.of(context).colorScheme.secondary.withOpacity(0.3) 
                  : Theme.of(context).colorScheme.outline.withOpacity(0.1),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSpecial 
                      ? Theme.of(context).colorScheme.secondary 
                      : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isSpecial 
                      ? Theme.of(context).colorScheme.onSecondary 
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 20),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addM3uUrl(BuildContext context) async {
    final flag = await showDialog(context: context, builder: (context) => const LiveEditPage());
    if (flag == true && context.mounted) {
       // Refresh or Navigate to Home
       Navigator.of(context).pushReplacementNamed('/');
    }
  }

  Future<void> _addXtream(BuildContext context) async {
    // For now, reuse LiveEditPage as a placeholder or implement Xtream dialog
    // Since Xtream is requested, I'll create a simple dialog for it in the next step
    final flag = await showDialog(context: context, builder: (context) => const LiveEditPage());
    if (flag == true && context.mounted) {
       Navigator.of(context).pushReplacementNamed('/');
    }
  }

  void _singlePlay(BuildContext context) {
    // Navigate to a simple player with URL input
    // For now, just show a message or reuse LiveEdit
    _addM3uUrl(context);
  }
}
