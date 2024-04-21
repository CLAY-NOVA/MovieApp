// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:movieapp/Fav_page/movie_favorite.dart';
import 'package:movieapp/api_data/MovieDetails.dart';
import 'package:movieapp/api_data/movie_model_details.dart';
import 'package:movieapp/local_data.dart/local_data.dart';

class MovieDetailsPage extends StatefulWidget {
  final String imdbID;

  const MovieDetailsPage({super.key, required this.imdbID});

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  late Future<MovieDetails> futureMovieDetails;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    futureMovieDetails = MovieApi().fetchMovieDetails(widget.imdbID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Details'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: isFavorite ? Colors.red : Colors.white,
              size: isFavorite ? 30 : 24,
            ),
            onPressed: () async {
              setState(() {
                isFavorite = !isFavorite;
              });
              if (isFavorite) {
                // Insert the movie into the database as a favorite
                await DatabaseHelper.instance.insert({
                  DatabaseHelper.columnId: widget.imdbID,
                  DatabaseHelper.columnTitle:
                      'Movie Title', // Replace with your movie title
                });
              } else {
                // Remove the movie from the database
                await DatabaseHelper.instance.delete(int.parse(widget.imdbID));
              }
              // Pop and push the FavoriteMovies page to refresh it
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoriteMovies()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<MovieDetails>(
        future: futureMovieDetails,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Image.network(snapshot.data!.poster ??
                          'https://via.placeholder.com/150'),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      snapshot.data!.title ?? 'No Title',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Year: ${snapshot.data!.year ?? 'N/A'}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Text('Released: ${snapshot.data!.released ?? 'N/A'}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Actors: ${snapshot.data!.actors ?? 'N/A'}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Genre: ${snapshot.data!.genre ?? 'N/A'}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Text('Director: ${snapshot.data!.director ?? 'N/A'}'),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // By default, show a loading spinner.
          return const Center(
            child: SizedBox(
              width: 50.0,
              height: 50.0,
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
