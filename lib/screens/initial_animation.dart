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
    'assets/animationGif/slide3.json',
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
    final currentKey = ValueKey<int>(index);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Spacer(),
            AnimatedSwitcher(
              duration: Duration(seconds: 1),
              transitionBuilder: (child, animation) {
                final isIncoming = child.key == currentKey;

                final inAnimation = Tween<Offset>(
                  begin: const Offset(-1.0, 0),
                  end: Offset.zero,
                ).animate(animation);

                final outAnimation = Tween<Offset>(
                  begin: Offset.zero,
                  end: const Offset(1.0, 0),
                ).animate(animation);

                return SlideTransition(
                  position: isIncoming ? inAnimation : outAnimation,
                  child: child,
                );
              },
              child: Lottie.asset(
                animationName[index],
                key: currentKey,
                repeat: true,
              ),
            ),
            Spacer(),
            AnimatedSwitcher(
              duration: Duration(seconds: 1),

              transitionBuilder: (child, animation) {
                final isIncoming = child.key == currentKey;

                final inAnimation = Tween<Offset>(
                  begin: const Offset(-1.0, 0),
                  end: Offset.zero,
                ).animate(animation);

                final outAnimation = Tween<Offset>(
                  begin: Offset.zero,
                  end: const Offset(1.0, 0),
                ).animate(animation);

                return SlideTransition(
                  position: isIncoming ? inAnimation : outAnimation,
                  child: child,
                );
              },
              child: Column(
                key: currentKey,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40),
                  Text(
                    textAlign: TextAlign.start,
                    animationCaption[index],

                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 14),
                  Text(aniimationDescription[index]),

                  SizedBox(height: 40),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  if (index < animationName.length - 1) {
                    setState(() {
                      index += 1;
                    });
                  } else if (index == 2) {
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
                style: ButtonStyle(
                  elevation: WidgetStatePropertyAll(6),
                  backgroundColor: WidgetStatePropertyAll(
                    const Color.fromARGB(255, 36, 88, 165),
                  ),
                ),

                child: Text(
                  index < animationCaption.length - 1 ? 'Next' : 'Proceed',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
