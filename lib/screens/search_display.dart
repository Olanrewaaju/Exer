import 'dart:convert';

import 'package:exer/reusable_widgets/details_container.dart';
import 'package:exer/screens/full_details.dart';
import 'package:exer/state_management/provider_part.dart';
import 'package:exer/state_management/provider_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class SearchDisplay extends StatefulWidget {
  const SearchDisplay({super.key});

  @override
  State<SearchDisplay> createState() => _SearchDisplayState();
}

Future<Map<String, dynamic>> fetchData(String type) async {
  final query = type.trim();
  if (query.isEmpty) return <String, dynamic>{'data': <dynamic>[]};

  final encoded = Uri.encodeComponent(type);
  final url = Uri.parse(
    'https://exercise23.vercel.app/api/v1/exercises/search?q=$encoded',
  );
  final mainVal = await http.get(url);
  if (mainVal.statusCode == 200) {
    final decoded = jsonDecode(mainVal.body);
    if (decoded is Map<String, dynamic>) return decoded;
  }

  return <String, dynamic>{'data': <dynamic>[]};
}

class _SearchDisplayState extends State<SearchDisplay> {
  String _lastQuery = '';
  Future<Map<String, dynamic>>? _future;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProviderSearch>();
    final name = provider.searchedWord.trim();
    if (name != _lastQuery) {
      _lastQuery = name;
      _future = fetchData(name);
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Results for the text   ',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Manrope',
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: '\'$name\' ',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Manrope',
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: (!provider.hydrated && provider.loading)
            ? const Center(child: CircularProgressIndicator())
            : (name.isEmpty)
            ? const Center(child: Text('Type something to search'))
            : FutureBuilder<Map<String, dynamic>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('There was an error'));
                  }
                  if (!snapshot.hasData) {
                    return const SizedBox.shrink();
                  }

                  final mainData = snapshot.data!;
                  final dynamic rawList = mainData['data'];
                  final List<dynamic> mainNo = (rawList is List)
                      ? rawList
                      : <dynamic>[];
                  final totLength = mainNo.length;

                  if (mainNo.isEmpty) {
                    return const Center(child: Text('No results found'));
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Text('Total Exercise is $totLength'),
                      SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: mainNo.length,
                          itemBuilder: (context, index) {
                            final item = Map<String, dynamic>.from(
                              mainNo[index] as Map,
                            );

                            final gifUrl = (item['gifUrl'] ?? '').toString();
                            final exerName = (item['name'] ?? '').toString();
                            final bodyParts = (item['bodyParts'] is List)
                                ? (item['bodyParts'] as List)
                                : const <dynamic>[];
                            final otherName = bodyParts.isNotEmpty
                                ? bodyParts.first.toString()
                                : '';

                            return GestureDetector(
                              onTap: () {
                                context.read<ProviderPart>().displayVal(item);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return FullDetails(
                                        name: exerName,
                                        exercise: item,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: DetailsContainer(
                                gifName: gifUrl,
                                exerName: exerName,
                                otherName: otherName,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
