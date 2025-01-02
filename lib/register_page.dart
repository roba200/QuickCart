import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/Components/input_field.dart';
import 'package:e_commerce_app/Components/red_button.dart';
import 'package:e_commerce_app/Consts/colors.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'my_button.dart';
import 'my_textfield.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({super.key, required this.showLoginPage});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  final nameController = TextEditingController();
  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();
  final cityController = TextEditingController();
  final provinceController = TextEditingController();
  final countryController = TextEditingController();
  final zipController = TextEditingController();
  final numberController = TextEditingController();

  Future signUp() async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((value) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        "address1": address1Controller.text,
        "address2": address2Controller.text,
        "city": cityController.text,
        "country": countryController.text,
        "name": nameController.text,
        "number": numberController.text,
        "province": provinceController.text,
        "zip": zipController.text,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkWhite,
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: ListView(
              children: [
                Text(
                  "Sign up",
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 73),
                  child: InputField(
                      validator: (email) =>
                          email != null && !EmailValidator.validate(email)
                              ? 'Enter a valid email'
                              : null,
                      labelText: 'Email',
                      obscureText: false,
                      controller: emailController,
                      hintText: 'Enter your email'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: InputField(
                      validator: (value) {
                        if (value != null && value.length < 6) {
                          return "Password must have least 6 charactors";
                        } else {
                          return null;
                        }
                      },
                      labelText: 'Password',
                      obscureText: true,
                      controller: passwordController,
                      hintText: 'Enter your Password'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: InputField(
                      validator: (value) {
                        if (value != null && value.length < 6) {
                          return "Password must have least 6 charactors";
                        } else {
                          return null;
                        }
                      },
                      labelText: 'Confirm Password',
                      obscureText: true,
                      controller: confirmpasswordController,
                      hintText: 'Confirm your Password'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: InputField(
                      validator: (value) {
                        if (value != null && value.length <= 0) {
                          return "Full name can't be empty";
                        } else {
                          return null;
                        }
                      },
                      labelText: 'Full Name',
                      obscureText: false,
                      controller: nameController,
                      hintText: 'Enter your Full Name'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: InputField(
                      validator: (value) {
                        if (value != null && value.length <= 0) {
                          return "This field can't be empty";
                        } else {
                          return null;
                        }
                      },
                      labelText: 'Address Line 1',
                      obscureText: false,
                      controller: address1Controller,
                      hintText: 'Address Line 1'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: InputField(
                      validator: (value) {
                        if (value != null && value.length <= 0) {
                          return "This field can't be empty";
                        } else {
                          return null;
                        }
                      },
                      labelText: 'Address Line 2',
                      obscureText: false,
                      controller: address2Controller,
                      hintText: 'Address Line 2'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: InputField(
                      validator: (value) {
                        if (value != null && value.length <= 0) {
                          return "This field can't be empty";
                        } else {
                          return null;
                        }
                      },
                      labelText: 'City',
                      obscureText: false,
                      controller: cityController,
                      hintText: 'City'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: InputField(
                      validator: (value) {
                        if (value != null && value.length <= 0) {
                          return "This field can't be empty";
                        } else {
                          return null;
                        }
                      },
                      labelText: 'Province',
                      obscureText: false,
                      controller: provinceController,
                      hintText: 'Province'),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: InputField(
                      validator: (value) {
                        if (value != null && value.length <= 0) {
                          return "This field can't be empty";
                        } else {
                          return null;
                        }
                      },
                      labelText: 'Country',
                      obscureText: false,
                      controller: countryController,
                      hintText: 'Country',
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: InputField(
                      validator: (value) {
                        if (value != null && value.length <= 0) {
                          return "This field can't be empty";
                        } else {
                          return null;
                        }
                      },
                      labelText: 'ZIP Code',
                      obscureText: false,
                      controller: zipController,
                      hintText: 'ZIP Code'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: InputField(
                      validator: (value) {
                        if (value != null && value.length <= 0) {
                          return "This field can't be empty";
                        } else {
                          return null;
                        }
                      },
                      labelText: 'Contact Number',
                      obscureText: false,
                      controller: numberController,
                      hintText: 'Contact Number'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Already Have an Account?",
                      style: TextStyle(fontSize: 14),
                    ),
                    IconButton(
                        onPressed: () {
                          widget.showLoginPage();
                        },
                        icon: Icon(
                          Icons.forward,
                          color: red,
                        )),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 38, bottom: 50),
                  child: RedButton(
                      text: "SIGN UP",
                      onPressed: () {
                        final form = formKey.currentState!;
                        if (form.validate()) {}
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
