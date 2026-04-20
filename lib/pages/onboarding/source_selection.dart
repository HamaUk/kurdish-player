import 'package:flutter/material.dart';
import '../../components/logo.dart';
import '../../l10n/app_localizations.dart';
import 'm3u_login.dart';
import 'xtream_login.dart';

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
                  onTap: () => _addM3uFile(context),
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
                  onTap: () => _addM3uUrl(context),
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
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        width: 400,
        decoration: BoxDecoration(
          color: isSpecial 
              ? colorScheme.secondaryContainer.withOpacity(0.5) 
              : colorScheme.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSpecial 
                ? colorScheme.secondary.withOpacity(0.3) 
                : colorScheme.outline.withOpacity(0.1),
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSpecial 
                        ? colorScheme.secondary 
                        : colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: isSpecial 
                        ? colorScheme.onSecondary 
                        : colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addM3uUrl(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const M3uLoginPage(mode: M3uLoginMode.url),
      ),
    );
  }

  Future<void> _addM3uFile(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const M3uLoginPage(mode: M3uLoginMode.file),
      ),
    );
  }

  Future<void> _addXtream(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const XtreamLoginPage()),
    );
  }
}
