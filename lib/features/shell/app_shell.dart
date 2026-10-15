import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/tokens.dart';
import '../../core/components/app_header.dart';
import '../../core/components/bottom_nav.dart';
import '../home/home_screen.dart';
import '../scan/scan_screen.dart';
import '../harvest/harvest_screen.dart';
import '../history/history_screen.dart';
import '../report/report_screen.dart';
import '../auth/login_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  BottomNavTab _activeTab = BottomNavTab.home;

  Widget _buildBody() {
    switch (_activeTab) {
      case BottomNavTab.home:
        return const HomeScreen();
      case BottomNavTab.harvest:
        return HarvestScreen(
          onSaved: () => setState(() => _activeTab = BottomNavTab.home),
        );
      case BottomNavTab.scan:
        return ScanScreen(
          onBack: () => setState(() => _activeTab = BottomNavTab.home),
          onSavedToHistory: () => setState(() => _activeTab = BottomNavTab.history),
        );
      case BottomNavTab.report:
        return const ReportScreen();
      case BottomNavTab.history:
        return const HistoryScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Layar scan bersifat fullscreen immersif (DESIGN §8.3, §10 #2):
    // tanpa AppHeader dan tanpa BottomNav.
    final bool immersive = _activeTab == BottomNavTab.scan;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: immersive ? Brightness.light : Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: immersive
          ? null
          : AppHeader(
              onProfilePress: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
            ),
      body: _buildBody(),
      bottomNavigationBar: immersive
          ? null
          : BottomNav(
              active: _activeTab,
              onChange: (tab) => setState(() => _activeTab = tab),
            ),
    );
  }
}

