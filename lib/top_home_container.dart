import 'package:flutter/material.dart';
import 'auto_caps.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TopHomeContainer extends StatefulWidget {
  String name;
  String part;
  String gifImage;

  TopHomeContainer({
    super.key,
    required this.part,

    required this.name,

    required this.gifImage,
  });

  @override
  State<TopHomeContainer> createState() => _TopHomeContainerState();
}

class _TopHomeContainerState extends State<TopHomeContainer> {
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
      child: Row(
        children: [
          // CachedNetworkImage(
          //   imageUrl: widget.gifImage,
          //   fit: BoxFit.cover,
          //   placeholder: (context, url) => CircularProgressIndicator(),
          //   errorWidget: (context, url, error) => Icon(Icons.error),
          // ),
          Image.network(
            widget.gifImage,
            gaplessPlayback: true,
            width: 100,
            filterQuality: FilterQuality.high,
            fit: BoxFit.contain,

            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (frame == null) {
                return child;
              }
              return AnimatedSwitcher(
                duration: Duration(milliseconds: 0),
                child: child,
              );
            },
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
