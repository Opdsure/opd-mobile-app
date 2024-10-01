import 'package:intl/intl.dart';

void main() {
  // Create a formatter for the number with commas
  final formatter = NumberFormat('#,##,###');

  // Example number
  double amount = 100000000.890;

  // Format the number and print it
  String formattedAmount = formatter.format(amount);

  print(formattedAmount);  // Outputs: 1,000
}
