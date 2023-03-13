import 'dart:collection';
import 'package:amazona/model/gasto_adicional.dart';
import 'package:amazona/model/produto.dart';
import 'package:flutter/material.dart';

class ProdutosRepository extends ChangeNotifier {
  final List<Produto> _produtos = [];

  UnmodifiableListView<Produto> get produtos => UnmodifiableListView(_produtos);

  void addGasto(
      {required Produto produto, required GastoAdicional gastosAdicionais}) {
    produto.gastosAdicionais.add(gastosAdicionais);
    notifyListeners();
  }

  void editaGasto(
      {required GastoAdicional gastoAdicional,
      required String data,
      required String valor,
      required String motivo}) {
    gastoAdicional.dataDoGasto = data;
    gastoAdicional.valorDoGasto = valor;
    gastoAdicional.motivo = motivo;
    notifyListeners();
  }

  ProdutosRepository() {
    _produtos.addAll(
      [
        Produto(
            codigo: 1,
            nome: 'Fogão',
            descricao: 'Novo',
            valorPago: '150.00',
            dataEntrada: '01/01/2020'),
        Produto(
            codigo: 2,
            nome: 'Fogão DAKO',
            descricao: 'Novo',
            valorPago: '150.00',
            dataEntrada: '01/01/2020'),
        Produto(
            codigo: 3,
            nome: 'Geladeira',
            descricao: 'Novo',
            valorPago: '1500.00',
            dataEntrada: '01/01/2020'),
        Produto(
            codigo: 4,
            nome: 'Mesa de canto',
            descricao: 'Novo',
            valorPago: '300.00',
            dataEntrada: '01/01/2020'),
        Produto(
            codigo: 5,
            nome: 'Cadeira',
            descricao: 'Novo',
            valorPago: '750.00',
            dataEntrada: '01/01/2020'),
        Produto(
            codigo: 6,
            nome: 'Freezer',
            descricao: 'Novo',
            valorPago: '600.00',
            dataEntrada: '01/01/2020'),
        Produto(
            codigo: 7,
            nome: 'Freezer',
            descricao: 'Usado',
            valorPago: '400.00',
            dataEntrada: '01/01/2020'),
        Produto(
            codigo: 8,
            nome: 'Fogão',
            descricao: 'Usado',
            valorPago: '50.00',
            dataEntrada: '01/01/2020'),
        Produto(
            codigo: 9,
            nome: 'Fogão DAKO',
            descricao: 'Usado',
            valorPago: '60.00',
            dataEntrada: '01/01/2020'),
        Produto(
            codigo: 10,
            nome: 'Cadeira',
            descricao: 'Usado',
            valorPago: '450.00',
            dataEntrada: '01/01/2020'),
      ],
    );
  }
}
