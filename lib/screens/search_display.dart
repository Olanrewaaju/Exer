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

Future fetchData(String type) async {
  final encoded = Uri.encodeComponent(type);
  final url = Uri.parse(
    'https://exercise23.vercel.app/api/v1/exercises/search?q=$encoded',
  );
  final mainVal = await http.get(url);
  if (mainVal.statusCode == 200) {
    final mainValues = jsonDecode(mainVal.body);
    return mainValues;
  }
}

class _SearchDisplayState extends State<SearchDisplay> {
  @override
  Widget build(BuildContext context) {
    final name = context.watch<ProviderSearch>().searchedWord;
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
        child: FutureBuilder(
          future: fetchData(name),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Theres an error'));
            } else if (snapshot.hasData) {
              final mainData = snapshot.data!;

              final mainNo = mainData['data'];
              final totLength = mainNo.length;
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
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return FullDetails(
                                    name: 'name',
                                    exercise: mainNo[index],
                                  );
                                },
                              ),
                            );
                            context.read<ProviderPart>().displayVal(
                              mainNo[index],
                            );
                          },
                          child: DetailsContainer(
                            gifName: mainData['data'][index]['gifUrl'],
                            exerName: mainData['data'][index]['name'],
                            otherName: mainData['data'][index]['bodyParts'][0],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }

            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
