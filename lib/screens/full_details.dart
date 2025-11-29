import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:exer/reusable_widgets/auto_caps.dart';
import 'package:exer/state_management/provider_full_details.dart';

class FullDetails extends StatefulWidget {
  final String name;
  final int number;
  const FullDetails({super.key, required this.name, required this.number});

  @override
  State<FullDetails> createState() => _FullDetailsState();
}

bool pres = false;

Future<Map<String, dynamic>> fetchUsers(String name) async {
  final encodeds = Uri.encodeComponent(name);
  final uri = Uri.parse(
    'https://exercise23.vercel.app/api/v1/bodyparts/chest/exercises',
  );
  final responses = await http.get(uri);

  if (responses.statusCode == 200) {
    final urlValues = jsonDecode(responses.body) as Map<String, dynamic>;

    return urlValues;
  }
  return {};
}

class _FullDetailsState extends State<FullDetails> {
  @override
  Widget build(BuildContext context) {
    final providerVal = context.watch<ProviderFullDetails>().word;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,

          children: [
            IconButton(
              icon: pres
                  ? Icon(Icons.bookmark_border_rounded)
                  : Icon(Icons.bookmark),
              onPressed: () {
                setState(() {
                  pres = !pres;
                });
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchUsers(providerVal),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No data'));
          }

          final response = snapshot.data!;

          if (response['data'] == null || response['data'] is! List) {
            return const Center(child: Text('Invalid response data'));
          }

          final dataList = response['data'] as List;

          if (widget.number < 0 || widget.number >= dataList.length) {
            return const Center(child: Text('Item not found'));
          }

          final responseData = dataList[widget.number] as Map<String, dynamic>;

          final gifUrl = responseData['gifUrl'] as String? ?? '';
          final instruc = responseData['instructions'];
          return Padding(
            padding: EdgeInsetsGeometry.all(12),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (gifUrl.isNotEmpty)
                    Image.network(
                      gifUrl,
                      width: double.infinity,
                      fit: BoxFit.fill,
                    )
                  else
                    const SizedBox.shrink(),
                  SizedBox(height: 20),
                  Text(
                    (responseData['name'] ?? widget.name)
                        .toString()
                        .capitalizeWords(),
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: instruc.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(responseData['instructions'][index]),
                            // SizedBox(height: 18),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
