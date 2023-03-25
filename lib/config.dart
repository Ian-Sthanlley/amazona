import 'package:amazona/controller/produto_controller.dart';
import 'package:amazona/firebase_options.dart';
import 'package:amazona/repositories/produtos_repository.dart';
import 'package:amazona/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

initConfig() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.lazyPut<AuthService>(() => AuthService());
  Get.lazyPut<ProdutosRepository>(() => ProdutosRepository());
  Get.lazyPut<ProdutoController>(() => ProdutoController(), fenix: true);
}
