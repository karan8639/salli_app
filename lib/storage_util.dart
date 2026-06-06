import 'package:shared_preferences/shared_preferences.dart';

/// StorageUtil - Offline 'Database' for Salli App
///
/// This utility class manages all local data persistence using SharedPreferences.
/// It acts as the single source of truth for user financial data when offline,
/// allowing the app to function seamlessly without backend connectivity.
///
/// All methods are static and async, enabling easy access from anywhere in the app.
class StorageUtil {
  // Private keys for SharedPreferences storage
  static const String _keyTotalBalance = 'total_balance';
  static const String _keyMonthlyContribution = 'monthly_contribution';
  static const String _keyVaultNote = 'vault_note';

  // Default values
  static const double _defaultBalance = 1250000.0;
  static const double _defaultContribution = 25000.0;

  /// Save total net worth/balance to local storage
  ///
  /// This persists the user's total balance on the device so it remains
  /// available even when the app is closed or offline.
  ///
  /// Example:
  /// ```dart
  /// await StorageUtil.saveTotalBalance(1500000.0);
  /// ```
  static Future<void> saveTotalBalance(double amount) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_keyTotalBalance, amount);
    } catch (e) {
      print('Error saving total balance: $e');
    }
  }

  /// Retrieve total net worth/balance from local storage
  ///
  /// Returns the stored balance or [_defaultBalance] (1,250,000 LKR) if no value exists.
  /// This ensures the app always has a meaningful value to display.
  ///
  /// Example:
  /// ```dart
  /// final balance = await StorageUtil.getTotalBalance();
  /// ```
  static Future<double> getTotalBalance() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getDouble(_keyTotalBalance) ?? _defaultBalance;
    } catch (e) {
      print('Error retrieving total balance: $e');
      return _defaultBalance;
    }
  }

  /// Save monthly SIP contribution amount to local storage
  ///
  /// Stores the user's regular monthly investment amount, which is used
  /// by the SIP calculator and financial dashboards.
  ///
  /// Example:
  /// ```dart
  /// await StorageUtil.saveMonthlyContribution(50000.0);
  /// ```
  static Future<void> saveMonthlyContribution(double amount) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_keyMonthlyContribution, amount);
    } catch (e) {
      print('Error saving monthly contribution: $e');
    }
  }

  /// Retrieve monthly SIP contribution from local storage
  ///
  /// Returns the stored contribution amount or [_defaultContribution] (25,000 LKR)
  /// if no value has been set. Gracefully handles errors to ensure app stability.
  ///
  /// Example:
  /// ```dart
  /// final contribution = await StorageUtil.getMonthlyContribution();
  /// ```
  static Future<double> getMonthlyContribution() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getDouble(_keyMonthlyContribution) ?? _defaultContribution;
    } catch (e) {
      print('Error retrieving monthly contribution: $e');
      return _defaultContribution;
    }
  }

  /// Clear all stored data (useful for testing or account reset)
  ///
  /// Removes all balance and contribution data from local storage.
  /// Use with caution as this operation is permanent.
  ///
  /// Example:
  /// ```dart
  /// await StorageUtil.clearAllData();
  /// ```
  static Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyTotalBalance);
      await prefs.remove(_keyMonthlyContribution);
      await prefs.remove(_keyVaultNote);
    } catch (e) {
      print('Error clearing data: $e');
    }
  }

  /// Save secure vault note to local storage
  ///
  /// Stores a user's confidential note or asset statement securely on device.
  /// This data persists across app sessions but remains local to the device.
  ///
  /// Example:
  /// ```dart
  /// await StorageUtil.saveVaultNote('My secret asset list...');
  /// ```
  static Future<void> saveVaultNote(String note) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyVaultNote, note);
    } catch (e) {
      print('Error saving vault note: $e');
    }
  }

  /// Retrieve secure vault note from local storage
  ///
  /// Returns the stored vault note or an empty string if no note exists.
  /// Gracefully handles errors to ensure app stability.
  ///
  /// Example:
  /// ```dart
  /// final note = await StorageUtil.getVaultNote();
  /// ```
  static Future<String> getVaultNote() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyVaultNote) ?? '';
    } catch (e) {
      print('Error retrieving vault note: $e');
      return '';
    }
  }
}
