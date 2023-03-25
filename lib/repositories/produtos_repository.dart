import 'dart:convert';

import 'package:amazona/model/gasto_adicional.dart';
import 'package:amazona/model/produto.dart';
import 'package:amazona/repositories/i_repository.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProdutosRepository implements IRepository {
  static ProdutosRepository get to => Get.find<ProdutosRepository>();
  final String rede = 'http://192.168.100.2:8080';

  @override
  Future<List<Produto>> findAllProdutos() async {
    var url = Uri.parse('$rede/produto');
    final response = await http.get(url);
    final List<dynamic> responseMap =
        jsonDecode(utf8.decode(response.bodyBytes));

    final lista = responseMap
        .map<Produto>((resposta) => Produto.fromMap(resposta))
        .toList();
    lista.sort((Produto produtoA, Produto produtoB) =>
        produtoB.id!.compareTo(produtoA.id as num));
    return lista;
  }

  @override
  Future<List<Produto>> findAllVenda() async {
    var url = Uri.parse('$rede/produto/venda');
    final response = await http.get(url);
    final List<dynamic> responseMap =
        jsonDecode(utf8.decode(response.bodyBytes));

    final lista = responseMap
        .map<Produto>((resposta) => Produto.fromMap(resposta))
        .toList();
    lista.sort((Produto produtoA, Produto produtoB) =>
        produtoB.id!.compareTo(produtoA.id as num));
    return lista;
  }

  @override
  Future<int> registraProduto(Produto produto) async {
    var url = Uri.parse('$rede/produto');
    String body = jsonEncode(produto.toMap());
    Map<String, String> header = {
      'Content-Type': 'application/json; charset=UTF-8'
    };
    final response = await http.post(url, headers: header, body: body);
    return response.statusCode;
  }

  @override
  Future<int> editaProduto(Produto produto) async {
    var url = Uri.parse('$rede/produto/${produto.id}');
    String body = jsonEncode(produto.toMap());
    Map<String, String> header = {
      'Content-Type': 'application/json; charset=UTF-8'
    };
    final response = await http.put(url, headers: header, body: body);
    return response.statusCode;
  }

  @override
  Future<int> addGasto(int id, GastoAdicional gastoAdicional) async {
    var url = Uri.parse('$rede/produto/$id');
    String body = jsonEncode(gastoAdicional.toMap());
    Map<String, String> header = {
      'Content-Type': 'application/json; charset=UTF-8'
    };
    final response = await http.post(url, headers: header, body: body);
    return response.statusCode;
  }

  @override
  Future<int> setVendido(int id, Produto produto) async {
    var url = Uri.parse('$rede/produto/${produto.id}/vendido');
    String body = jsonEncode(produto.toMap());
    Map<String, String> header = {
      'Content-Type': 'application/json; charset=UTF-8'
    };
    final response = await http.put(url, headers: header, body: body);
    return response.statusCode;
  }
}
