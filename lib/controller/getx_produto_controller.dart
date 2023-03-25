import 'package:amazona/model/produto.dart';
import 'package:amazona/repositories/produtos_repository.dart';
import 'package:get/get.dart';

class GetxProdutoController extends GetxController {
  RxList<Produto> produtos = RxList<Produto>([]);
  RxList<Produto> filteredProdutos = RxList<Produto>([]);
  RxString searchQuery = ''.obs;

  Future<void> initController() async {
    try {
      final response = await ProdutosRepository.to.findAllVenda();
      if (response.isNotEmpty) {
        produtos.value = response;
      } else {
        produtos.value = [];
      }
    } catch (e) {
      produtos.value = [];
    }
  }

  void updateFilteredItems() {
    if (searchQuery.value.isNotEmpty) {
      filteredProdutos.assignAll(
        produtos.where(
          (produto) {
            return produto.nome
                    .toLowerCase()
                    .contains(searchQuery.value.toLowerCase()) ||
                produto.descricao
                    .toLowerCase()
                    .contains(searchQuery.value.toLowerCase());
          },
        ),
      );
    }
  }
}
