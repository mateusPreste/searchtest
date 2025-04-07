import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/contacts_viewmodel.dart';
import '../models/contact.dart';

final contactsNotifierProvider =
    AsyncNotifierProvider<ContactsNotifierSimple, List<Contact>>(
        ContactsNotifierSimple.new);
