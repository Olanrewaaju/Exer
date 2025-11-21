import 'package:exer/top_home_container.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:exer/auto_caps.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<Map<String, dynamic>> fetchUser() async {
    final url = Uri.parse(
      'https://exercise23.vercel.app/api/v1/bodyparts/chest/exercises',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded;
    } else {
      print(response.statusCode);
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Chest Workout with equipments',
                style: TextStyle(fontSize: 20),
              ),
              FutureBuilder<Map<String, dynamic>>(
                future: fetchUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    final detail = snapshot.data!;
                    final mainDetails = detail['data'];

                    return Expanded(
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: (mainDetails.length / 2).ceil(),
                        itemBuilder: (context, index) {
                          int index1 = index * 2;
                          int index2 = index1 + 1;

                          final exerciseNum1 = detail['data'][index1];
                          final exerciseNum2 = index2 < mainDetails.length
                              ? detail['data'][index2]
                              : null;

                          detail['data'][index2];
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
                                child: TopHomeContainer(
                                  part: exerciseNum2['equipments'][0],
                                  name: exerciseNum2['name'],
                                  gifImage: exerciseNum2['gifUrl'],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  }
                  return Text('');
                },
              ),
              Text('Morning Equipments'),
            ],
          ),
        ),
      ),
    );
  }
}
