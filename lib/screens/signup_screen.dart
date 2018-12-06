import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController= TextEditingController();
  final _emailController= TextEditingController();
  final _passController= TextEditingController();
  final _adressController= TextEditingController();

  final _formKey = GlobalKey<FormState>(); //para acessar o conteudo do formulario

  final _scaffoldKey = GlobalKey<ScaffoldState>(); //para poder usar o scafold original

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Criar Conta"),
          centerTitle: true,
        ),
        body: ScopedModelDescendant<UserModel>(
          builder: (context,child,model){
            if(model.isLoading)
              return Center(child: CircularProgressIndicator(),);
            else
              return  Form( //no form tem que colocar um email valido e uma senha validac
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(16.0),
                  children: <Widget>[
                    TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                            hintText: "Nome completo"
                        ),
                        validator:(text){ //verificacao
                          if(text.isEmpty) return "Nome inválido!";
                        }
                    ),
                    SizedBox(height: 16.0,),
                    TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                            hintText: "Email"
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator:(text){ //verificacao
                          if(text.isEmpty || !text.contains("@")) return "E-mail inválido!";
                        }
                    ),
                    SizedBox(height: 16.0,),
                    TextFormField(
                      controller: _passController,
                      decoration: InputDecoration(
                          hintText: "Senha"
                      ),
                      obscureText: true, //nao poder ver a senha
                      validator: (text){
                        if(text.isEmpty || text.length<6) return "Senha inválida!";
                      },
                    ),
                    SizedBox(height: 16.0,),
                    TextFormField(
                        controller: _adressController,
                        decoration: InputDecoration(
                            hintText: "Endereço"
                        ),
                        validator:(text){ //verificacao
                          if(text.isEmpty) return "Endereço inválido!";
                        }
                    ),

                    SizedBox(height: 16.0,),
                    SizedBox(
                      height: 44.0,
                      child: RaisedButton(
                        child: Text("Criar conta",
                          style: TextStyle(
                              fontSize: 18.0
                          ),
                        ),
                        textColor: Colors.white,
                        color: Theme.of(context).primaryColor,
                        onPressed: (){
                          if(_formKey.currentState.validate()){ //a senha nao vai aqui pq vai salvar no bd de modo que eu (dona) nao possa ve-la
                            Map<String,dynamic> userData = {
                              "name":_nameController.text,
                              "email":_emailController.text,
                              "adress":_adressController.text
                            };

                            model.signUp(
                                userData: userData,
                                pass: _passController.text,
                                onSucess: _onSucess,
                                onFail: _onFail
                            );
                          }
                        },
                      ),
                    )
                  ],
                ),

              );
          },
        )

    );
  }

  void _onSucess(){
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text("Usuário criado com sucesso!"),
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 2),
      )
    );

    Future.delayed(Duration(seconds: 2)).then((_){
      Navigator.of(context).pop();
    });

  }

  void _onFail(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Falha ao criar usuário!"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        )
    );
  }
}