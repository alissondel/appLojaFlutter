import 'package:appfef/helpers/firebase_errors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:appfef/models/user.dart';

class UserManager extends ChangeNotifier {
  UserManager() {
    //Acessando o metodo para verificar qual usuario está logado
    _loadCurrentUser();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final Firestore firestore = Firestore.instance;
  User user; 

  bool _loading = false;
  bool get loading => _loading;

  Future<void> signIn({User user, Function onFail, Function onSuccess}) async {
    try {
      _loading = true;
      final AuthResult result = await auth.signInWithEmailAndPassword(
          email: user.email, password: user.password);
      await _loadCurrentUser(firebaseUser: result.user);
      onSuccess();
    } on PlatformException catch (e) {
      onFail(getErrorString(e.code));
    }
    _loading = false;
  }

  Future<void> register(
      {User user, Function onFail, Function onSuccess}) async {
    try {
      final AuthResult result = await auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);

      user.id = result.user.uid;
      this.user = user;
      await user.saveData();

      onSuccess();
    } on PlatformException catch (e) {
      onFail(getErrorString(e.code));
    }
  }

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> _loadCurrentUser({FirebaseUser firebaseUser}) async {
    final FirebaseUser currentUser = firebaseUser ?? await auth.currentUser();
    if (currentUser != null) {
      //DocumentSnapshot realiza a leitura da coleção no firebase
      final DocumentSnapshot docUser =
          await firestore.collection('users').document(currentUser.uid).get();
          //docUser => possui o uid do usuario corrente
      user = User.fromDocument(docUser);

      notifyListeners();
    }
  }
}
