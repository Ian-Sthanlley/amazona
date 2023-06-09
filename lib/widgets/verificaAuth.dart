// ignore_for_file: file_names
import 'package:amazona/pages/anonimo/anonimo_page.dart';
import 'package:amazona/pages/home_page.dart';
import 'package:amazona/pages/inicial_page.dart';
import 'package:amazona/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerificaAuth extends StatelessWidget {
  const VerificaAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => AuthService.to.verificaAuth.value
        ? Obx(() => AuthService.to.isAnonimo.value
            ? const AnonimoPage()
            : const HomePage())
        : InicialPage());
  }
}
