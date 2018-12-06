import 'dart:async';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserModel extends Model{ //Model eh um obj que vai guardar os estados de alguma coisa (nesse caso o login) e conforme vai mudando o estado ele observa e altera

  FirebaseAuth _auth = FirebaseAuth.instance; //singletton (so tem uma instancia o tempo inteiro)

  FirebaseUser firebaseUser;
  Map<String,dynamic> userData=Map(); //vai abrigar os dados + importantes do usuario

  bool isLoading=false;  //indicara quando o UserMod estiver processando alguma coisa

  static UserModel of(BuildContext context) => //statico eh um metodo da classe e n do obj, essa funcao vai permitir chamar o scoped em qualquer canto
      ScopedModel.of<UserModel>(context);

  @override
  void addListener(VoidCallback listener) { //quando rodar o app de inicio
    super.addListener(listener);

    _loadCurrentUser(); //ele vai carregar o usuario atual

  }



  void signUp({@required Map<String,dynamic> userData,@required String pass,@required VoidCallback onSucess,
    @required VoidCallback onFail} ){ //voidcallback eh uma funcao que sera chamada daqui de dentro

    isLoading=true;
    notifyListeners();

    _auth.createUserWithEmailAndPassword(
        email: userData["email"],
        password: pass
    ).then((user) async{ //then eh pra quando processar o que esta acima se tiver sucesso
      firebaseUser=user;

      await _saveUserData(userData); //salvar os dados como nome

      onSucess();
      isLoading=false;
      notifyListeners();
    }).catchError((e){ //se tiver fracasso
      onFail();
      isLoading=false;
      notifyListeners();

    });
  }

  void singIn({@required String email,@required String pass,@required VoidCallback onSucess,
      @required VoidCallback onFail}) async{
    
    isLoading=true;
    notifyListeners(); //para dizer ao flutter que tem que reconstruir os descendentes pois algo foi modificado

    _auth.signInWithEmailAndPassword(
        email: email,
        password: pass

    ).then((user) async{
      firebaseUser=user;

      await _loadCurrentUser();

      onSucess();
      isLoading=false;
      notifyListeners();

    }
    ).catchError((e){
      onFail();
      isLoading=false;
      notifyListeners();

    });
  }

  void signOut(){
    _auth.signOut();

    userData = Map();
    firebaseUser=null;
    notifyListeners();
  }

  void recoverPass(String email){
    _auth.sendPasswordResetEmail(email: email);
  }

  bool isLoggedIn(){
    return firebaseUser!=null;
  }

  Future<Null> _saveUserData(Map<String,dynamic> userData) async{
    this.userData=userData;
    await Firestore.instance.collection("users").document(firebaseUser.uid).setData(userData); //firebaseUser.uid eh o codigo unico para o usuario
  }

  Future<Null> _loadCurrentUser() async{
    if(firebaseUser==null){ //verificando se o usuario eh nulo
      firebaseUser = await _auth.currentUser();//pegando do firebase o user atual
    }

    if(firebaseUser!=null){ //quando ele loga com sucesso
      if(userData["name"]==null){
        DocumentSnapshot docUser =
          await Firestore.instance.collection("users").document(firebaseUser.uid).get();

        userData=docUser.data;
      }
    }
    notifyListeners();
  }

}