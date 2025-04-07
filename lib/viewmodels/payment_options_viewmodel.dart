import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/payment_option.dart';

class PaymentOptionsViewModel extends StateNotifier<PaymentOption?> {
  PaymentOptionsViewModel() : super(null);

  void selectPaymentOption(PaymentOption option) {
    state = option;
  }
}
