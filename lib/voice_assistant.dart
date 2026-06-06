import 'package:flutter/material.dart';
import 'dart:math' as math;

enum VoiceState { idle, listening, thinking, speaking }

class VoiceAssistantScreen extends StatefulWidget {
  const VoiceAssistantScreen({Key? key}) : super(key: key);

  @override
  _VoiceAssistantScreenState createState() => _VoiceAssistantScreenState();
}

class _VoiceAssistantScreenState extends State<VoiceAssistantScreen> with TickerProviderStateMixin {
  VoiceState _currentState = VoiceState.idle;
  
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  
  String _statusText = "Tap orb to interact...";

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void _cycleState() {
    setState(() {
      switch (_currentState) {
        case VoiceState.idle:
          _currentState = VoiceState.listening;
          _statusText = "Listening...";
          _pulseController.duration = const Duration(milliseconds: 800);
          _pulseController.repeat(reverse: true);
          _rotationController.duration = const Duration(seconds: 5);
          _rotationController.repeat();
          break;
        case VoiceState.listening:
          _currentState = VoiceState.thinking;
          _statusText = "Analyzing CBSL bond yield trends...";
          _pulseController.duration = const Duration(milliseconds: 1500);
          _pulseController.repeat(reverse: true);
          _rotationController.duration = const Duration(seconds: 3);
          _rotationController.repeat();
          break;
        case VoiceState.thinking:
          _currentState = VoiceState.speaking;
          _statusText = "Here is what I found...";
          _pulseController.duration = const Duration(milliseconds: 400);
          _pulseController.repeat(reverse: true);
          _rotationController.duration = const Duration(seconds: 8);
          _rotationController.repeat();
          break;
        case VoiceState.speaking:
          _currentState = VoiceState.idle;
          _statusText = "Tap orb to interact...";
          _pulseController.duration = const Duration(milliseconds: 2000);
          _pulseController.repeat(reverse: true);
          _rotationController.duration = const Duration(seconds: 10);
          _rotationController.repeat();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Stack(
          children: [
            // Clean Close Button
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white70, size: 36),
                onPressed: () => Navigator.of(context).pop(),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
            ),
            
            // Main Content: Central Animated Orb & Minimalist Metadata
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _cycleState, // Tap to cycle through states for demonstration
                    child: AnimatedBuilder(
                      animation: Listenable.merge([_pulseController, _rotationController]),
                      builder: (context, child) {
                        return CustomPaint(
                          painter: OrbPainter(
                            pulseValue: _pulseController.value,
                            rotationValue: _rotationController.value,
                            state: _currentState,
                          ),
                          child: const SizedBox(
                            width: 200,
                            height: 200,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 60),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    child: Text(
                      _statusText,
                      key: ValueKey<String>(_statusText),
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrbPainter extends CustomPainter {
  final double pulseValue;
  final double rotationValue;
  final VoiceState state;

  OrbPainter({
    required this.pulseValue,
    required this.rotationValue,
    required this.state,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width / 4;

    Color primaryColor;
    Color secondaryColor;
    
    // Smoothly transition colors based on state
    switch (state) {
      case VoiceState.idle:
        primaryColor = Colors.grey.withOpacity(0.2);
        secondaryColor = Colors.grey.withOpacity(0.05);
        break;
      case VoiceState.listening:
        primaryColor = Colors.blueAccent.withOpacity(0.5);
        secondaryColor = Colors.lightBlue.withOpacity(0.2);
        break;
      case VoiceState.thinking:
        primaryColor = Colors.purpleAccent.withOpacity(0.5);
        secondaryColor = Colors.deepPurple.withOpacity(0.2);
        break;
      case VoiceState.speaking:
        primaryColor = Colors.tealAccent.withOpacity(0.5);
        secondaryColor = Colors.teal.withOpacity(0.2);
        break;
    }

    final paintPrimary = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25);

    final paintSecondary = Paint()
      ..color = secondaryColor
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40);
      
    final paintCore = Paint()
      ..color = Colors.white.withOpacity(state == VoiceState.idle ? 0.05 : 0.3)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotationValue * 2 * math.pi);
    
    // Calculate scaling dynamics based on the current voice state
    double scale1 = 1.0 + (pulseValue * 0.2);
    double scale2 = 1.0 + ((1.0 - pulseValue) * 0.3);
    double scale3 = 1.0 + (math.sin(pulseValue * math.pi) * 0.15);

    if (state == VoiceState.speaking) {
      // More jagged, rapid scaling to simulate speaking waveforms
      scale1 += math.sin(pulseValue * math.pi * 5) * 0.15;
      scale2 += math.cos(pulseValue * math.pi * 4) * 0.15;
    } else if (state == VoiceState.thinking) {
      // Smooth, deep, slow pulsing for thinking
      scale1 = 1.0 + (pulseValue * 0.1);
      scale2 = 1.0 + ((1.0 - pulseValue) * 0.1);
    } else if (state == VoiceState.listening) {
      // Expanded and alert for listening
      scale1 = 1.1 + (pulseValue * 0.25);
      scale2 = 1.1 + ((1.0 - pulseValue) * 0.35);
    }

    // Outer soft overlapping blob 1
    canvas.save();
    canvas.scale(scale1, scale1 * 0.9);
    canvas.drawCircle(const Offset(15, 15), baseRadius, paintSecondary);
    canvas.restore();

    // Outer soft overlapping blob 2
    canvas.save();
    canvas.rotate(math.pi / 3);
    canvas.scale(scale2 * 0.9, scale2);
    canvas.drawCircle(const Offset(-15, -10), baseRadius * 1.15, paintPrimary);
    canvas.restore();
    
    // Core inner orb
    canvas.save();
    canvas.scale(scale3, scale3);
    canvas.drawCircle(Offset.zero, baseRadius * 0.75, paintCore);
    canvas.restore();

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant OrbPainter oldDelegate) {
    return oldDelegate.pulseValue != pulseValue || 
           oldDelegate.rotationValue != rotationValue ||
           oldDelegate.state != state;
  }
}
