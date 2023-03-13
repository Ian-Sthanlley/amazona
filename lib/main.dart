import 'package:amazona/config.dart';
import 'package:amazona/repositories/produtos_repository.dart';
import 'package:amazona/widgets/verificaAuth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() async {
  await initConfig();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ProdutosRepository(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.light,
      ),
      title: 'Amazona',
      debugShowCheckedModeBanner: false,
      home: const VerificaAuth(),
    );
  }
}
