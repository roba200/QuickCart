import 'package:e_commerce_app/Components/item_card.dart';
import 'package:flutter/material.dart';

class LoginPageNew extends StatefulWidget {
  const LoginPageNew({super.key});

  @override
  State<LoginPageNew> createState() => _LoginPageNewState();
}

class _LoginPageNewState extends State<LoginPageNew> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFE5E5E5),
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 250,
            childAspectRatio: 1,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
          ),
          itemCount: 10,
          itemBuilder: (context, index) {
            return ItemCard(
              imageUrl:
                  'https://shop.mango.com/assets/rcs/pics/static/T7/fotos/S/77024441_28.jpg?imwidth=640&imdensity=1&ts=1720179294095',
              productName: 'T-shirt',
              price: '4',
            );
          },
        ));
  }
}
