import 'dart:convert';

import 'package:exer/details_container.dart';
import 'package:exer/provider_full_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class DetailsScreen extends StatefulWidget {
  final String type;
  DetailsScreen({super.key, required this.type});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

Future<Map<String, dynamic>> apiValues(String type) async {
  final encoded = Uri.encodeComponent(type);
  final mainUrl = Uri.parse(
    'https://exercise23.vercel.app/api/v1/bodyparts/$encoded/exercises',
  );

  final mainVal = await http.get(mainUrl);

  if (mainVal.statusCode == 200) {
    final mainUriValues = jsonDecode(mainVal.body) as Map<String, dynamic>;
    return mainUriValues;
  }
  return <String, dynamic>{};
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final providerVal = context.watch<ProviderFullDetails>().word;
    final typeToUse = (providerVal.isNotEmpty) ? providerVal : widget.type;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          // crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                SnackBar(content: Text('data'));
              },
              icon: Icon(Icons.info_outline_rounded, color: Colors.black54),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: apiValues(typeToUse),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              final values = snapshot.data!;
              final data = values['data'];
              if (data is List && data.isNotEmpty) {
                final imageGif = data[8]['gifUrl'];
                return ListView.builder(
                  itemCount: data.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            imageGif.toString(),
                            filterQuality: FilterQuality.high,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                          SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              providerVal.toUpperCase(),
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                        ],
                      );
                    }
                    final item = data[index - 1];
                    return DetailsContainer(
                      gifName: item['gifUrl'],
                      exerName: item['name'],
                      otherName: 'Equipments: ${item['equipments'][0]}',
                    );
                  },
                );
              }
              return Center(child: Text('No data available'));
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
