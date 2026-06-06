import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.nextPage});

  final Widget? nextPage;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const Color backgroundColor = Color(0xFF121212);
  static const Color surfaceColor = Color(0xFF1E1E1E);
  static const Color neonColor = Color(0xFF00FFA3);

  final List<int> _pin = [];

  void _onKeyTap(int value) {
    if (_pin.length >= 4) return;
    setState(() {
      _pin.add(value);
    });

    if (_pin.length == 4) {
      Future.delayed(const Duration(milliseconds: 200), _unlock);
    }
  }

  void _onDelete() {
    if (_pin.isEmpty) return;
    setState(() {
      _pin.removeLast();
    });
  }

  void _unlock() {
    final next = widget.nextPage ?? const _LoginSuccessScreen();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (context, animation, secondaryAnimation) => next,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final fade = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          );
          final scale = Tween<double>(begin: 0.92, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          );
          return FadeTransition(
            opacity: fade,
            child: ScaleTransition(scale: scale, child: child),
          );
        },
      ),
    );
  }

  Widget _buildLogo() {
    return RichText(
      text: TextSpan(
        text: 'Salli',
        style: GoogleFonts.inter(
          fontSize: 42,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: 0.6,
        ),
        children: [
          TextSpan(
            text: '.',
            style: GoogleFonts.inter(
              fontSize: 42,
              fontWeight: FontWeight.w800,
              color: neonColor,
              shadows: [
                BoxShadow(
                  color: neonColor.withOpacity(0.5),
                  blurRadius: 16,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Text(
      'Secure entry to your wealth',
      style: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: Colors.white70,
        letterSpacing: 0.2,
      ),
    );
  }

  Widget _buildPinDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        final active = index < _pin.length;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          width: active ? 20 : 16,
          height: active ? 20 : 16,
          decoration: BoxDecoration(
            color: active ? neonColor : Colors.white12,
            borderRadius: BorderRadius.circular(12),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: neonColor.withOpacity(0.35),
                      blurRadius: 18,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
            border: Border.all(
              color: active ? neonColor : Colors.white24,
              width: 1.2,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildKey(int number) {
    return GestureDetector(
      onTap: () => _onKeyTap(number),
      behavior: HitTestBehavior.translucent,
      child: Container(
        alignment: Alignment.center,
        width: 76,
        height: 76,
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white12, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Text(
          '$number',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildActionKey({required Widget child, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        alignment: Alignment.center,
        width: 76,
        height: 76,
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white12, width: 1.2),
        ),
        child: child,
      ),
    );
  }

  Widget _buildKeypad() {
    final keys = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var row = 0; row < 3; row++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: keys
                  .sublist(row * 3, row * 3 + 3)
                  .map((value) => _buildKey(value))
                  .toList(),
            ),
          ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildActionKey(
              onTap: () {
                if (_pin.length == 4) {
                  _unlock();
                }
              },
              child: Icon(Icons.fingerprint, color: neonColor, size: 30),
            ),
            _buildKey(0),
            _buildActionKey(
              onTap: _onDelete,
              child: Icon(
                Icons.backspace_outlined,
                color: Colors.white70,
                size: 28,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 28),
              _buildLogo(),
              const SizedBox(height: 8),
              _buildWelcomeText(),
              const SizedBox(height: 80),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 32,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFF181818),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: Colors.white10, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 28,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Enter your PIN',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 28),
                      _buildPinDots(),
                      const SizedBox(height: 30),
                      _buildKeypad(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginSuccessScreen extends StatelessWidget {
  const _LoginSuccessScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: Text(
          'Welcome to Salli',
          style: GoogleFonts.inter(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF00FFA3),
          ),
        ),
      ),
    );
  }
}
