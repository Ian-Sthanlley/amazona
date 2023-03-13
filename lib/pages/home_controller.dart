import 'package:amazona/model/produto.dart';
import 'package:amazona/repositories/produtos_repository.dart';

class HomeController {
  ProdutosRepository _produtosRepository = ProdutosRepository();

  List<Produto> get catalogo => _produtosRepository.produtos;

  HomeController() {
    _produtosRepository = ProdutosRepository();
  }
}
