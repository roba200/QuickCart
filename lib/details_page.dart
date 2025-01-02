import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'morphism_card.dart';

class DetailsPage extends StatefulWidget {
  final Map<String, dynamic> document;
  bool isLiked = false;
  String userId = FirebaseAuth.instance.currentUser!.uid;
  DetailsPage({
    super.key,
    required this.document,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  TextEditingController _controller = TextEditingController(text: "1");
  List specList = [];
  @override
  void initState() {
    if (widget.document['specs'] != null) {
      specList = List.from(widget.document['specs']);
    }
    checkDocumentExistence();
    super.initState();
  }

  Future<void> checkDocumentExistence() async {
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('favourites')
        .doc(widget.document['id']);
    final docSnapshot = await docRef.get();
    setState(() {
      widget.isLiked = docSnapshot.exists;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Image.network(
                widget.document['imageurl'],
                fit: BoxFit.cover,
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      "\$" + widget.document['price'],
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: IconButton(
                      icon: Icon(
                        widget.isLiked
                            ? Icons.favorite_outlined
                            : Icons.favorite_border,
                        size: 35,
                        color: widget.isLiked ? Colors.redAccent : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          widget.isLiked = !widget.isLiked;
                        });
                        if (widget.isLiked) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Added to favourites")));
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.userId)
                              .collection('favourites')
                              .doc(widget.document['id'])
                              .set({
                            "id": widget.document['id'],
                            "name": widget.document['name'],
                            "imageurl": widget.document['imageurl'],
                            "price": widget.document['price'],
                            "description": widget.document['description'],
                            "specs": widget.document['specs'],
                            "category": widget.document['category']
                          });
                        } else {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.userId)
                              .collection('favourites')
                              .doc(widget.document['id'])
                              .delete();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8, right: 8),
              child: Text(
                widget.document['name'],
                style: TextStyle(fontSize: 20, height: 1.2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: CupertinoButton(
                      color: Colors.deepPurple,
                      child: const Text("Add to cart"),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: ((context) {
                              return AlertDialog(
                                title: Text("Added to the cart"),
                                actions: [
                                  CupertinoButton(
                                      child: Text("OK"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      })
                                ],
                              );
                            }));
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.userId)
                            .collection('cart')
                            .doc(widget.document['id'])
                            .set({
                          "id": widget.document['id'],
                          "name": widget.document['name'],
                          "imageurl": widget.document['imageurl'],
                          "price": widget.document['price'],
                          "description": widget.document['description'],
                          "specs": widget.document['specs'],
                          "category": widget.document['category'],
                          "qty": _controller.text,
                        });
                      },
                    ),
                  ),
                  Container(
                      // decoration: BoxDecoration(
                      //     border: Border.all(color: Colors.deepPurple),
                      //     borderRadius: BorderRadius.circular(8)),
                      width: 60,
                      height: 50,
                      child: TextField(
                        controller: _controller,
                        textAlign: TextAlign.center,
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                        keyboardType: TextInputType.number,
                        style: TextStyle(),
                      )),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 8),
              width: MediaQuery.of(context).size.width * 0.98,
              height: 200,
              child: MorphismCard(
                child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(top: 10),
                  itemCount: specList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(specList[index]),
                    );
                  },
                ),
              ),
            ),
            Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 30, left: 8),
                  child: Text(
                    'Item Description',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 8, top: 8),
              child: Text(
                widget.document['description'],
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Stack(
                children: [
                  Container(
                    height: 275,
                    color: Colors.deepPurple,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 15, left: 8, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 10,
                              width: 10,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            const Text(
                              'You may also like',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Container(
                              height: 10,
                              width: 10,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          height: 200,
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('items')
                                  .where('category',
                                      isEqualTo: widget.document['category'])
                                  .snapshots(),
                              builder: (context, snapshot) {
                                return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data?.docs.length,
                                    itemBuilder: ((context, index) {
                                      return SizedBox(
                                        width: 200,
                                        height: 300,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailsPage(
                                                          document:
                                                              widget.document,
                                                        )));
                                          },
                                          child: MorphismCard(
                                              child: Column(
                                            children: [
                                              Image.network(
                                                  snapshot.data?.docs[index]
                                                      ['imageurl'],
                                                  height: 100),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                // ignore: prefer_const_literals_to_create_immutables
                                                children: [
                                                  Text(
                                                    "\$" +
                                                        snapshot.data
                                                                ?.docs[index]
                                                            ['price'],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                        fontSize: 20),
                                                  ),
                                                ],
                                              ),
                                              Flexible(
                                                child: Text(
                                                  snapshot.data?.docs[index]
                                                      ['name'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: TextStyle(),
                                                ),
                                              ),
                                            ],
                                          )),
                                        ),
                                      );
                                    }));
                              })),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
