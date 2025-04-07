import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/contact.dart';

class ContactsNotifierSimple extends AsyncNotifier<List<Contact>> {
  late final List<Contact> _allContacts;
  late String _searchQuery;
  late String _selectedFilter;

  @override
  Future<List<Contact>> build() async {
    // Initialize the complete contacts list
    _allContacts = [
      Contact(
          id: 0,
          name: 'Alice Johnson',
          phone: '123-456-7890',
          category: 'Family'),
      Contact(
          id: 1, name: 'Bob Smith', phone: '234-567-8901', category: 'Friends'),
      Contact(
          id: 2,
          name: 'Charlie Brown',
          phone: '345-678-9012',
          category: 'Work'),
      Contact(
          id: 3,
          name: 'David Williams',
          phone: '456-789-0123',
          category: 'Family'),
      Contact(
          id: 4, name: 'Eva Green', phone: '567-890-1234', category: 'Friends'),
      // Add more contacts as needed
    ];
    _searchQuery = "";
    _selectedFilter = "All";
    // Immediately return the current state (initially the unfiltered list)
    // Then perform a delayed update
    _loadContactsWithDelay();
    return _allContacts;
  }

  Future<void> _loadContactsWithDelay() async {
    // Simulate a delay of 2 seconds
    await Future.delayed(const Duration(seconds: 2));
    _updateFilteredContacts();
  }

  // Public getter to know which filter is selected
  String get selectedFilter => _selectedFilter;

  void updateSearchQuery(String query) {
    _searchQuery = query;
    _updateFilteredContacts();
  }

  void updateFilter(String filter) {
    _selectedFilter = filter;
    _updateFilteredContacts();
  }

  void _updateFilteredContacts() {
    final filtered = _allContacts.where((contact) {
      final matchesQuery =
          contact.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter =
          _selectedFilter == "All" || contact.category == _selectedFilter;
      return matchesQuery && matchesFilter;
    }).toList();
    state = AsyncData(filtered);
  }
}
