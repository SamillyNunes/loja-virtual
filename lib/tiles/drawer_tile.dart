import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {

  final IconData icon;
  final String text;
  final PageController controller;
  final int page; //recebe qual pag o item corresponde

  DrawerTile(this.icon,this.text,this.controller,this.page); //quando for criar passa um icone e um texto

  @override
  Widget build(BuildContext context) {
    return Material( //material p ter um efeito visual quando clicar nele
      color: Colors.transparent,
      child: InkWell( //area retangular do material que responde ao toque e da o efeito quando clica
        onTap: (){
          Navigator.of(context).pop(); //apaga da pilha
          controller.jumpToPage(page); //passar pra a pagina
        },
        child: Container(
          height: 60.0,
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                size: 32.0,
                color: controller.page == page ?
                  Theme.of(context).primaryColor : Colors.grey,
              ),
              SizedBox(width: 32.0,), //espacamento entre o icone e o texto
              Text(
                text,
                style: TextStyle(
                  fontSize: 16.0,
                  color: controller.page.round() == page ? //verifica se o numero da pag do controlador eh a pagina (e arredonda pq eh em double)
                    Theme.of(context).primaryColor : Colors.grey
                ),
              )
            ],
          ),
        ),
      ),

    );
  }
}
