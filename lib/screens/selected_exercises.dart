import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SelectedExercises extends StatefulWidget {
  const SelectedExercises({super.key});

  @override
  State<SelectedExercises> createState() => _SelectedExercisesState();
}

Future<Map<String, dynamic>> exers() async {
  final selectedParts = Uri.parse(
    'https://exercise23.vercel.app/api/v1/muscles',
  );
  final response = await http.get(selectedParts);

  if (response.statusCode == 200) {
    final chipContent = response.body;

    return jsonDecode(response.body);
  }

  return {};
}

class _SelectedExercisesState extends State<SelectedExercises> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: exers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final chipValues = snapshot.data!;

            return ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Chip(label: Text(chipValues['data'][index]['name']));
              },
            );
          }
          return Text('');
        },
      ),
    );
  }
}
