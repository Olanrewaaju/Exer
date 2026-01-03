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

            final data = (chipValues['data'] as List?) ?? const [];

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(
                    data.length,
                    (index) => ChoiceChip(
                      disabledColor: Colors.black,
                      selected: true,
                      selectedColor: const Color.fromARGB(255, 34, 82, 166),
                      showCheckmark: false,
                      label: Text(
                        (data[index] as Map?)?['name']?.toString() ?? '',
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
