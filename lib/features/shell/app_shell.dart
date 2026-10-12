import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/tokens.dart';
import '../../core/components/app_header.dart';
import '../../core/components/bottom_nav.dart';
import '../home/home_screen.dart';
import '../harvest/harvest_screen.dart';
import '../history/history_screen.dart';
import '../report/report_screen.dart';

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
        return _PlaceholderScreen(label: 'Scan');
      case BottomNavTab.report:
        return const ReportScreen();
      case BottomNavTab.history:
        return const HistoryScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: const AppHeader(),
      body: _buildBody(),
      bottomNavigationBar: BottomNav(
        active: _activeTab,
        onChange: (tab) => setState(() => _activeTab = tab),
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String label;
  const _PlaceholderScreen({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 18,
          color: AppColors.textMuted,
        ),
      ),
    );
  }
}
