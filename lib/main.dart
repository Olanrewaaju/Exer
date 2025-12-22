import 'package:exer/reusable_widgets/bottom_navi.dart';
import 'package:exer/state_management/provider_full_details.dart';
import 'package:exer/state_management/provider_part.dart';
import 'package:exer/state_management/provider_search.dart';
import 'package:exer/state_management/recent_provider.dart';
import 'package:exer/state_management/saved_exercise.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => RecentProvider()..loadFromDb(),
        ),
        ChangeNotifierProvider(create: (context) => SavedExercise()),
        ChangeNotifierProvider(create: (context) => ProviderPart()),
        ChangeNotifierProvider(
          create: (context) => ProviderSearch()..loadLastQueryFromDb(),
        ),
        ChangeNotifierProvider(create: (context) => ProviderFullDetails()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.white,
            // background: Colors.white,
          ),
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Manrope',
        ),
        home: const BottomNavi(),
      ),
    );
  }
}
