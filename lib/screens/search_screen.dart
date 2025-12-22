import 'package:exer/screens/search_display.dart';
import 'package:exer/state_management/provider_search.dart';
import 'package:exer/state_management/recent_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchValue = TextEditingController();
  bool _didAutofill = false;
  ProviderSearch? _providerSearch;

  void _syncControllerWithLastQuery() {
    if (!mounted) return;
    if (_didAutofill) return;

    final lastQuery = _providerSearch?.searchedWord.trim() ?? '';
    if (lastQuery.isEmpty) return;
    if (searchValue.text.trim().isNotEmpty) return;

    _didAutofill = true;
    searchValue.text = lastQuery;
    searchValue.selection = TextSelection.fromPosition(
      TextPosition(offset: searchValue.text.length),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<RecentProvider>().loadFromDb();

      _providerSearch = context.read<ProviderSearch>();
      _providerSearch!.addListener(_syncControllerWithLastQuery);

      // In case ProviderSearch already hydrated before this widget mounts.
      _syncControllerWithLastQuery();
    });
  }

  @override
  void dispose() {
    _providerSearch?.removeListener(_syncControllerWithLastQuery);
    searchValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final worders = context.watch<RecentProvider>().recentWords;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leadingWidth: 18,
        title: TextButton(
          style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.zero)),
          onPressed: () {
            Navigator.pop(context);
          },

          child: Text(
            'Back',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              spellCheckConfiguration: SpellCheckConfiguration(
                spellCheckSuggestionsToolbarBuilder:
                    (context, editableTextState) {
                      return Text('');
                    },
              ),
              onSubmitted: (value) async {
                final query = value.trim();
                if (query.isEmpty) return;

                if (!context.mounted) return;
                // Persist first so the query survives app kill/restart.
                await context.read<ProviderSearch>().setAndPersist(query);
                await context.read<RecentProvider>().addAndPersist(query);
                if (!context.mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SearchDisplay();
                    },
                  ),
                );
              },

              controller: searchValue,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search_rounded, color: Colors.black54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 90),
            Text('Recent Search', style: TextStyle(fontSize: 16)),
            SizedBox(height: 12),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: worders.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: GestureDetector(
                      onTap: () async {
                        final query = worders[index].trim();
                        if (query.isEmpty) return;

                        // Update/persist BEFORE navigating so SearchDisplay uses the correct query.
                        await context.read<ProviderSearch>().setAndPersist(
                          query,
                        );
                        searchValue.text = query;
                        searchValue.selection = TextSelection.fromPosition(
                          TextPosition(offset: searchValue.text.length),
                        );

                        await context.read<RecentProvider>().addAndPersist(
                          query,
                        );
                        if (!context.mounted) return;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return SearchDisplay();
                            },
                          ),
                        );

                        // if (!context.mounted) return;
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) {
                        //       return SearchDisplay();
                        //     },
                        //   ),
                        // );
                      },
                      child: Chip(
                        color: WidgetStatePropertyAll(
                          const Color.fromARGB(255, 231, 231, 231),
                        ),

                        side: BorderSide(color: Colors.grey.shade300),
                        label: Text(worders[index]),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
