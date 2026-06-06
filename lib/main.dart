import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dashboard.dart';
import 'sip_calculator.dart';
import 'voice_assistant.dart';
import 'macro_analytics.dart';
import 'asset_allocator.dart';
import 'premium_settings.dart';

void main() {
  runApp(const SalliApp());
}

class SalliApp extends StatelessWidget {
  const SalliApp({super.key});

  static const Color scaffoldColor = Color(0xFF121212);
  static const Color accentColor = Color(0xFF00FFA3);
  static const Color surfaceColor = Color(0xFF1E1E1E);

  @override
  Widget build(BuildContext context) {
    final baseDark = ThemeData.dark();
    final textTheme = GoogleFonts.interTextTheme(
      baseDark.textTheme,
    ).apply(bodyColor: Colors.white, displayColor: Colors.white);

    return MaterialApp(
      title: 'Salli',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary: accentColor,
          surface: surfaceColor,
          background: scaffoldColor,
          onPrimary: Colors.black,
          onSurface: Colors.white,
        ),
        scaffoldBackgroundColor: scaffoldColor,
        primaryColor: accentColor,
        cardColor: surfaceColor,
        textTheme: textTheme,
        appBarTheme: AppBarTheme(
          backgroundColor: surfaceColor,
          foregroundColor: Colors.white,
          titleTextStyle: textTheme.titleLarge,
          elevation: 0,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: const Color(0xFF1A1A1A),
          selectedItemColor: accentColor,
          unselectedItemColor: Colors.white54,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.5),
          unselectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 0.5),
        ),
      ),
      home: const MainOrchestrator(),
    );
  }
}

// Hub 1: Wealth Wrapper to include Dashboard and an expandable entry to Asset Allocator
class WealthHub extends StatelessWidget {
  const WealthHub({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Expandable card for Asset Allocator
        Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: Icon(Icons.pie_chart_outline, color: SalliApp.accentColor),
              title: const Text(
                "Asset Allocator",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              ),
              subtitle: Text(
                "Manage portfolio diversification",
                style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2C2C2C),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const AssetAllocatorScreen()));
                      },
                      child: const Text("OPEN ALLOCATOR", style: TextStyle(fontSize: 11, letterSpacing: 1.2)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // The main dashboard expands to fill the rest of the screen
        const Expanded(child: DashboardScreen()),
      ],
    );
  }
}

class MainOrchestrator extends StatefulWidget {
  const MainOrchestrator({super.key});

  @override
  State<MainOrchestrator> createState() => _MainOrchestratorState();
}

class _MainOrchestratorState extends State<MainOrchestrator> {
  int _currentIndex = 0;

  // The 4 primary hubs
  final List<Widget> _hubs = [
    const WealthHub(),
    const SipCalculatorScreen(),
    MacroAnalyticsScreen(),
    const PremiumSettingsScreen(),
  ];

  void _triggerVoiceAssistant() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, 
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.85, // 85% screen height slide-up
            child: const VoiceAssistantScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _hubs,
        ),
      ),
      // Floating Audio Trigger
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: SalliApp.accentColor.withOpacity(0.25),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: _triggerVoiceAssistant,
          backgroundColor: const Color(0xFF2C2C2C), // Contrast against the bar
          elevation: 0,
          shape: const CircleBorder(),
          child: Icon(Icons.mic_none, color: SalliApp.accentColor, size: 28),
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (idx) => setState(() => _currentIndex = idx),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              activeIcon: Icon(Icons.account_balance_wallet),
              label: 'Wealth',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calculate_outlined),
              activeIcon: Icon(Icons.calculate),
              label: 'Calculators',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.insights_outlined),
              activeIcon: Icon(Icons.insights),
              label: 'Intelligence',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
