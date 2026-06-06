import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';

enum RiskProfile { preservation, balanced, aggressive }

class AssetAllocatorScreen extends StatefulWidget {
  const AssetAllocatorScreen({Key? key}) : super(key: key);

  @override
  _AssetAllocatorScreenState createState() => _AssetAllocatorScreenState();
}

class _AssetAllocatorScreenState extends State<AssetAllocatorScreen> {
  RiskProfile _currentProfile = RiskProfile.balanced;
  bool _isOptimizing = false;

  // Target allocations based on Risk Shield Target
  // Order: [Local FDs, Gov Bonds, CSE Equity, Digital Assets]
  final Map<RiskProfile, List<double>> _allocations = {
    RiskProfile.preservation: [50, 40, 8, 2],
    RiskProfile.balanced: [20, 30, 40, 10],
    RiskProfile.aggressive: [5, 15, 50, 30],
  };

  final List<Color> _colors = [
    const Color(0xFF81C784), // FDs - Soft Green
    const Color(0xFF64B5F6), // Gov Bonds - Soft Blue
    const Color(0xFFFFB74D), // CSE Equity - Soft Orange
    const Color(0xFFBA68C8), // Digital Assets - Soft Purple
  ];

  final List<String> _labels = [
    "Local Fixed Deposits",
    "Government Bonds",
    "CSE Equity",
    "Digital Assets"
  ];

  void _onOptimizeTapped() async {
    setState(() {
      _isOptimizing = true;
    });

    // Simulate processing delay for elegant transition
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      setState(() {
        _isOptimizing = false;
        // In a real scenario, logic to update local configs goes here
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              "Portfolio optimized successfully.",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
            ),
            backgroundColor: const Color(0xFF2C2C2C),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 3),
          ),
        );
      });
    }
  }

  List<PieChartSectionData> _showingSections() {
    final values = _allocations[_currentProfile]!;
    return List.generate(4, (i) {
      return PieChartSectionData(
        color: _colors[i],
        value: values[i],
        title: '${values[i].toInt()}%',
        radius: 20, // Ultra-clean, thin pie chart slice
        titlePositionPercentageOffset: 0.5,
        titleStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      );
    });
  }

  Widget _buildToggleTab(RiskProfile profile, String label) {
    final isSelected = _currentProfile == profile;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentProfile = profile;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white.withOpacity(0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
            ),
          ),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white54,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
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
          "Asset Allocator",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w300,
            letterSpacing: 1.2,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white70),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Risk Shield Target Toggle
              Text(
                "RISK SHIELD TARGET",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    _buildToggleTab(RiskProfile.preservation, "Capital\nPreservation"),
                    _buildToggleTab(RiskProfile.balanced, "Balanced\nGrowth"),
                    _buildToggleTab(RiskProfile.aggressive, "Aggressive\nAlpha"),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Pie Chart
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(enabled: false),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 4,
                        centerSpaceRadius: 110, // Very large center space for an ultra-thin ring
                        sections: _showingSections(),
                      ),
                      swapAnimationDuration: const Duration(milliseconds: 800),
                      swapAnimationCurve: Curves.easeInOutCubic,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Total Asset\nDistribution",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                            height: 1.4,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Legend
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.03)),
                ),
                child: Column(
                  children: List.generate(4, (index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: index == 3 ? 0 : 14),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: _colors[index],
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _labels[index],
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const Spacer(),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            child: Text(
                              '${_allocations[_currentProfile]![index].toInt()}%',
                              key: ValueKey<double>(_allocations[_currentProfile]![index]),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 30),

              // Optimize & Rebalance Premium Button
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    colors: _isOptimizing
                        ? [const Color(0xFF1A1A1A), const Color(0xFF1A1A1A)]
                        : [const Color(0xFF333333), const Color(0xFF222222)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(_isOptimizing ? 0.05 : 0.15),
                    width: 1,
                  ),
                  boxShadow: _isOptimizing
                      ? []
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(28),
                    onTap: _isOptimizing ? null : _onOptimizeTapped,
                    child: Center(
                      child: _isOptimizing
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white54),
                              ),
                            )
                          : const Text(
                              "OPTIMIZE & REBALANCE PORTFOLIO",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
