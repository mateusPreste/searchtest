import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/models/contact.dart';

import '../provider/contact_provider.dart';
import '../viewmodels/contacts_viewmodel.dart';

// Define the filter options as a constant outside the class
const List<String> filterOptions = ['All', 'Family', 'Friends', 'Work'];

class ContactsSearchPage extends HookConsumerWidget {
  const ContactsSearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use hooks for search query state
    final searchController = useTextEditingController();

    // Watch the filtered list of contacts
    final contactsAsync = ref.watch(contactsNotifierProvider);
    // Read the viewmodel for updating search query and filter
    final contactsVM = ref.read(contactsNotifierProvider.notifier);

    // Use effect to handle search query changes
    useEffect(() {
      searchController.addListener(() {
        contactsVM.updateSearchQuery(searchController.text);
      });

      return () => searchController.dispose();
    }, [searchController]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts Search'),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search contacts...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          // Filter Chips
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: filterOptions.map((option) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: FilterChip(
                    label: Text(option),
                    selected: contactsVM.selectedFilter == option,
                    onSelected: (_) {
                      contactsVM.updateFilter(option);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(),
          // List of Contacts
          Expanded(
            child: contactsAsync.when(
              data: (contacts) {
                if (contacts.isEmpty) {
                  return const Center(child: Text('No contacts found'));
                }
                return CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final contact = contacts[index];
                          return ListTile(
                            leading: CircleAvatar(
                              child: Text(contact.name.substring(0, 1)),
                            ),
                            title: Text(contact.name),
                            subtitle:
                                Text('${contact.phone} • ${contact.category}'),
                          );
                        },
                        childCount: contacts.length,
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }
}
