import 'package:exer/state_management/saved_exercise.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookmarkedScreen extends StatefulWidget {
  const BookmarkedScreen({super.key});

  @override
  State<BookmarkedScreen> createState() => _BookmarkedScreenState();
}

class _BookmarkedScreenState extends State<BookmarkedScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SavedExercise>(
      builder: (context, savedExer, _) {
        final savedVal = savedExer.bookmarkedItem;
        if (savedVal.isEmpty) {
          return Center(child: Text('Empty Text'));
        }
        return ListView.builder(
          itemCount: savedExer.bookmarkedItem.length,
          itemBuilder: (context, index) {
            final item = savedVal[index];
            return Dismissible(
              onDismissed: (direction) {
                context.read<SavedExercise>().removeBookmark(
                  item['exerciseId'],
                );
              },
              key: Key(item['exerciseId'].toString()),
              child: ListTile(
                leading: Image.network(item['gifUrl']),
                title: Text(item['name']),
                subtitle: Text(item['bodyParts'][0]),
                // trailing: IconButton(
                //   onPressed: () {
                //     context.read<SavedExercise>().removeBookmark(
                //       savedVal.toString(),
                //     );
                //   },
                //   icon: Icon(Icons.bookmark),
                //   iconSize: 20,
                // ),
              ),
            );
          },
        );
      },
    );
  }
}
