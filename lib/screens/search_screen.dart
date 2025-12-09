import 'package:exer/screens/bookmarked_screen.dart';
import 'package:exer/screens/search_display.dart';
import 'package:exer/state_management/provider_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchValue = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              onSubmitted: (value) {
                // Update provider BEFORE navigating
                context.read<ProviderSearch>().searches(searchValue.text);

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
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
          ],
        ),
      ),
    );
  }
}
