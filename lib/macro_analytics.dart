import 'package:flutter/material.dart';

enum ImpactRating { high, medium, low }

class MacroInsight {
  final String title;
  final ImpactRating impactRating;
  final String description;
  final String recommendedAction;
  final String geopoliticalVector;
  final String cseImpact;
  final String treasuryBondImpact;

  MacroInsight({
    required this.title,
    required this.impactRating,
    required this.description,
    required this.recommendedAction,
    required this.geopoliticalVector,
    required this.cseImpact,
    required this.treasuryBondImpact,
  });
}

class MacroAnalyticsScreen extends StatelessWidget {
  MacroAnalyticsScreen({Key? key}) : super(key: key);

  // Mock data tailored for the Sri Lankan context based on global events
  final List<MacroInsight> insights = [
    MacroInsight(
      title: "US Federal Reserve Rate Cuts",
      impactRating: ImpactRating.high,
      description: "Anticipated 50 bps reduction by the Fed following cooling inflation data and stabilizing labor markets in the US.",
      recommendedAction: "Increase exposure to emerging market equities and high-yield fixed income before local rates adjust.",
      geopoliticalVector: "Global Monetary Policy",
      cseImpact: "Positive foreign capital inflows likely to stimulate CSE blue-chip counters as global liquidity improves and yield-seeking behavior rises.",
      treasuryBondImpact: "Expect CBSL to mirror rate cuts, causing a rally in existing long-term Treasury bonds. Yields will face significant downward pressure.",
    ),
    MacroInsight(
      title: "Middle Eastern Geopolitical Tensions",
      impactRating: ImpactRating.high,
      description: "Escalating conflicts disrupting major supply chains and putting upward pressure on global energy prices.",
      recommendedAction: "Hedge with export-oriented manufacturing stocks and short-duration cash equivalents.",
      geopoliticalVector: "Global Oil Fluctuations",
      cseImpact: "Negative sentiment for local manufacturing and transport sectors due to imported inflation and higher operational costs.",
      treasuryBondImpact: "Inflationary pressures may stall expected CBSL rate cuts, making short-term Treasury bills more attractive than locking into long-term bonds.",
    ),
    MacroInsight(
      title: "IMF Extended Fund Facility Review",
      impactRating: ImpactRating.medium,
      description: "Upcoming staff-level agreement on the next tranche of the EFF program, dependent on maintaining structural reforms and revenue targets.",
      recommendedAction: "Maintain diversified portfolio; accumulate undervalued banking sector stocks on periodic market dips.",
      geopoliticalVector: "Sovereign Debt Restructuring",
      cseImpact: "Banking and financial sector stocks will see moderate volatility but likely upside upon successful review completion and debt restructuring finalization.",
      treasuryBondImpact: "Successful review will boost international confidence, potentially stabilizing sovereign yields and reducing the local risk premium.",
    ),
    MacroInsight(
      title: "Global Supply Chain Normalization",
      impactRating: ImpactRating.low,
      description: "Shipping costs and delivery times are returning to pre-pandemic averages, easing global goods inflation.",
      recommendedAction: "Review logistics and retail holdings; focus on companies showing volume growth over price-led growth.",
      geopoliticalVector: "International Trade Dynamics",
      cseImpact: "Positive for retail and FMCG sectors on the CSE as import costs stabilize and margins improve.",
      treasuryBondImpact: "Neutral to mildly positive. Assists in keeping core inflation low, supporting a stable interest rate environment.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Macro Analytics",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w300,
            letterSpacing: 1.2,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white70),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: insights.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _MacroInsightCard(insight: insights[index]),
          );
        },
      ),
    );
  }
}

class _MacroInsightCard extends StatelessWidget {
  final MacroInsight insight;

  const _MacroInsightCard({Key? key, required this.insight}) : super(key: key);

  Color _getImpactColor() {
    switch (insight.impactRating) {
      case ImpactRating.high:
        return const Color(0xFFE57373); // Soft red for high impact/risk
      case ImpactRating.medium:
        return const Color(0xFFFFB74D); // Soft orange for medium impact
      case ImpactRating.low:
        return const Color(0xFF81C784); // Soft green for low impact
    }
  }

  String _getImpactLabel() {
    switch (insight.impactRating) {
      case ImpactRating.high:
        return "HIGH IMPACT";
      case ImpactRating.medium:
        return "MEDIUM IMPACT";
      case ImpactRating.low:
        return "LOW IMPACT";
    }
  }

  @override
  Widget build(BuildContext context) {
    final impactColor = _getImpactColor();

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          // Thin border with low-opacity active color to indicate risk weight
          color: impactColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Vector Micro-label & Impact Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  insight.geopoliticalVector.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: impactColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: impactColor.withOpacity(0.4),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _getImpactLabel(),
                    style: TextStyle(
                      color: impactColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 18),
          
          // Title
          Text(
            insight.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          
          // Description
          Text(
            insight.description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
              height: 1.5,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 24),
          
          // Sri Lankan Context Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.03)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.insights, size: 14, color: Colors.white.withOpacity(0.5)),
                    const SizedBox(width: 8),
                    Text(
                      "LOCAL MARKET IMPACT",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _ContextRow(
                  label: "CSE Equities",
                  text: insight.cseImpact,
                ),
                const SizedBox(height: 12),
                Divider(color: Colors.white.withOpacity(0.05), height: 1),
                const SizedBox(height: 12),
                _ContextRow(
                  label: "Treasury Bonds",
                  text: insight.treasuryBondImpact,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Recommended Action
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: impactColor.withOpacity(0.8),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "RECOMMENDED ACTION",
                      style: TextStyle(
                        color: impactColor.withOpacity(0.8),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      insight.recommendedAction,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 13,
                        height: 1.4,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContextRow extends StatelessWidget {
  final String label;
  final String text;

  const _ContextRow({Key? key, required this.label, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 13,
              height: 1.5,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }
}
