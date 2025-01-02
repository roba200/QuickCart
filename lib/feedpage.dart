import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/Components/item_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'details_page.dart';
import 'morphism_card.dart';

class FeedPage extends StatefulWidget {
  bool isLiked = false;
  String searchText = "";
  String userId = FirebaseAuth.instance.currentUser!.uid;

  FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        leading: Icon(Icons.search),
        title: TextField(
          controller: _controller,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            hintText: "Search",
          ),
          onChanged: (value) {
            setState(() {
              widget.searchText = value;
            });
          },
        ),
      ),
      body: StreamBuilder(
          stream: widget.searchText.isNotEmpty
              ? FirebaseFirestore.instance
                  .collection('items')
                  .where('name', isGreaterThanOrEqualTo: widget.searchText)
                  .where('name', isLessThan: widget.searchText + 'z')
                  .snapshots()
              : FirebaseFirestore.instance.collection('items').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            }
            if (snapshot.hasData) {
              bool isLiked = true;
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 300,
                    childAspectRatio: 1,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: ((context, index) {
                    final documentSnapshot = snapshot.data?.docs[index];
                    final data = documentSnapshot?.data();
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailsPage(
                                        document: data,
                                      )));
                        },
                        child: ItemCard(
                            imageUrl: data!['imageurl'],
                            productName: data['name'],
                            price: data['price']));
                  }));
            } else {
              return Center(
                child: Text("Error"),
              );
            }
          }),
    );
  }
}
