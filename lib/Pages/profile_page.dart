import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/Consts/colors.dart';
import 'package:e_commerce_app/Pages/orders_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:payhere_mobilesdk_flutter/payhere_mobilesdk_flutter.dart';

import '../edit_address_page.dart';
import '../Components/morphism_card.dart';

class ProfilePage extends StatefulWidget {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = '';
  void signOut() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      for (UserInfo userInfo in user.providerData) {
        if (userInfo.providerId == 'google.com') {
          // The user signed in with Google
          await GoogleSignIn().signOut();
          break;
        } else if (userInfo.providerId == 'password') {
          // The user signed in with email/password
          // No additional sign out is required
          break;
        }
      }
      await auth.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkWhite,
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            "Profile",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 34),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://www.pngall.com/wp-content/uploads/5/Profile-Male-PNG.png"),
                    radius: 80,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                        onPressed: () {},
                        icon: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.edit))),
                  )
                ],
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.userId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(
                        "error!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CupertinoActivityIndicator();
                    }
                    return Text(
                      snapshot.data!['name'],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    );
                  }),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: MorphismCard(
                  child: ListTile(
                    leading: Icon(
                      Icons.card_travel,
                      color: red,
                    ),
                    title: Text("My Orders"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrdersPage()));
                    },
                  ),
                ),
              ),
              MorphismCard(
                child: ListTile(
                  leading: Icon(
                    Icons.location_on_outlined,
                    color: red,
                  ),
                  title: Text("Shipping Address"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditAddressPage()));
                  },
                ),
              ),
              MorphismCard(
                child: ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: red,
                  ),
                  title: Text("Log Out"),
                  onTap: () {
                    signOut();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
