import 'package:flutter/material.dart';

class PremiumSettingsScreen extends StatelessWidget {
  const PremiumSettingsScreen({Key? key}) : super(key: key);

  final Color _neonGreenAccent = const Color(0xFF00FF66);

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 32, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.white54,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 2.5,
        ),
      ),
    );
  }

  Widget _buildActionTile({required String title, required String subtitle, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap ?? () {},
      splashColor: Colors.transparent,
      highlightColor: _neonGreenAccent.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Icon(
              Icons.chevron_right, 
              color: _neonGreenAccent.withOpacity(0.8), 
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleTile({
    required String title, 
    required String subtitle, 
    required bool value, 
    ValueChanged<bool>? onChanged
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: _neonGreenAccent,
            activeTrackColor: _neonGreenAccent.withOpacity(0.25),
            inactiveThumbColor: Colors.white54,
            inactiveTrackColor: Colors.white12,
            splashRadius: 24,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w300,
            letterSpacing: 1.2,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white70),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 50),
        children: [
          _buildSectionHeader('Security & Biometrics'),
          _buildActionTile(
            title: 'FaceID / TouchID Authentication',
            subtitle: 'Secure your wealth vault via local device biometrics.',
          ),
          _buildActionTile(
            title: 'Recovery Phrase Backup',
            subtitle: 'View and export your decentralized seed phrase.',
          ),
          
          _buildSectionHeader('Autonomous Automation Level'),
          // In a real app, these would be managed by state (Provider/Riverpod/Bloc).
          // Kept hardcoded in this stateless representation for design layout.
          _buildToggleTile(
            title: 'Background SMS Expense Auditing',
            subtitle: 'AI automatically categorizes incoming transaction SMS.',
            value: true,
            onChanged: (val) {},
          ),
          _buildToggleTile(
            title: 'Instant Voice Initialization',
            subtitle: 'Allow the ambient voice companion to listen upon app launch.',
            value: false,
            onChanged: (val) {},
          ),
          _buildToggleTile(
            title: 'Automated Defensive Rebalancing',
            subtitle: 'Automatically shift allocations to local FDs when market drops >5%.',
            value: true,
            onChanged: (val) {},
          ),

          _buildSectionHeader('System Preferences'),
          _buildActionTile(
            title: 'Default Currency Display',
            subtitle: 'LKR (Sri Lankan Rupee)',
          ),
          _buildActionTile(
            title: 'Aesthetic Theme',
            subtitle: 'Obsidian Dark (System Default)',
          ),
          _buildActionTile(
            title: 'Export Tax & Analytics Data',
            subtitle: 'Generate formatted CSV reports for personal auditing.',
          ),
          
          const SizedBox(height: 50),
          Center(
            child: Text(
              "SALLI AI · V 1.0.0",
              style: TextStyle(
                color: Colors.white.withOpacity(0.15),
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 3.0,
              ),
            ),
          )
        ],
      ),
    );
  }
}
