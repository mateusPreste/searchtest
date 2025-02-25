import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/contact.dart';
import '../viewmodels/contacts_viewmodel.dart';

final contactsProvider =
    StateNotifierProvider<ContactsViewModel, List<Contact>>(
  (ref) => ContactsViewModel(),
);
