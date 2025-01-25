import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/Components/input_field.dart';
import 'package:e_commerce_app/Components/red_button.dart';
import 'package:e_commerce_app/Consts/colors.dart';
import 'package:e_commerce_app/my_textfield.dart';
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
      backgroundColor: darkWhite,
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Edit Address",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          children: [
            SizedBox(height: 20),
            InputField(
              controller: _namecontroller,
              hintText: 'Full Name',
              obscureText: false,
              labelText: 'Full Name',
            ),
            SizedBox(height: 20),
            InputField(
              controller: _address1controller,
              hintText: 'Address Line 1',
              obscureText: false,
              labelText: 'Address Line 1',
            ),
            SizedBox(height: 20),
            InputField(
              controller: _address2controller,
              hintText: 'Address Line 2',
              obscureText: false,
              labelText: 'Address Line 2',
            ),
            SizedBox(height: 20),
            InputField(
              controller: _citycontroller,
              hintText: 'City',
              obscureText: false,
              labelText: 'City',
            ),
            SizedBox(height: 20),
            InputField(
              controller: _provincecontroller,
              hintText: 'Province',
              obscureText: false,
              labelText: 'Province',
            ),
            SizedBox(height: 20),
            InputField(
              controller: _countrycontroller,
              hintText: 'Country',
              obscureText: false,
              labelText: 'Country',
            ),
            SizedBox(height: 20),
            InputField(
              controller: _zipcontroller,
              hintText: 'ZIP Code',
              obscureText: false,
              labelText: 'ZIP Code',
            ),
            SizedBox(height: 20),
            InputField(
              controller: _numbercontroller,
              hintText: 'Contact Number',
              obscureText: false,
              labelText: 'Contact Number',
            ),
            SizedBox(height: 20),
            RedButton(
              text: "Update",
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
            ),
          ],
        ),
      ),
    );
  }
}
