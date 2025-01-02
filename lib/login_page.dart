import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/Components/custom_icon_button.dart';
import 'package:e_commerce_app/Components/input_field.dart';
import 'package:e_commerce_app/Components/red_button.dart';
import 'package:e_commerce_app/Consts/colors.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'forgot_password_page.dart';
import 'my_button.dart';
import 'my_textfield.dart';
import 'square_tile.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  LoginPage({super.key, required this.showRegisterPage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() async {
    // show loading circle
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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
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
      else if (e.code == 'wrong-password') {
        // show error to user
        wrongPasswordMessage();
      }
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

  // wrong password message popup
  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              'Incorrect Password',
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      extendBody: true,
      backgroundColor: darkWhite,
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: ListView(
              children: [
                Text(
                  "Login",
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Forget your password?",
                      style: TextStyle(fontSize: 14),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPasswordPage()));
                        },
                        icon: Icon(
                          Icons.forward,
                          color: red,
                        )),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 38),
                  child: RedButton(
                      text: "LOGIN",
                      onPressed: () {
                        final form = formKey.currentState!;
                        if (form.validate()) {
                          signUserIn();
                        }
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 194),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Not a member?',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: widget.showRegisterPage,
                            child: const Text(
                              'Register now',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text("Or sign up with social account")],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconButton(
                          url: "lib/images/google.png",
                          onPressed: signInWithGoogle),
                      CustomIconButton(
                          url: "lib/images/apple.png", onPressed: () {})
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<bool> checkIfDocumentExists(
      String collectionName, String documentId) async {
    DocumentReference documentReference =
        firestore.collection(collectionName).doc(documentId);
    DocumentSnapshot documentSnapshot = await documentReference.get();
    return documentSnapshot.exists;
  }

  Future<void> signInWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    await auth.signInWithCredential(credential).then((value) async {
      if (await checkIfDocumentExists(
              'users', FirebaseAuth.instance.currentUser!.uid) ==
          false) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
          "address1": "",
          "address2": "",
          "city": "",
          "country": "",
          "name": googleUser.displayName,
          "number": "",
          "province": "",
          "zip": "",
        });
      }
    });
  }
}
