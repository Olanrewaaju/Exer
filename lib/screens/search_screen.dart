import 'package:exer/database/initial_database.dart';
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
  final dbHelper = InitialDatabase.instance;
  final TextEditingController searchValue = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
  }

  Future<void> _loadRecentSearches() async {
    final results = await dbHelper.displaySearch();
    final words = results
        .map((row) => (row['searchedWord'] ?? '').toString())
        .where((w) => w.trim().isNotEmpty)
        .toList();

    if (!mounted) return;
    context.read<RecentProvider>().hydrate(words);
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
                final query = searchValue.text.trim();
                if (query.isEmpty) return;

                // Update provider BEFORE navigating
                context.read<ProviderSearch>().searches(query);
                context.read<RecentProvider>().addtoList(query);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SearchDisplay();
                    },
                  ),
                );
                await dbHelper.insertSearch({'searchedWord': query});
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return SearchDisplay();
                            },
                          ),
                        );
                        context.read<ProviderSearch>().searches(worders[index]);
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
