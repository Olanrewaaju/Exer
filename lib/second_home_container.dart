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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: BoxBorder.all(color: const Color.fromARGB(31, 123, 123, 123)),
      ),
      width: 280,
      height: 100,
      child: Column(
        children: [
          Image.network(
            width: 100,
            filterQuality: FilterQuality.high,
            fit: BoxFit.contain,
            widget.gifImage,
          ),
          SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  (widget.name ?? '').toString().capitalizeWords(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 10),
                Text(
                  (widget.part ?? '').toString().capitalizeWords(),
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
