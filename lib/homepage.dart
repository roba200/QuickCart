import 'package:e_commerce_app/Consts/colors.dart';
import 'package:flutter/material.dart';

import 'cart_page.dart';
import 'Pages/categories_page.dart';
import 'favourite_page.dart';
import 'feedpage.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final screens = [
    FeedPage(),
    FavouritePage(),
    CategoriesPage(),
    CartPage(),
    ProfilePage(),
  ];
  int current = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: red,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.feed), label: "Feed"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: "Favourites"),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: "Categories"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        onTap: (index) {
          setState(() {
            current = index;
          });
        },
        currentIndex: current,
      ),
      body: screens[current],
    );
  }
}
