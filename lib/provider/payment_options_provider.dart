import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/payment_options_viewmodel.dart';
import '../models/payment_option.dart';

final paymentOptionsProvider =
    StateNotifierProvider<PaymentOptionsViewModel, PaymentOption?>(
        (ref) => PaymentOptionsViewModel());
