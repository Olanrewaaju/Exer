import 'package:exer/reusable_widgets/bottom_navi.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class InitialAnimation extends StatefulWidget {
  const InitialAnimation({super.key});

  @override
  State<InitialAnimation> createState() => _InitialAnimationState();
}

class _InitialAnimationState extends State<InitialAnimation>
    with TickerProviderStateMixin {
  int index = 0;
  final List animationName = [
    'assets/animationGif/slide1.json',
    'assets/animationGif/slide2.json',
    'assets/animationGif/slide2.json',
  ];
  List animationCaption = [
    'Stay Organized',
    'Everything in One App',
    'Make Every Day Count',
  ];
  List aniimationDescription = [
    'Keep all your tasks, plans, and goals in one place and manage your day with ease.',
    'From planning to tracking progress, we help you stay focused and in control.',
    'Simple tools designed to help you plan better, stay productive, and achieve more.',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AnimatedSwitcher(
            duration: Duration(seconds: 1),

            transitionBuilder: (child, tres) {
              final offsetanimation = Tween<Offset>(
                begin: Offset(-1.0, 0),
                end: Offset.zero,
              ).animate(tres);
              return SlideTransition(position: offsetanimation, child: child);
            },
            child: Lottie.asset(
              animationName[index],
              key: ValueKey<int>(index),
              repeat: true,
            ),
          ),
          AnimatedSwitcher(
            duration: Duration(seconds: 1),

            transitionBuilder: (child, tres) {
              final offsetanimation = Tween<Offset>(
                begin: Offset(-1.0, 0),
                end: Offset.zero,
              ).animate(tres);
              return SlideTransition(position: offsetanimation, child: child);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(animationCaption[index]),
                Text(aniimationDescription[index]),

                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    if (index != 3) {
                      setState(() {
                        index++;
                      });
                    } else if (index == 3) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return BottomNavi();
                          },
                        ),
                      );
                    }
                  },
                  child: Text('Proceed'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
