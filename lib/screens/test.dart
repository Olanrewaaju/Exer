import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  Future<Map<String, dynamic>> fetchUser() async {
    final url = Uri.parse(
      'https://exercise23.vercel.app/api/v1/equipments/olympic%20Barbell/exercises?offset=0&limit=10',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Valid status code');
      return data;
    } else {
      print('Theres an error with the code');
    }
    return <String, dynamic>{};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<Map<String, dynamic>>(
              future: fetchUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  final body = snapshot.data!;
                  final data = body['data'][0]['name'];
                  final gifUrl = body['data'][0]['gifUrl'];
                  return Column(children: [Text(data), Image.network(gifUrl)]);
                }
                return Text('');
              },
            ),
          ],
        ),
      ),
    );
  }
}
