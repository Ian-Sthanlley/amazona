import 'dart:collection';
import 'package:amazona/model/gasto_adicional.dart';
import 'package:amazona/model/produto.dart';
import 'package:amazona/repositories/dio_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProdutoController extends ChangeNotifier {
  static ProdutoController get to => Get.find<ProdutoController>();

  List<Produto> _produtos = [];

  RxList<GastoAdicional> gasto = RxList<GastoAdicional>([]);

  RxList<GastoAdicional> gastoVazio = RxList<GastoAdicional>([]);

  Rx<Produto> produto = Produto(
      nome: '',
      descricao: '',
      estado: '',
      dataEntrada: '',
      dataSaida: '',
      anotacaoSaida: '',
      valorPago: 0,
      valorAvista: 0,
      valor5Vezes: 0,
      valor10Vezes: 0,
      gastosAdicionais: []).obs;

  Produto produtoVazio = Produto(
      nome: '',
      descricao: '',
      estado: '',
      dataEntrada: '',
      dataSaida: '',
      anotacaoSaida: '',
      valorPago: 0,
      valorAvista: 0,
      valor5Vezes: 0,
      valor10Vezes: 0,
      gastosAdicionais: []);

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

  findProduto(int id) async {
    try {
      final response = await DioRepository.to.findById(id);
      if (response.id != null) {
        produto.value = response;
      } else {
        produto.value = produtoVazio;
      }
    } catch (e) {
      produto.value = produtoVazio;
    }
  }

  findGastos(int id) async {
    try {
      final response = await DioRepository.to.findById(id);
      if (response.id != null) {
        gasto.value = response.gastosAdicionais;
      } else {
        gasto.value = gastoVazio;
      }
    } catch (e) {
      gasto.value = gastoVazio;
    }
  }

  initController() async {
    _produtos = await DioRepository.to.findAllVenda();
  }

  Future<void> cadastraProduto(Produto produto) async {
    final int status = await DioRepository.to.registraProduto(produto);
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
  }

  Future<void> editaProduto(Produto produto) async {
    final int status = await DioRepository.to.editaProduto(produto);
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
  }

  Future<void> setVendido(Produto produto) async {
    final int status = await DioRepository.to.setVendidoProduto(produto);
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
  }

  Future<void> addGasto(int id, GastoAdicional gastoAdicional) async {
    final int status = await DioRepository.to.novoGasto(id, gastoAdicional);
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
  }
}
