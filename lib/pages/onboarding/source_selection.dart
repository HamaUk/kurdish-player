import 'package:flutter/material.dart';
import '../../components/logo.dart';
import '../../l10n/app_localizations.dart';
import 'm3u_login.dart';
import 'xtream_login.dart';

class SourceSelectionPage extends StatelessWidget {
  const SourceSelectionPage({super.key});

  static const _darkTop = Color(0xFF0B1020);
  static const _darkBottom = Color(0xFF05070F);
  static const _cardColor = Color(0x99141A2A);
  static const _specialCardColor = Color(0x99303A56);
  static const _accent = Color(0xFF5E7BFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_darkTop, _darkBottom],
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
                        color: Colors.white,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(context)!.onboardingSubtitle,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        width: 400,
        decoration: BoxDecoration(
          color: isSpecial ? _specialCardColor : _cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSpecial ? _accent.withOpacity(0.4) : Colors.white10,
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
                    color: isSpecial ? _accent : _accent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.white54,
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
