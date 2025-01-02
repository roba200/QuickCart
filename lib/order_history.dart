import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'morphism_card.dart';

class OrderHistory extends StatefulWidget {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  final String orderId;
  final String paymentId;
  final String timestamp;
  final String amount;
  final String status;
  OrderHistory(
      {super.key,
      required this.orderId,
      required this.paymentId,
      required this.timestamp,
      required this.amount,
      required this.status});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            color: Colors.deepPurple,
            icon: Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Order: " + widget.orderId,
            style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
                fontSize: 15),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.userId)
                      .collection('order')
                      .doc(widget.orderId)
                      .collection('cart')
                      .snapshots(),
                  builder: (context, snapshot) {
                    return ListView.builder(
                      itemCount: snapshot.data?.docs.length ?? 0,
                      itemBuilder: (context, index) {
                        final documentSnapshot = snapshot.data?.docs[index];
                        final data = documentSnapshot?.data();

                        return MorphismCard(
                            child: Row(
                          children: [
                            Container(
                              width: 130,
                              child: Image.network(data!['imageurl']),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Column(
                                  children: [
                                    Text(
                                      data!['name'],
                                      maxLines: 3,
                                      style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 16),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "\$" +
                                              data!['price'] +
                                              " x " +
                                              data!['qty'],
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ));
                      },
                    );
                  }),
            ),
            Container(
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Payment ID: " + widget.paymentId,
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "Order Placed: " + widget.timestamp,
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "Bill Amount: \$" + widget.amount,
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "Order Status: " + widget.status,
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
