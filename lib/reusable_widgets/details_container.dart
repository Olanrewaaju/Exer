import 'package:flutter/material.dart';
import 'auto_caps.dart';

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
          Image.network(
            gifName,
            width: 120,
            // loadingBuilder: (context, child, loadingProgress) {
            //   if (loadingProgress == null) {
            //     return child;
            //   }
            //   return const Center(child: CircularProgressIndicator());
            // },
            errorBuilder: (context, error, stackTrace) {
              return Container(width: 120, child: Icon(Icons.image_rounded));
            },
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (exerName ?? '').toString().capitalizeWords(),
                  style: TextStyle(fontSize: 16),

                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: 4),
                Text(
                  otherName,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                ),
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
