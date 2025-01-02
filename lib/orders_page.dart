import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/morphism_card.dart';
import 'package:e_commerce_app/order_history.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrdersPage extends StatefulWidget {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
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
          "My Orders",
          style: TextStyle(
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
              fontSize: 30),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.userId)
              .collection('order')
              .orderBy("timestamp", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("error"),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CupertinoActivityIndicator();
            }
            return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: ((context, index) {
                  Timestamp timestamp = snapshot.data!.docs[index]['timestamp'];
                  DateTime dateTime = timestamp.toDate();
                  String formattedDate =
                      DateFormat('yyyy-MM-dd – kk:mm').format(dateTime);
                  return Center(
                    child: MorphismCard(
                      child: ListTile(
                        title: Text("ID:" + snapshot.data!.docs[index].id),
                        subtitle: Text(formattedDate),
                        trailing: Text("Amount: \$" +
                            snapshot.data!.docs[index]['amount'].toString()),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderHistory(
                                        orderId: snapshot.data!.docs[index].id,
                                        paymentId: snapshot.data!.docs[index]
                                            ['paymentId'],
                                        timestamp: formattedDate,
                                        amount: snapshot
                                            .data!.docs[index]['amount']
                                            .toString(),
                                        status: snapshot.data!.docs[index]
                                            ['status'],
                                      )));
                        },
                      ),
                    ),
                  );
                }));
          }),
    );
  }
}
