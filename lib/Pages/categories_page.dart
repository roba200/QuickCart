import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/Components/category_card.dart';
import 'package:e_commerce_app/Consts/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../category_select.dart';
import '../morphism_card.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkWhite,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Categories",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {},
              icon: IconButton(
                onPressed: () {},
                icon: Icon(Icons.search),
                iconSize: 30,
              ))
        ],
      ),
      body: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('categories').snapshots(),
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: snapshot.data?.docs.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                final documentSnapshot = snapshot.data?.docs[index];
                final data = documentSnapshot?.data();
                return Padding(
                  padding: const EdgeInsets.only(
                      bottom: 10, left: 10, right: 10, top: 10),
                  child: CategoryCard(
                    imageUrl: data!['imageurl'],
                    categoryName: data!['cat'],
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CategorySelect(category: data['cat'])));
                    },
                  ),
                );
              },
            );
          }),
    );
  }
}
