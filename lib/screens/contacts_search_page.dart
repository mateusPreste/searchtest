import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/todo_provider.dart';

// Define the filter options as a constant outside the class
const List<String> filterOptions = ['All', 'Family', 'Friends', 'Work'];

class ContactsSearchPage extends HookConsumerWidget {
  const ContactsSearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use hooks for search query state
    final searchController = useTextEditingController();

    // Watch the filtered list of contacts
    final contacts = ref.watch(contactsProvider);
    // Read the viewmodel for updating search query and filter
    final contactsVM = ref.read(contactsProvider.notifier);

    // Key for the SliverAnimatedList
    final animatedListKey =
        useMemoized(() => GlobalKey<SliverAnimatedListState>());

    // Track previous contacts for diffing
    final previousContacts = useRef<List>(contacts);

    // Use effect to handle search query changes
    useEffect(() {
      searchController.addListener(() {
        contactsVM.updateSearchQuery(searchController.text);
      });

      return () => searchController.dispose();
    }, [searchController]);

    // useEffect to sync animated list with contacts changes
    useEffect(() {
      final listState = animatedListKey.currentState;
      if (listState != null) {
        final prevLength = previousContacts.value.length;
        final currLength = contacts.length;
        if (currLength > prevLength) {
          // Insert new item(s)
          for (var i = prevLength; i < currLength; i++) {
            listState.insertItem(i);
          }
        } else if (currLength < prevLength) {
          // Remove extra item(s)
          for (var i = prevLength - 1; i >= currLength; i--) {
            final removedItem = previousContacts.value[i];
            listState.removeItem(
              i,
              (context, animation) => SizeTransition(
                sizeFactor: animation,
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(removedItem.name.substring(0, 1)),
                  ),
                  title: Text(removedItem.name),
                  subtitle:
                      Text('${removedItem.phone} • ${removedItem.category}'),
                ),
              ),
            );
          }
        }
      }
      // Update the previous contacts ref.
      previousContacts.value = contacts;
      return null;
    }, [contacts]);

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
            child: CustomScrollView(
              slivers: [
                contacts.isEmpty
                    ? const SliverFillRemaining(
                        child: Center(child: Text('No contacts found')),
                      )
                    : SliverAnimatedList(
                        key: animatedListKey,
                        initialItemCount: contacts.length,
                        itemBuilder: (context, index, animation) {
                          final contact = contacts[index];
                          return SizeTransition(
                            sizeFactor: animation,
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(contact.name.substring(0, 1)),
                              ),
                              title: Text(contact.name),
                              subtitle: Text(
                                  '${contact.phone} • ${contact.category}'),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
