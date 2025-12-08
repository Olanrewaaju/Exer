/*import 'dart:math';*/

import 'package:exer/reusable_widgets/auto_caps.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exer/state_management/provider_part.dart';
import 'package:exer/state_management/saved_exercise.dart';

class FullDetails extends StatefulWidget {
  final String name;
  final Map<String, dynamic> exercise;
  const FullDetails({super.key, required this.name, required this.exercise});

  @override
  State<FullDetails> createState() => _FullDetailsState();
}

class _FullDetailsState extends State<FullDetails> {
  bool bookmarked = true;

  @override
  Widget build(BuildContext context) {
    final providerData = context.watch<ProviderPart>().val;
    final Map<String, dynamic> data = providerData ?? widget.exercise;

    final String gifUrl = (data['gifUrl'] ?? '') as String;
    final String title = (data['name'] ?? widget.name).toString();
    final String description = (data['description'] ?? '').toString();

    // target muscles
    String target = '';
    if (data['targetMuscles'] is List &&
        (data['targetMuscles'] as List).isNotEmpty) {
      target = (data['targetMuscles'][0] ?? '').toString();
    }

    // secondary muscles list
    List<String> secondary = [];
    if (data['secondaryMuscles'] is List) {
      secondary = List<String>.from(
        (data['secondaryMuscles'] as List).map((e) => e.toString()),
      );
    }

    // instructions - could be List or String
    List<String> instructions = [];
    if (data['instructions'] is List) {
      instructions = List<String>.from(
        (data['instructions'] as List).map((e) => e.toString()),
      );
    } else if (data['instructions'] is String) {
      final s = (data['instructions'] as String).trim();
      if (s.isNotEmpty) instructions = [s];
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,

        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(Icons.file_upload_outlined),
          ),
        ],
        // title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (gifUrl.isNotEmpty)
              Center(
                child: Image.network(
                  gifUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else
              const SizedBox.shrink(),

            const SizedBox(height: 20),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    (title).toString().capitalizeWords(),
                    style: TextStyle(fontSize: 32),
                  ),
                ),

                Consumer<SavedExercise>(
                  builder: (context, value, _) {
                    final item = data;
                    final saved = value.isBookmarked(item['exerciseId']);
                    return IconButton(
                      onPressed: () {
                        context.read<SavedExercise>().toggeBookmarks(item);
                        // setState(() {
                        //   bookmarked = !bookmarked;
                        // });
                      },
                      icon: Icon(
                        size: 26,
                        saved ? Icons.bookmark_border_rounded : Icons.bookmark,
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 12),

            if (target.isNotEmpty)
              Row(
                children: [
                  const Text('Target: ', style: TextStyle(fontSize: 12)),
                  Text(target, style: const TextStyle(fontSize: 14)),
                ],
              ),

            const SizedBox(height: 6),

            if (secondary.isNotEmpty)
              Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Secondary Muscles:',
                    style: TextStyle(fontSize: 12),
                  ),
                  // const SizedBox(height: 6),
                  Text(secondary.join(',')),
                  // Wrap(
                  //   spacing: 8,
                  //   runSpacing: 6,
                  //   children: secondary
                  //       .map((s) => Chip(label: Text(s)))
                  //       .toList(),
                  // ),
                ],
              ),

            const SizedBox(height: 16),

            if (description.isNotEmpty) ...[
              Text(
                'Description',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w200,
                ),
              ),
              const SizedBox(height: 8),
              Text(description),
              const SizedBox(height: 16),
            ],

            if (instructions.isNotEmpty) ...[
              const Text(
                'Procedures:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 8),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: instructions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  return Text('${instructions[index]}');
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
