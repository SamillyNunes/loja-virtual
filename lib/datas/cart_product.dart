import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/datas/product_data.dart';

class CartProduct{ //classe que vai armazenar um produto do carrinho
  String cid; //id do carrinho

  String category;
  String pid; //id do produto

  int quantity; //quantidade do produto
  String size;

  ProductData productData;

  CartProduct();

  CartProduct.fromDocument(DocumentSnapshot document){
    cid = document.documentID;
    category = document.data["category"];
    pid = document.data["pid"];
    quantity = document.data["quantity"];
    size = document.data["size"];
  }

  Map<String,dynamic> toMap(){
    return {
      "category":category,
      "pid":pid,
      "quantity":quantity,
      "size":size,
      "product":productData.toResumeMap()

    };
  }


  }
