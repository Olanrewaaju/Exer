import 'package:exer/screens/full_details.dart';
import 'package:flutter/material.dart';
import 'package:exer/database/initial_database.dart';
import 'package:exer/state_management/provider_part.dart';
import 'package:provider/provider.dart';

class BookmarkedScreen extends StatefulWidget {
  const BookmarkedScreen({super.key});

  @override
  State<BookmarkedScreen> createState() => _BookmarkedScreenState();
}

class _BookmarkedScreenState extends State<BookmarkedScreen> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = InitialDatabase.instance.displayTab();
  }

  void _reload() {
    setState(() {
      _future = InitialDatabase.instance.displayTab();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        centerTitle: true,
        title: Text('Bookmarked Exercises'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No bookmarks yet'));
          }

          final bookmarks = snapshot.data!;

          return ListView.builder(
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final item = bookmarks[index];

              return Dismissible(
                key: ValueKey(item['id']), // ✅ SQLite ID
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) async {
                  await InitialDatabase.instance.deleteTab(item['id']);
                  _reload();
                },
                child: ListTile(
                  leading: Image.network(
                    item['gifUrl'] ?? item['imagePic'] ?? '',
                    width: 50,
                    errorBuilder: (_, __, ___) =>
                        Icon(Icons.image_not_supported),
                  ),
                  title: Text(item['name']),
                  subtitle: Text(item['part']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return FullDetails(
                            name: item['name'],
                            exercise: item,
                          );
                        },
                      ),
                    );
                    context.read<ProviderPart>().displayVal(item);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
