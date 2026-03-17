import 'package:intl/intl.dart';

class IndiaFormatter {
  /// Format number in Indian system (Lakhs, Crores)
  static String formatCurrency(double amount) {
    if (amount >= 10000000) {
      return '₹${(amount / 10000000).toStringAsFixed(2)} Cr';
    } else if (amount >= 100000) {
      return '₹${(amount / 100000).toStringAsFixed(2)} L';
    } else if (amount >= 1000) {
      return '₹${(amount / 1000).toStringAsFixed(0)}K';
    }
    return '₹${amount.toStringAsFixed(0)}';
  }

  /// Format date in DD-MM-YYYY
  static String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  /// Format date with month name
  static String formatDateFull(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  /// Format time as HH:mm
  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  /// Format GSTIN display
  static String formatGSTIN(String gstin) {
    if (gstin.length == 15) {
      return '${gstin.substring(0, 2)}-${gstin.substring(2, 12)}-${gstin.substring(12)}';
    }
    return gstin;
  }

  /// Format PAN display
  static String formatPAN(String pan) {
    if (pan.length == 10) {
      return '${pan.substring(0, 5)}-${pan.substring(5, 9)}-${pan.substring(9)}';
    }
    return pan;
  }

  /// Days until due
  static String daysUntilDue(DateTime dueDate) {
    final diff = dueDate.difference(DateTime.now()).inDays;
    if (diff < 0) return 'Overdue by ${(-diff)} days';
    if (diff == 0) return 'Due Today';
    if (diff == 1) return 'Due Tomorrow';
    return 'Due in $diff days';
  }

  /// Format large number with commas (Indian system)
  static String formatNumber(double amount) {
    final formatter = NumberFormat('#,##,##,###', 'en_IN');
    return formatter.format(amount.toInt());
  }
}
