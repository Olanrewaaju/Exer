import 'dart:convert';

import 'package:exer/provider_full_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class DetailsScreen extends StatefulWidget {
  String type;
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
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            FutureBuilder<Map<String, dynamic>>(
              future: apiValues(typeToUse),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  final values = snapshot.data!;
                  final data = values['data'];
                  if (data is List && data.isNotEmpty) {
                    final imageGif = data[2]['gifUrl'];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          filterQuality: FilterQuality.high,
                          imageGif.toString(),
                          fit: BoxFit.cover,

                          width: double.infinity,
                        ),
                        Text(
                          providerVal.toUpperCase(),
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  }
                  return Center(child: Text('No data available'));
                }
                return SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
