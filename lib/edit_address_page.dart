import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class EditAddressPage extends StatefulWidget {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  EditAddressPage({super.key});

  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _address1controller = TextEditingController();
  TextEditingController _address2controller = TextEditingController();
  TextEditingController _citycontroller = TextEditingController();
  TextEditingController _provincecontroller = TextEditingController();
  TextEditingController _countrycontroller = TextEditingController();
  TextEditingController _zipcontroller = TextEditingController();
  TextEditingController _numbercontroller = TextEditingController();

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get()
        .then((value) {
      _namecontroller.text = value['name'];
      _address1controller.text = value['address1'];
      _address2controller.text = value['address2'];
      _citycontroller.text = value['city'];
      _provincecontroller.text = value['province'];
      _countrycontroller.text = value['country'];
      _zipcontroller.text = value['zip'];
      _numbercontroller.text = value['number'];
    });
    super.initState();
  }

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
          "Edit Address",
          style: TextStyle(
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
              fontSize: 30),
        ),
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(hintText: "Full Name"),
            controller: _namecontroller,
          ),
          TextField(
            decoration: InputDecoration(hintText: "Address Line 1"),
            controller: _address1controller,
          ),
          TextField(
            decoration: InputDecoration(hintText: "Address Line 2"),
            controller: _address2controller,
          ),
          TextField(
            decoration: InputDecoration(hintText: "City"),
            controller: _citycontroller,
          ),
          TextField(
            decoration: InputDecoration(hintText: "Province"),
            controller: _provincecontroller,
          ),
          TextField(
            decoration: InputDecoration(hintText: "Country"),
            controller: _countrycontroller,
          ),
          TextField(
            decoration: InputDecoration(hintText: "ZIP Code"),
            controller: _zipcontroller,
          ),
          TextField(
            decoration: InputDecoration(hintText: "Contact Number"),
            controller: _numbercontroller,
          ),
          CupertinoButton(
            child: Text("Update"),
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.userId)
                  .update({
                'name': _namecontroller.text,
                'address1': _address1controller.text,
                'address2': _address2controller.text,
                'city': _citycontroller.text,
                'province': _provincecontroller.text,
                'country': _countrycontroller.text,
                'zip': _zipcontroller.text,
                'number': _numbercontroller.text,
              }).then((value) {
                Navigator.pop(context);
              });
            },
            color: Colors.deepPurple,
          ),
        ],
      ),
    );
  }
}
