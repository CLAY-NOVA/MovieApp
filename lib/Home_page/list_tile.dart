import 'package:flutter/material.dart';
import 'package:movieapp/Home_page/Homepage.dart';
import 'package:movieapp/Fav_page/movie_favorite.dart';
import 'package:movieapp/Cinema_page/cinema_near_me.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.black, // Set the background color to black
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.home, color: Colors.white), // Set the icon color to white
              title: const Text(
                'Home',
                style: TextStyle(color: Colors.white), // Set the text color to white
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite, color: Colors.white), // Set the icon color to white
              title: const Text(
                'Favorites',
                style: TextStyle(color: Colors.white), // Set the text color to white
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FavoriteMovies()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on, color: Colors.white), // Set the icon color to white
              title: const Text(
                'Cinema Near Me',
                style: TextStyle(color: Colors.white), // Set the text color to white
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CinemaNearMe()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
