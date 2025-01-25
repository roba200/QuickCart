import 'package:e_commerce_app/Components/input_field.dart';
import 'package:e_commerce_app/Components/red_button.dart';
import 'package:e_commerce_app/Consts/colors.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../my_textfield.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailcontroller = TextEditingController();

  void sendResetLink() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // try sign in
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(
        email: emailcontroller.text,
      )
          .then((value) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text("Password reset link sent to ${emailcontroller.text}")));
      });
      // pop the loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);
      // WRONG EMAIL
      if (e.code == 'user-not-found') {
        // show error to user
        wrongEmailMessage();
      }

      // WRONG PASSWORD
    }
  }

  // wrong email message popup
  void wrongEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              'Incorrect Email',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  void linkSendMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              'Incorrect Email',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: darkWhite,
      ),
      backgroundColor: darkWhite,
      body: Center(
          child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                child: ListView(
                  children: [
                    Text(
                      "Forgot password",
                      style:
                          TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 73, bottom: 20),
                      child: Text(
                          "Please, enter your email address. You will recieve a link to create a new password via email",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 16,
                          )),
                    ),
                    InputField(
                      labelText: 'Email',
                      controller: emailcontroller,
                      hintText: 'Email',
                      obscureText: false,
                      validator: (email) =>
                          email != null && !EmailValidator.validate(email)
                              ? "Enter a valid Email"
                              : null,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: RedButton(
                          text: "SEND",
                          onPressed: () {
                            final form = formKey.currentState!;
                            if (form.validate()) {
                              sendResetLink();
                            }
                          }),
                    )
                  ],
                ),
              ))),
    );
  }
}
