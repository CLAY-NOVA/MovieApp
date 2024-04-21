import 'package:flutter/material.dart';
import 'package:movieapp/local_data.dart/local_data.dart';


class FavoriteMovies extends StatefulWidget {
  const FavoriteMovies({super.key});

  @override
  _FavoriteMoviesState createState() => _FavoriteMoviesState();
}

class _FavoriteMoviesState extends State<FavoriteMovies> {
  late Future<List<Map<String, dynamic>>> favoriteMovies;

  @override
  void initState() {
    super.initState();
    favoriteMovies = DatabaseHelper.instance.queryAllRows();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Movies'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: favoriteMovies,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index][DatabaseHelper.columnTitle]),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // By default, show a loading spinner.
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
