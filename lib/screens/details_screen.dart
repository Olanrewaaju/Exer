import 'dart:convert';

import 'package:exer/reusable_widgets/details_container.dart';
import 'package:exer/state_management/provider_full_details.dart';
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
        title: Text(typeToUse.toUpperCase()),
        actions: [
          FutureBuilder<Map<String, dynamic>>(
            future: apiValues(typeToUse),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return SizedBox.shrink();
              final values = snapshot.data!;
              final data = values['data'];
              final totalNum = (data is List) ? data.length : 0;
              return Builder(
                builder: (context) {
                  return IconButton(
                    icon: Icon(Icons.info_outline),
                    onPressed: () {
                      final RenderBox button =
                          context.findRenderObject() as RenderBox;
                      final RenderBox overlay =
                          Overlay.of(context).context.findRenderObject()
                              as RenderBox;

                      final RelativeRect position = RelativeRect.fromRect(
                        Rect.fromPoints(
                          button.localToGlobal(Offset.zero, ancestor: overlay),
                          button.localToGlobal(
                            button.size.bottomRight(Offset.zero),
                            ancestor: overlay,
                          ),
                        ),
                        Offset.zero & overlay.size,
                      );

                      showMenu(
                        context: context,
                        position: position,
                        items: [
                          PopupMenuItem(
                            child: SizedBox(
                              width: 200,
                              child: Text(
                                "This set of Exercises are collated and their main focus is on the $providerVal!\n\n Total number of workout: $totalNum",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
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
                final imageGif = data[1]['gifUrl'];
                return ListView.builder(
                  itemCount: data.length,
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
