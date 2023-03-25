import 'dart:collection';
import 'package:amazona/model/gasto_adicional.dart';
import 'package:amazona/model/produto.dart';
import 'package:amazona/repositories/produtos_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProdutoController extends ChangeNotifier {
  static ProdutoController get to => Get.find<ProdutoController>();
  List<Produto> _produtos = [];
  UnmodifiableListView<Produto> get produtos => UnmodifiableListView(_produtos);

  ProdutoController() {
    initController();
  }

  void editaGasto(
      {required GastoAdicional gastoAdicional,
      required String data,
      required double valor,
      required String motivo}) {
    gastoAdicional.data = data;
    gastoAdicional.valor = valor;
    gastoAdicional.descricao = motivo;

    notifyListeners();
  }

  initController() async {
    _produtos = await ProdutosRepository.to.findAllVenda();
    notifyListeners();
  }

  Future<void> cadastraProduto(Produto produto) async {
    final int status = await ProdutosRepository.to.registraProduto(produto);
    if (status == 201) {
      Get.snackbar(
        'Oba..',
        'Produto registrado com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromARGB(186, 82, 255, 91),
      );
    } else {
      Get.snackbar(
        'Ops..',
        'Falha ao registrar produto.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromARGB(132, 255, 82, 82),
      );
    }

    notifyListeners();
  }

  Future<void> editaProduto(Produto produto) async {
    final int status = await ProdutosRepository.to.editaProduto(produto);
    if (status == 200) {
      Get.snackbar(
        'Oba..',
        'Produto editado com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromARGB(186, 82, 255, 91),
      );
    } else {
      Get.snackbar(
        'Ops..',
        'Falha ao editar produto.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromARGB(132, 255, 82, 82),
      );
    }
    notifyListeners();
  }

  Future<void> setVendido(Produto produto) async {
    final int? id = produto.id;
    final int status = await ProdutosRepository.to.setVendido(id!, produto);

    if (status == 200) {
      Get.snackbar(
        'Oba..',
        'Produto vendido com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromARGB(186, 82, 255, 91),
      );
    } else {
      Get.snackbar(
        'Ops..',
        'Falha ao vender produto.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromARGB(132, 255, 82, 82),
      );
    }
    notifyListeners();
  }

  Future<void> addGasto(int id, GastoAdicional gastoAdicional) async {
    final int status = await ProdutosRepository.to.addGasto(id, gastoAdicional);
    if (status == 201) {
      Get.snackbar(
        'Oba..',
        'Gasto registrado com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromARGB(186, 82, 255, 91),
      );
    } else {
      Get.snackbar(
        'Ops..',
        'Falha ao registrar gasto.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromARGB(132, 255, 82, 82),
      );
    }
    notifyListeners();
  }
}
