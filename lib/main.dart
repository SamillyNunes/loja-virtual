import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/home_screen.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(), //tudo que estiver abaixo do user model vai ter acesso a ele e sera modificado se for preciso
      child: ScopedModelDescendant<UserModel>(
          builder: (context,child,model){
            return ScopedModel<CartModel>(
              model: CartModel(model),
              child: MaterialApp(
                title: "Flutter's Clothing",
                theme: ThemeData(
                    primarySwatch: Colors.blue,
                    primaryColor: Color.fromARGB(255, 4, 125, 141)
                ),
                debugShowCheckedModeBanner: false,
                home: HomeScreen(),
              )
            );
          }
      )
    );
  }
}
