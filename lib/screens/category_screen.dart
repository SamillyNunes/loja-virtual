import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/tiles/product_tile.dart';

class CategoryScreen extends StatelessWidget {

  final DocumentSnapshot snapshot;

  CategoryScreen(this.snapshot);


  @override
  Widget build(BuildContext context) {
    return DefaultTabController( //tabs em cima
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(snapshot.data["title"]),
          centerTitle: true,
          bottom: TabBar( //tabs no appbar
              indicatorColor: Colors.white,
              tabs: <Widget>[ //se quiser tb pode colocar texto
                Tab(icon: Icon(Icons.grid_on),),
                Tab(icon: Icon(Icons.list),)
              ]
          ),
        ),
        body: FutureBuilder<QuerySnapshot>( //so vai mostrar quando pegar os dados no bd. Ps: eh interessante que identifique o tipo do future pra identificar melhor os erros
          future: Firestore.instance.collection("products").document(snapshot.documentID)
            .collection("items").getDocuments(),
            builder: (context,snapshot){
            if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator(),);
            }else{
              return TabBarView( //na tabbarview diz o que quer mostrar em cada uma das tabs
                  physics: NeverScrollableScrollPhysics(), //desativa poder arrastar pro lado e trocar de tab
                  children: [
                    GridView.builder( //builder pra nao carregar todos ao mesmo tempo, assim conforme vai rolando p baixo ele vai carregando e o app fica + leve
                      padding: EdgeInsets.all(4.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( //o gridDeleg eh o que vai informar a quant de itens na horix
                          crossAxisCount: 2,
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                          childAspectRatio: 0.65, //razao entre a largura e a altura
                        ),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context,index){
                          ProductData productData = ProductData.fromDocument(snapshot.data.documents[index]);
                          productData.category= this.snapshot.documentID;
                        //usando a classe para o caso de querer mudar o bd p outro, nao vai ter que mudar tudo, so a classe
                          return ProductTile("grid",productData);
                        }
                    ),
                    ListView.builder(
                      padding: EdgeInsets.all(4.0),
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context,index){
                        ProductData productData = ProductData.fromDocument(snapshot.data.documents[index]);
                        productData.category= this.snapshot.documentID;
                        //usando a classe para o caso de querer mudar o bd p outro, nao vai ter que mudar tudo, so a classe
                        return ProductTile("list",productData);}
                    ),
                  ]
              );
            }
          }
        )
      ),
    );
  }
}
