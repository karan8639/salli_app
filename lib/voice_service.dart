/// A robust, lightweight local testing engine for the Salli AI voice companion.
/// 
/// This utility class simulates an intelligent, autonomous financial voice companion.
/// It uses a hardcoded response matrix to emulate network-bound AI processing,
/// providing highly specific, domain-aware responses tailored to Sri Lankan market conditions.
/// 
/// Usage in frontend presentation:
/// This service allows developers to perfectly test UI state transitions 
/// (Listening -> Thinking -> Speaking) in the VoiceAssistantScreen without 
/// requiring live LLM API keys or dealing with network latency unpredictability 
/// during live demonstrations.
class VoiceService {
  
  // Structured matrix of simulated AI intelligence responses, specifically 
  // geared towards the Sri Lankan economic context.
  static const Map<String, String> _responseMatrix = {
    'optimize portfolio': 'Analyzing Colombo Stock Exchange trends alongside the recent 8.75% CBSL policy adjustments. Recommending a 10% shift into defensive Treasury bonds to mitigate frontier market volatility.',
    'balance update': 'Your total net worth is secure at LKR 1,250,000.00. We are currently pacing 4% ahead of your target path for 2026.',
    'market status': 'The CSE All Share Index is showing strong resilience. Foreign capital inflows remain positive this week, particularly in the banking sector.',
    'risk alert': 'Notice: We detected elevated volatility in your digital asset allocations over the past 24 hours. Automated defensive rebalancing is currently on standby.',
  };

  /// Simulates sending a voice transcription to the AI processing engine.
  /// 
  /// The function intentionally delays execution for exactly 1.5 seconds 
  /// to accurately mimic computational "thinking" time, before returning a 
  /// highly precise, domain-specific response matched from the hardcoded matrix.
  static Future<String> sendVoiceCommand(String query) async {
    // 1. Simulate AI "thinking" time to trigger UI state changes
    await Future.delayed(const Duration(milliseconds: 1500));
    
    // 2. Normalize the input query for simple matching
    final normalizedQuery = query.toLowerCase().trim();
    
    // 3. Find the closest semantic match in our response matrix
    for (final key in _responseMatrix.keys) {
      if (normalizedQuery.contains(key)) {
        return _responseMatrix[key]!;
      }
    }
    
    // 4. Default graceful fallback if the engine cannot precisely map the user's intent
    return 'I am actively monitoring the local financial markets and CBSL indicators. Could you please specify if you would like a portfolio optimization or a target balance update?';
  }
}
