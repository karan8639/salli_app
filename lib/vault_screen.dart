import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'storage_util.dart';

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen>
    with TickerProviderStateMixin {
  static const Color accentColor = Color(0xFF00FFA3);
  static const Color surfaceColor = Color(0xFF1E1E1E);

  late TextEditingController _noteController;
  late AnimationController _lockAnimationController;
  late Animation<double> _lockRotation;

  bool _isLocked = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
    _lockAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _lockRotation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _lockAnimationController,
        curve: Curves.easeInOutBack,
      ),
    );
    _loadSavedNote();
  }

  @override
  void dispose() {
    _noteController.dispose();
    _lockAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedNote() async {
    final saved = await StorageUtil.getVaultNote();
    if (mounted) {
      setState(() {
        _noteController.text = saved;
        _isLocked = saved.isNotEmpty;
        if (_isLocked) {
          _lockAnimationController.forward();
        }
      });
    }
  }

  Future<void> _lockIntoVault() async {
    if (_noteController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter a note before locking',
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          backgroundColor: Colors.red.withOpacity(0.8),
          duration: const Duration(milliseconds: 2000),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    await Future.delayed(const Duration(milliseconds: 200));
    await StorageUtil.saveVaultNote(_noteController.text);

    if (mounted) {
      setState(() => _isSaving = false);
      _lockAnimationController.forward();
      setState(() => _isLocked = true);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '🔒 Your note is securely locked',
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          backgroundColor: accentColor.withOpacity(0.8),
          duration: const Duration(milliseconds: 2500),
        ),
      );
    }
  }

  void _unlockVault() {
    _lockAnimationController.reverse();
    setState(() => _isLocked = false);
  }

  Widget _buildLockIcon() {
    return RotationTransition(
      turns: _lockRotation,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: accentColor.withOpacity(0.08),
          border: Border.all(color: accentColor.withOpacity(0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(_isLocked ? 0.4 : 0.15),
              blurRadius: _isLocked ? 28 : 16,
              spreadRadius: _isLocked ? 2 : 0,
            ),
          ],
        ),
        child: Icon(
          _isLocked ? Icons.lock : Icons.lock_open_rounded,
          color: accentColor,
          size: 52,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Secure Vault',
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Store confidential notes & asset statements',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildNoteInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Secure Personal Note / Asset Statement',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white.withOpacity(0.87),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: accentColor.withOpacity(0.2), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: _noteController,
            enabled: !_isLocked,
            maxLines: 8,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              hintText: 'Enter your confidential notes here...',
              hintStyle: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.white38,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: InputBorder.none,
            ),
            cursorColor: accentColor,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _isSaving
            ? Container(
                height: 56,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.black,
                      ),
                    ),
                  ),
                ),
              )
            : _isLocked
            ? GestureDetector(
                onTap: _unlockVault,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Unlock to Edit',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              )
            : GestureDetector(
                onTap: _lockIntoVault,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Lock into Vault',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(),
            const SizedBox(height: 40),

            // Lock Icon
            Center(child: _buildLockIcon()),
            const SizedBox(height: 40),

            // Note Input
            _buildNoteInput(),
            const SizedBox(height: 28),

            // Action Button
            _buildActionButtons(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
