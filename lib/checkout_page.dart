import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:payhere_mobilesdk_flutter/payhere_mobilesdk_flutter.dart';

import 'edit_address_page.dart';
import 'morphism_card.dart';

class CheckoutPage extends StatefulWidget {
  final String userId;
  final int totalAmount;

  CheckoutPage({super.key, required this.userId, required this.totalAmount});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final Stream<DocumentSnapshot> _shippingStream = FirebaseFirestore.instance
      .collection('constants')
      .doc('shipping')
      .snapshots();

  List<String> _shippingNamesList = [];
  List<int> _shippingCostsList = [];
  int dropdownValue = 0;
  String? _selectedShippingName;
  int listIndex = 0;

  @override
  late AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> _snapshot;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          color: Colors.deepPurple,
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Checkout",
          style: TextStyle(
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
              fontSize: 30),
        ),
      ),
      body: Column(
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.userId)
                  .snapshots(),
              builder: (context, snapshot) {
                _snapshot = snapshot;
                if (snapshot.hasData) {
                  return MorphismCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Shipping Address",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditAddressPage()));
                                },
                                icon: Icon(Icons.edit_location_alt_outlined))
                          ],
                        ),
                        Text(snapshot.data?['name']),
                        Text(snapshot.data?['address1']),
                        Text(snapshot.data?['address2']),
                        Text(snapshot.data?['city']),
                        Text(snapshot.data?['province']),
                        Text(snapshot.data?['country']),
                        Text(snapshot.data?['zip']),
                        Text(snapshot.data?['number']),
                      ],
                    ),
                  );
                } else {
                  return CupertinoActivityIndicator();
                }
              }),
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.userId)
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
                            width: 50,
                            child: Image.network(data!['imageurl']),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: Column(
                                children: [
                                  Text(
                                    data!['name'],
                                    maxLines: 3,
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 10),
                                  ),
                                  SizedBox(
                                    height: 5,
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
                                            fontSize: 10,
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
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Shipping Method"),
                StreamBuilder<DocumentSnapshot>(
                  stream: _shippingStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text('Loading...');
                    }

                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    _shippingNamesList = List<String>.from(data['name']);
                    _shippingCostsList = List<int>.from(data['cost']);

                    return DropdownButton<int>(
                      items: List<DropdownMenuItem<int>>.generate(
                          _shippingNamesList.length, (int index) {
                        return DropdownMenuItem<int>(
                          value: _shippingCostsList[index],
                          child: Text(
                              '${_shippingNamesList[index]} (\$${_shippingCostsList[index]})'),
                          key: ValueKey<int>(index),
                        );
                      }),
                      onChanged: (int? newValue) {
                        listIndex = _shippingCostsList.indexOf(newValue!);
                        _selectedShippingName = _shippingNamesList[listIndex];
                        setState(() {
                          dropdownValue = newValue;
                          print(_selectedShippingName);
                        });
                      },
                      value: dropdownValue == 0
                          ? _shippingCostsList[0]
                          : dropdownValue,
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            height: 70,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.userId)
                  .collection('cart')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loading...');
                }
                int totalAmount = dropdownValue;
                snapshot.data!.docs.forEach((doc) {
                  totalAmount +=
                      int.parse(doc['price']) * int.parse(doc['qty']);
                });
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      '\$${totalAmount}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                    CupertinoButton(
                        disabledColor: Colors.grey,
                        color: Colors.deepPurple,
                        child: Text("Pay"),
                        onPressed: dropdownValue != 0
                            ? () async {
                                DocumentReference DocRef = FirebaseFirestore
                                    .instance
                                    .collection('orders')
                                    .doc();
                                Map paymentObject = {
                                  "sandbox":
                                      true, // true if using Sandbox Merchant ID
                                  "merchant_id":
                                      "1221874", // Replace your Merchant ID
                                  "notify_url":
                                      "https://ent13zfovoz7d.x.pipedream.net/",
                                  "order_id": DocRef.id,
                                  "items": DocRef.id,
                                  "amount": widget.totalAmount + dropdownValue,
                                  "currency": "LKR",
                                  "first_name": "Saman",
                                  "last_name": "Perera",
                                  "email": "samanp@gmail.com",
                                  "phone": "0771234567",
                                  "address": "No.1, Galle Road",
                                  "city": "Colombo",
                                  "country": "Sri Lanka",
                                  "delivery_address":
                                      "No. 46, Galle road, Kalutara South",
                                  "delivery_city": "Kalutara",
                                  "delivery_country": "Sri Lanka",
                                  "custom_1": "",
                                  "custom_2": ""
                                };
                                PayHere.startPayment(paymentObject,
                                    (paymentId) async {
                                  QuerySnapshot querySnapshot =
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(widget.userId)
                                          .collection('cart')
                                          .get();

                                  querySnapshot.docs.forEach((doc) async {
                                    DocumentReference destDocRef =
                                        DocRef.collection('cart').doc(doc.id);

                                    Map<String, dynamic> data =
                                        doc.data() as Map<String, dynamic>;

                                    await destDocRef.set(data);

                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(widget.userId)
                                        .collection('order')
                                        .doc(DocRef.id)
                                        .collection('cart')
                                        .doc(doc.id)
                                        .set(data);

                                    //delete cart items

                                    QuerySnapshot querySnapshot =
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(widget.userId)
                                            .collection('cart')
                                            .get();
                                    querySnapshot.docs.forEach((doc) async {
                                      await doc.reference.delete();
                                    });
                                  });
                                  print(
                                      "One Time Payment Success. Payment Id: $paymentId");
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(widget.userId)
                                      .collection('order')
                                      .doc(DocRef.id)
                                      .set({
                                    "orderId": DocRef.id,
                                    "paymentId": paymentId,
                                    "amount":
                                        widget.totalAmount + dropdownValue,
                                    "timestamp": FieldValue.serverTimestamp(),
                                    "shipping": _selectedShippingName,
                                    "status": "Processing",
                                  });
                                  DocRef.set({
                                    "userId": widget.userId,
                                    "orderId": DocRef.id,
                                    "paymentId": paymentId,
                                    "amount":
                                        widget.totalAmount + dropdownValue,
                                    "timestamp": FieldValue.serverTimestamp(),
                                    'name': _snapshot.data!['name'],
                                    'address1': _snapshot.data!['address1'],
                                    'address2': _snapshot.data!['address2'],
                                    'city': _snapshot.data!['city'],
                                    'province': _snapshot.data!['province'],
                                    'country': _snapshot.data!['country'],
                                    'zip': _snapshot.data!['zip'],
                                    'number': _snapshot.data!['number'],
                                    "shipping": _selectedShippingName,
                                    "status": "Processing",
                                  });

                                  Navigator.pop(context);
                                }, (error) {
                                  print(
                                      "One Time Payment Failed. Error: $error");
                                  showDialog(
                                      context: context,
                                      builder: ((context) {
                                        return AlertDialog(
                                          title: Text(error),
                                          actions: [
                                            CupertinoButton(
                                                child: Text("OK"),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                })
                                          ],
                                        );
                                      }));
                                }, () {
                                  print("One Time Payment Dismissed");
                                  showDialog(
                                      context: context,
                                      builder: ((context) {
                                        return AlertDialog(
                                          title: Text(
                                              "One Time Payment Dismissed"),
                                          actions: [
                                            CupertinoButton(
                                                child: Text("OK"),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                })
                                          ],
                                        );
                                      }));
                                });
                              }
                            : null)
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
