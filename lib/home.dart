import 'package:exer/details_screen.dart';
import 'package:exer/second_home_container.dart';
import 'package:exer/top_home_container.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'provider_full_details.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<dynamic>> mainz;

  int shows = 4;
  String today = DateFormat('EEEE,MMMM,d').format(DateTime.now());
  Future<List<dynamic>> fetchUser() async {
    final chipUrl = Uri.parse('https://exercise23.vercel.app/api/v1/bodyparts');
    final url = Uri.parse(
      'https://exercise23.vercel.app/api/v1/bodyparts/chest/exercises',
    );
    final secondUrl = Uri.parse(
      'https://exercise23.vercel.app/api/v1/bodyparts/cardio/exercises',
    );
    // final response = await http.get(url);
    final response = await Future.wait([
      http.get(url),
      http.get(secondUrl),
      http.get(chipUrl),
    ]);

    if (response[0].statusCode == 200 &&
        response[1].statusCode == 200 &&
        response[2].statusCode == 200) {
      final decoded = jsonDecode(response[0].body);
      final secondDecoded = jsonDecode(response[1].body);
      final chipDecoded = jsonDecode(response[2].body);

      return [decoded, secondDecoded, chipDecoded];
    } else {
      print(response[0].statusCode & response[1].statusCode);
    }

    return [];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mainz = fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: 120,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(today, style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Hello, Tayo', style: TextStyle(fontSize: 14)),
          ],
        ),
        // leading: Expanded(child: Text(today))),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 32),

              FutureBuilder<List<dynamic>>(
                future: mainz,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (snapshot.hasData) {
                    final generalData = snapshot.data!;
                    final chipData = generalData.length > 2
                        ? generalData[2]
                        : null;
                    final chipValue = chipData != null
                        ? (chipData['data'] as List)
                        : <dynamic>[];
                    final safeCount = chipValue.length;
                    return SizedBox(
                      height: 56,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: safeCount,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        itemBuilder: (context, index) {
                          final c = chipValue[index];
                          String navs = c['name']?.toString() ?? '';
                          final name = c['name'] ?? '';
                          // context.watch<ProviderFullDetails>().displayVal(navs);
                          return Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: () {
                                context.read<ProviderFullDetails>().displayVal(
                                  navs,
                                );

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return DetailsScreen(type: navs);
                                    },
                                  ),
                                );
                              },
                              child: Chip(label: Text(name)),
                            ),
                          );
                        },
                      ),
                    );
                  }

                  return SizedBox.shrink();
                },
              ),

              SizedBox(height: 50),
              Text(
                'Chest Workout with equipments',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 24),
              SizedBox(
                height: 370,
                child: FutureBuilder<List<dynamic>>(
                  future: mainz,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData) {
                      final results = snapshot.data!;
                      final detail = results[0]; // chest data
                      final mainDetails = detail['data'];

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: (mainDetails.length / 2).ceil(),
                        itemBuilder: (context, index) {
                          int index1 = index * 2;
                          int index2 = index1 + 1;

                          final exerciseNum1 = mainDetails[index1];
                          final exerciseNum2 = index2 < mainDetails.length
                              ? mainDetails[index2]
                              : null;

                          return Column(
                            children: [
                              SizedBox(
                                height: 170,
                                child: TopHomeContainer(
                                  part: exerciseNum1['equipments'][0],
                                  name: exerciseNum1['name'],
                                  gifImage: exerciseNum1['gifUrl'],
                                ),
                              ),
                              SizedBox(
                                height: 200,
                                child: exerciseNum2 != null
                                    ? TopHomeContainer(
                                        part: exerciseNum2['equipments'][0],
                                        name: exerciseNum2['name'],
                                        gifImage: exerciseNum2['gifUrl'],
                                      )
                                    : SizedBox.shrink(),
                              ),
                            ],
                          );
                        },
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
              ),
              SizedBox(height: 24),

              Text('Morning Equipments', style: TextStyle(fontSize: 18)),
              SizedBox(height: 24),
              FutureBuilder<List<dynamic>>(
                future: mainz,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData) {
                    final results = snapshot.data!;
                    final details = results[1];
                    final vals = details['data'];
                    final safeCount = vals.length >= shows
                        ? shows
                        : vals.length;
                    return SizedBox(
                      height: 300,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: safeCount,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            width: 360,
                            child: SecondHomeContainer(
                              gifImage: vals[index]['gifUrl'],
                              name: vals[index]['name'],
                              part: vals[index]['targetMuscles'][0],
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
