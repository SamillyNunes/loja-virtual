import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/tiles/drawer_tile.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomDrawer extends StatelessWidget {

  final PageController pageController;

  CustomDrawer(this.pageController);

  Widget _buildBDrawerBack()=>Container( //degrade
    decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 203, 223, 241),
              Colors.white
            ],
            begin:Alignment.topCenter,
            end:Alignment.bottomCenter
        )
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: <Widget>[
          _buildBDrawerBack(),
          ListView(
            padding: EdgeInsets.only(left: 32.0,top: 16.0),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8.0),
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                height: 170.0,
                child: Stack(
                  children: <Widget>[
                    Positioned( //para especificar onde esta posicionaod
                      top:8.0,
                      left: 0.0,
                      child: Text("Flutter's\nClothing",
                        style: TextStyle(fontSize: 34.0,fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                      left: 0.0,
                      bottom: 0.0,
                      child: ScopedModelDescendant<UserModel>(
                        builder: (contex,child,model){
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start, //p ficar alinhado na esquerda
                            children: <Widget>[
                              Text("Olá, ${!model.isLoggedIn() ? "" : model.userData["name"]}",
                                style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                child: Text(
                                  !model.isLoggedIn() ?
                                    "Entre ou cadastre-se >"
                                  : "Sair",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                onTap: (){
                                  if(!model.isLoggedIn()) {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => LoginScreen())
                                    );
                                  } else {
                                    model.signOut();
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      )
                    ),
                  ],
                ),
              ),
              Divider(),
              DrawerTile(Icons.home,"Início",pageController,0), //indices de acordo com a ordem na lista do homescreen
              DrawerTile(Icons.list,"Produtos",pageController,1),
              DrawerTile(Icons.location_on,"Encontre uma loja",pageController,2),
              DrawerTile(Icons.playlist_add_check,"Meus Pedidos",pageController,3),
            ],
          )
        ],
      ),
    );
  }
}
