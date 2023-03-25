import 'package:amazona/model/gasto_adicional.dart';
import 'package:amazona/model/produto.dart';

abstract class IRepository {
  Future<List<Produto>> findAllProdutos();
  Future<List<Produto>> findAllVenda();
  Future<int> registraProduto(Produto produto);
  Future<int> editaProduto(Produto produto);
  Future<int> addGasto(int id, GastoAdicional gastoAdicional);
  Future<int> setVendido(int id, Produto produto);
}
