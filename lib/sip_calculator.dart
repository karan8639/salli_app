import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;

class SipCalculatorScreen extends StatefulWidget {
  const SipCalculatorScreen({super.key});

  @override
  State<SipCalculatorScreen> createState() => _SipCalculatorScreenState();
}

class _SipCalculatorScreenState extends State<SipCalculatorScreen> {
  static const Color accentColor = Color(0xFF00FFA3);
  static const Color surfaceColor = Color(0xFF1E1E1E);

  // Slider values
  double monthlyInvestment = 25000; // Default: 25,000 LKR
  double timePeriod = 10; // Default: 10 years
  double expectedReturn = 12; // Default: 12%

  @override
  Widget build(BuildContext context) {
    final futureValue = _calculateSIP(
      monthlyInvestment,
      timePeriod,
      expectedReturn,
    );

    final chartData = _generateChartData(
      monthlyInvestment,
      timePeriod,
      expectedReturn,
    );

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(),
            const SizedBox(height: 28),

            // Monthly Investment Slider
            _buildSliderSection(
              label: 'Monthly Investment',
              value: monthlyInvestment,
              minValue: 5000,
              maxValue: 100000,
              onChanged: (value) {
                setState(() => monthlyInvestment = value);
              },
              suffix: ' LKR',
              divisions: 95,
            ),
            const SizedBox(height: 28),

            // Time Period Slider
            _buildSliderSection(
              label: 'Time Period',
              value: timePeriod,
              minValue: 1,
              maxValue: 30,
              onChanged: (value) {
                setState(() => timePeriod = value);
              },
              suffix: ' Years',
              divisions: 29,
            ),
            const SizedBox(height: 28),

            // Expected Annual Return Slider
            _buildSliderSection(
              label: 'Expected Annual Return',
              value: expectedReturn,
              minValue: 5,
              maxValue: 20,
              onChanged: (value) {
                setState(() => expectedReturn = value);
              },
              suffix: '%',
              divisions: 150,
            ),
            const SizedBox(height: 32),

            // Results Card
            _buildResultsCard(futureValue),
            const SizedBox(height: 28),

            // Chart
            _buildChartSection(chartData),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SIP Calculator',
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Plan your investment journey',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildSliderSection({
    required String label,
    required double value,
    required double minValue,
    required double maxValue,
    required Function(double) onChanged,
    required String suffix,
    required int divisions,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.87),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: accentColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                '${_formatNumber(value)}$suffix',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: accentColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(
              elevation: 0,
              enabledThumbRadius: 12,
            ),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
            activeTrackColor: accentColor,
            inactiveTrackColor: Colors.white12,
            thumbColor: accentColor,
            overlayColor: accentColor.withOpacity(0.2),
          ),
          child: Slider(
            value: value,
            min: minValue,
            max: maxValue,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildResultsCard(Map<String, double> futureValue) {
    final fv = futureValue['futureValue'] ?? 0;
    final invested = futureValue['invested'] ?? 0;
    final gains = futureValue['gains'] ?? 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Investment Summary',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem(
                label: 'Total Invested',
                value: 'LKR ${_formatCurrency(invested)}',
                valueColor: Colors.white,
              ),
              _buildSummaryItem(
                label: 'Investment Gains',
                value: 'LKR ${_formatCurrency(gains)}',
                valueColor: accentColor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.white10, height: 1),
          const SizedBox(height: 12),
          _buildSummaryItem(
            label: 'Future Value',
            value: 'LKR ${_formatCurrency(fv)}',
            valueColor: accentColor,
            isBold: true,
            fontSize: 18,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required String label,
    required String value,
    required Color valueColor,
    bool isBold = false,
    double fontSize = 14,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildChartSection(List<FlSpot> chartData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Portfolio Growth',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10, width: 1),
          ),
          child: SizedBox(
            height: 280,
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: chartData,
                    isCurved: true,
                    curveSmoothness: 0.4,
                    color: accentColor,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: accentColor.withOpacity(0.1),
                    ),
                  ),
                ],
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  drawVerticalLine: false,
                  horizontalInterval: _getGridInterval(chartData),
                  getDrawingHorizontalLine: (value) {
                    return FlLine(color: Colors.white10, strokeWidth: 1);
                  },
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: timePeriod,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Calculate SIP future value using the formula:
  /// FV = P × [((1 + r)^n - 1) / r] × (1 + r)
  /// Where:
  /// - P = monthly investment
  /// - r = monthly interest rate (annual return / 12 / 100)
  /// - n = number of months (years × 12)
  Map<String, double> _calculateSIP(
    double monthlyInvestment,
    double years,
    double annualReturnPercent,
  ) {
    final monthlyRate = annualReturnPercent / 12 / 100;
    final totalMonths = years * 12;

    // Handle edge case of 0% return
    double futureValue;
    if (monthlyRate == 0) {
      futureValue = monthlyInvestment * totalMonths;
    } else {
      futureValue =
          monthlyInvestment *
          ((math.pow(1 + monthlyRate, totalMonths) - 1) / monthlyRate) *
          (1 + monthlyRate);
    }

    final totalInvested = monthlyInvestment * totalMonths;
    final gains = futureValue - totalInvested;

    return {
      'futureValue': futureValue,
      'invested': totalInvested,
      'gains': gains,
    };
  }

  /// Generate chart data points for portfolio growth over years
  List<FlSpot> _generateChartData(
    double monthlyInvestment,
    double years,
    double annualReturnPercent,
  ) {
    final monthlyRate = annualReturnPercent / 12 / 100;
    final dataPoints = <FlSpot>[];

    for (int year = 0; year <= years.toInt(); year++) {
      final totalMonths = year * 12;
      double value;

      if (monthlyRate == 0) {
        value = monthlyInvestment * totalMonths;
      } else {
        if (totalMonths == 0) {
          value = 0;
        } else {
          value =
              monthlyInvestment *
              ((math.pow(1 + monthlyRate, totalMonths) - 1) / monthlyRate) *
              (1 + monthlyRate);
        }
      }

      dataPoints.add(FlSpot(year.toDouble(), value));
    }

    return dataPoints;
  }

  /// Format large numbers for display (e.g., 1000000 → 1,000,000)
  String _formatNumber(double value) {
    if (value >= 1000) {
      return (value / 1000)
              .toStringAsFixed(0)
              .replaceAll('.0', '')
              .padRight(5, '0') +
          'K';
    }
    return value.toStringAsFixed(0);
  }

  /// Format currency with commas (e.g., 1250000.50 → 1,250,000.50)
  String _formatCurrency(double value) {
    final formatted = value.toStringAsFixed(2);
    final parts = formatted.split('.');
    final intPart = parts[0];
    final fracPart = parts[1];

    final buffer = StringBuffer();
    for (int i = intPart.length - 1; i >= 0; i--) {
      if ((intPart.length - i - 1) % 3 == 0 && i != intPart.length - 1) {
        buffer.write(',');
      }
      buffer.write(intPart[i]);
    }

    return buffer.toString().split('').reversed.join('') + '.$fracPart';
  }

  /// Get appropriate grid interval for chart Y-axis
  double _getGridInterval(List<FlSpot> data) {
    if (data.isEmpty) return 100000;
    final maxValue = data.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    return (maxValue / 5).ceilToDouble();
  }
}
