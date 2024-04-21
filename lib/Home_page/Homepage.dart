import 'package:flutter/material.dart';
import 'package:movieapp/Movie_details_page/MovieDetailsPage.dart';
import 'package:movieapp/api_data/movie_model.dart';
import 'package:movieapp/api_data/movie_data_source.dart';
import 'package:movieapp/Home_page/list_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<MovieModel>> futureMovies;
  final searchController = TextEditingController();
  int pageNumber = 1;
  List<MovieModel> movies = [];

  @override
  void initState() {
    super.initState();
    futureMovies = OmdbApiClient().getMovies();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void searchMovies() {
    setState(() {
      if (searchController.text.isEmpty) {
        futureMovies = OmdbApiClient().getMovies();
      } else {
        futureMovies = OmdbApiClient().getMovies(query: searchController.text);
      }
    });
  }

  void loadMoreMovies() {
    OmdbApiClient().getMoreMovies(pageNumber).then((newMovies) {
      setState(() {
        pageNumber++;
        movies.addAll(newMovies);
      });
    });
  }

  void onMovieCardTap(MovieModel movie) {
    if (movie.imdbID != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MovieDetailsPage(imdbID: movie.imdbID!),
        ),
      );
    } else {
      print('Error: Movie imdbID is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'MOVIEAPP',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      drawer: const CustomDrawer(),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search a movie",
                fillColor: Colors.black,
                filled: true,
                suffixIcon: IconButton(
                  onPressed: searchMovies,
                  icon: const Icon(Icons.search),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<MovieModel>>(
              future: futureMovies,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: snapshot.data!.length + movies.length + 1,
                    itemBuilder: (context, index) {
                      if (index < snapshot.data!.length) {
                        return GestureDetector(
                          onTap: () => onMovieCardTap(snapshot.data![index]),
                          child: Card(
                            color: Colors.black,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  snapshot.data![index].poster ??
                                      'https://via.placeholder.com/150',
                                  fit: BoxFit.cover,
                                ),
                              ],
                            ),
                          ),
                        );
                      } else if (index == snapshot.data!.length + movies.length) {
                        loadMoreMovies();
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        final movieIndex = index - snapshot.data!.length;
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Card(
                            color: Colors.black,
                            child: InkWell(
                              onTap: () => onMovieCardTap(movies[movieIndex]),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(
                                    movies[movieIndex].poster ??
                                        'https://via.placeholder.com/150',
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 10,
                                    left: 10,
                                    child: Container(
                                      child: Text(
                                        movies[movieIndex].title ?? 'No Title',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
