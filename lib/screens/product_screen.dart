import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/cart_screen.dart';
import 'package:loja_virtual/screens/login_screen.dart';


class ProductScreen extends StatefulWidget {

  final ProductData product;

  ProductScreen(this.product);


  @override
  _ProductScreenState createState() => _ProductScreenState(product);
}

class _ProductScreenState extends State<ProductScreen> {

  final ProductData product;

  String size;

  _ProductScreenState(this.product);

  @override
  Widget build(BuildContext context) {

    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        centerTitle: true,
      ),
      body: ListView( //p poder rolar pra cima e pra baixo
        children: <Widget>[
          AspectRatio(
            aspectRatio: 0.9,
            child: Carousel( //rolar imgs
              images: product.images.map(
                  (url){
                    return NetworkImage(url); //pega cada uma das urls e transforma numa imagem
                  }
              ).toList(), //transforma em lista no final
              dotSize: 4.0, //tamanho do pontinho que mostra a quant de imgs
              dotSpacing: 15.0, //espaco entre os pontos
              dotBgColor: Colors.transparent , //fundo dos pontinhos
              dotColor: primaryColor,
              autoplay: false, //para deixar as ims rolarem automaticamente
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  product.title,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500
                  ),
                  maxLines: 3, //maximo de linhas pro texto
                ),
                Text(
                  "R\$ ${product.price.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: primaryColor
                  ),
                ),
                SizedBox(height: 16.0,), //espacamento
                Text(
                  "Tamanho",
                  style: TextStyle(
                    fontSize:  16.0,
                    fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox( //usa-se quando quer a altura de algo definida
                  child: GridView(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    scrollDirection: Axis.horizontal, //dizendo a horizontal
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.5,//divisao da altura pela largura
                    ),
                    children: product.sizes.map( //para cada item
                      (s){
                        return GestureDetector(
                          onTap: (){
                            setState(() {
                              size=s;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                              border: Border.all(
                                color: s==size ? primaryColor : Colors.grey[500],
                                width: 3.0
                              )
                            ),
                            width: 50.0,
                            alignment: Alignment.center,
                            child: Text(s),
                          ),
                        );
                      }
                    ).toList(),
                  ),
                  height: 34.0,
                ),
                SizedBox(height: 16.0,),
                SizedBox(
                  height: 44.0,
                  child: RaisedButton(
                    onPressed: size!=null ?
                      (){
                        if(UserModel.of(context).isLoggedIn()){
                          CartProduct cartProduct = CartProduct();
                          cartProduct.size=size;
                          cartProduct.quantity=1;
                          cartProduct.pid=product.id;
                          cartProduct.category=product.category;
                          cartProduct.productData=product;


                          CartModel.of(context).addCartItem(cartProduct);

                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => CartScreen()
                            )
                          );

                        } else { //se nao tiver logado vai p pag de logar
                          //quando faz isso de .of esta procurando aquele objeto
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context)=>LoginScreen()
                            ),
                          );
                        }
                      } : null,//quando o botao eh nulo ele fica totalmente desabilitado
                    child: Text(UserModel.of(context).isLoggedIn() ? "Adicionar ao carrinho"
                        : "Entre para comprar",
                      style: TextStyle(
                        fontSize: 18.0
                      ),
                    ),
                    color: primaryColor,
                    textColor: Colors.white,
                  ),
                ),
                SizedBox(height: 16.0,),
                Text(
                  "Descrição",
                  style: TextStyle(
                      fontSize:  16.0,
                      fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: 16.0
                  ),
                )
              ],
            ),
          ),
        ],

      ),
    );
  }
}
