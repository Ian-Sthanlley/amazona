import 'dart:convert';
import 'dart:io';

import 'package:amazona/model/gasto_adicional.dart';
import 'package:amazona/model/produto.dart';
import 'package:amazona/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioRepository {
  static DioRepository get to => Get.find<DioRepository>();

  final dio = Dio()..options.baseUrl = ''; //SUA API AQUI

  //..interceptors.add(LogInterceptor());

  void initAdapter() {
    (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  salvaToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  Future<String> pegaToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token')!;
  }

  apagaToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }

  void login() async {
    var password = AuthService.to.user!.uid;
    var user = json.encode({"username": "Amazonas", "password": "$password"});
    try {
      initAdapter();
      final response = await dio.post(
        '/usuario/login',
        data: user,
        options: Options(
          contentType: 'application/json; charset=UTF-8',
        ),
      );
      salvaToken(response.data);
    } catch (e) {
      print(e);
    }
  }

  Future<List<Produto>> findAllVenda() async {
    try {
      initAdapter();
      final response = await dio.get('/produto/venda');
      final List<dynamic> responseMap = response.data;

      final lista = responseMap
          .map<Produto>((resposta) => Produto.fromMap(resposta))
          .toList();
      lista.sort((Produto produtoA, Produto produtoB) =>
          produtoB.id!.compareTo(produtoA.id as num));
      return lista;
    } catch (e) {
      print(e);
      throw Exception('Erro ao buscar produtos');
    }
  }

  Future<int> registraProduto(Produto produto) async {
    try {
      String token = await pegaToken();
      Map<String, String> header = {'Authorization': 'Bearer $token'};
      final response = await dio.post(
        '/produto',
        data: produto.toJson(),
        options: Options(
          contentType: 'application/json; charset=UTF-8',
          headers: header,
        ),
      );
      return response.statusCode!;
    } catch (e) {
      return 0;
    }
  }

  Future<Produto> findById(int id) async {
    try {
      initAdapter();
      final response = await dio.get('/produto/$id');
      final Produto produto = Produto.fromMap(response.data);
      return produto;
    } catch (e) {
      throw Exception('Erro ao buscar produto');
    }
  }

  Future<int> editaProduto(Produto produto) async {
    try {
      String token = await pegaToken();
      Map<String, String> header = {'Authorization': 'Bearer $token'};
      final response = await dio.put(
        '/produto/${produto.id}',
        data: produto.toJson(),
        options: Options(
          contentType: 'application/json; charset=UTF-8',
          headers: header,
        ),
      );
      return response.statusCode!;
    } catch (e) {
      return 0;
    }
  }

  Future<int> setVendidoProduto(Produto produto) async {
    try {
      String token = await pegaToken();
      Map<String, String> header = {'Authorization': 'Bearer $token'};
      final response = await dio.put(
        '/produto/${produto.id}/vendido',
        data: produto.toJson(),
        options: Options(
          contentType: 'application/json; charset=UTF-8',
          headers: header,
        ),
      );
      return response.statusCode!;
    } catch (e) {
      return 0;
    }
  }

  Future<int> novoGasto(int id, GastoAdicional gastoAdicional) async {
    try {
      String token = await pegaToken();
      Map<String, String> header = {'Authorization': 'Bearer $token'};
      final response = await dio.post(
        '/produto/$id',
        data: gastoAdicional.toJson(),
        options: Options(
          contentType: 'application/json; charset=UTF-8',
          headers: header,
        ),
      );
      return response.statusCode!;
    } catch (e) {
      return 0;
    }
  }
}
