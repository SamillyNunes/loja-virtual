import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Widget _buildBodyBack()=>Container( //degrade abaixo das imgs
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 211, 118, 130),
            Color.fromARGB(255, 253, 181, 168)
          ],
          begin:Alignment.topLeft,
          end:Alignment.bottomRight
        )
      ),
    );

    return Stack( //para o caso de retornar o conteudo acima do fundo
      children: <Widget>[
        _buildBodyBack(),
        CustomScrollView( //para a barra sumir e ficar acima da tela
          slivers: <Widget>[ //
            SliverAppBar(
              floating: true, //efeito pra desaparecer
              snap: true, //efeito p aparecer
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text("Novidades"),
                centerTitle: true,
              ),
            ),
            FutureBuilder<QuerySnapshot>( //futbuilder pq os dados nao serao carregados instantaneamente
              future: Firestore.instance.collection("home").
                orderBy("pos").getDocuments(), //ordenando pela posicao
              builder: (context,snapshot) { //funcao que vai criar a tela quando forem carregados os dados
                if (!snapshot.hasData)
                  return SliverToBoxAdapter( //dentro do customScrollView nao pode usar componentes normais, logo usa esse widget p adaptar
                    child: Container(
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white), //cor do indicador de progresso
                      ),
                    ),
                  );
                else
                  return SliverStaggeredGrid.count( //.count quando ja se sabe a quant exata de itens que sera colocado
                      crossAxisCount: 2, //numero de blocos da grade
                      mainAxisSpacing: 1.0, //espacamento na vertical
                      crossAxisSpacing: 1.0, //horizontal
                      staggeredTiles: snapshot.data.documents.map( //dimensoes das imgs
                      (doc){  //p cada documento ta transformando num staggerdetile
                        return StaggeredTile.count(doc.data["x"], doc.data["y"]); //dimensoes em x e y
                        }
                      ).toList(), //transformando os docs em uma lista
                      children: snapshot.data.documents.map(
                        (doc){
                          return FadeInImage.memoryNetwork( //img que aparece suavemente
                            placeholder: kTransparentImage,
                            image: doc.data["image"],
                            fit: BoxFit.cover,
                          );
                        }
                      ).toList()

                  );

              }
            ),
          ],

        ),
      ],

    );
  }
}
