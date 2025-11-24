import 'package:exer/provider_full_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatefulWidget {
  String type;
  DetailsScreen({super.key, required this.type});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final deets = context.read<ProviderFullDetails>().word;

    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [Text(deets)]),
    );
  }
}
