import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/screens/category_screen.dart';

class CategoryTile extends StatelessWidget {

  final DocumentSnapshot snapshot;

  CategoryTile(this.snapshot); //passar o doc que vai ter os dados

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar( //leading eh o icone que fica a esquerda
        radius: 25.0,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(snapshot.data["icon"]),
      ),
      title: Text(snapshot.data["title"]),
      trailing: Icon(Icons.keyboard_arrow_right), //trailing eh aquela setinha que fica bem no canto direito
      onTap: (){
        Navigator.of(context).push( //passa pra a prox tela
          MaterialPageRoute(builder: (context)=> CategoryScreen(snapshot))
        );
      },
    );
  }
}
