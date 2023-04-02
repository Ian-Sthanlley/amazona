import 'package:amazona/repositories/dio_repository.dart';
import 'package:amazona/widgets/verificaAuth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Rx<User?> _firebaseUser;
  var verificaAuth = false.obs;
  var isAnonimo = false.obs;

  @override
  void onInit() {
    super.onInit();

    _firebaseUser = Rx<User?>(_auth.currentUser);
    _firebaseUser.bindStream(_auth.authStateChanges());

    ever(_firebaseUser, _mudanca);
  }

  _mudanca(User? user) {
    if (user != null) {
      verificaAuth.value = true;
      if (user.isAnonymous) {
        isAnonimo.value = true;
      } else {
        isAnonimo.value = false;
      }
    } else {
      verificaAuth.value = false;
    }
  }

  User? get user => _firebaseUser.value;
  static AuthService get to => Get.find<AuthService>();

  showSnack(String erro) {
    Get.snackbar(
      'Ops..',
      erro,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color.fromARGB(132, 255, 82, 82),
    );
  }

  login(String email, String senha) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
      DioRepository.to.login();
    } catch (erro) {
      if (erro.toString().contains('wrong-password')) {
        showSnack('Senha incorreta.');
      } else if (erro.toString().contains('user-not-found')) {
        showSnack('Credencial não registrada.');
      } else {
        showSnack('Erro ao tentar entrar.');
      }
    }
  }

  Future<bool> loginTeste(String email, String senha) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
      return true;
    } catch (erro) {
      return false;
    }
  }

  Future<bool> criar(String email, String senha) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: senha);
      return true;
    } catch (e) {
      return false;
    }
  }

  logout() async {
    try {
      await _auth.signOut();
      DioRepository.to.apagaToken();
      Get.offAll(() => const VerificaAuth());
    } catch (erro) {
      Get.offAll(() => const VerificaAuth());
    }
  }

  anonimo() async {
    try {
      await _auth.signInAnonymously();
    } catch (erro) {
      showSnack('Erro ao tentar entrar.');
    }
  }
}
