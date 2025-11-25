import 'package:flutter/material.dart';

class DetailsContainer extends StatelessWidget {
  final String gifName;
  final String exerName;
  final String otherName;

  const DetailsContainer({
    super.key,
    required this.gifName,
    required this.exerName,
    required this.otherName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 24),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.network(gifName, width: 120),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(exerName, overflow: TextOverflow.ellipsis, maxLines: 1),
                SizedBox(height: 4),
                Text(otherName),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.arrow_forward_ios_rounded, size: 18),
          ),
        ],
      ),
    );
  }
}
