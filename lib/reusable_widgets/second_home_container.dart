import 'package:flutter/material.dart';
import 'auto_caps.dart';

class SecondHomeContainer extends StatefulWidget {
  String gifImage;
  String name;
  String part;
  SecondHomeContainer({
    super.key,
    required this.gifImage,
    required this.name,
    required this.part,
  });

  @override
  State<SecondHomeContainer> createState() => _SecondHomeContainerState();
}

class _SecondHomeContainerState extends State<SecondHomeContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color.fromARGB(31, 123, 123, 123)),
      ),
      width: 290,
      // height: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.network(
              width: 200,
              filterQuality: FilterQuality.high,
              fit: BoxFit.contain,
              widget.gifImage,
            ),
          ),
          SizedBox(width: 6, height: 8),
          Text(
            textAlign: TextAlign.start,
            (widget.name ?? '').toString().capitalizeWords(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 6),
          Text(
            (widget.part ?? '').toString().capitalizeWords(),
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
