// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:amazona/controller/produto_controller.dart';

//ignore: must_be_immutable
class AnonimoProdutoPage extends StatefulWidget {
  int id;
  AnonimoProdutoPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<AnonimoProdutoPage> createState() => _AnonimoProdutoPageState();
}

class _AnonimoProdutoPageState extends State<AnonimoProdutoPage> {
  final controller = Get.put(ProdutoController());
  final _isLoading = false.obs;

  @override
  void initState() {
    iniciaPagina();
    super.initState();
  }

  iniciaPagina() async {
    _isLoading.value = true;
    await controller.findProduto(widget.id);
    _isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          Obx(() {
            if (_isLoading.value == true) {
              return const SliverAppBar(
                title: Text('Aguarde...'),
              );
            } else if (controller.produto.value.id == null) {
              return SliverAppBar(
                expandedHeight: 300.0,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  background: Opacity(
                    opacity: 0.5,
                    child: Image.asset(
                      'assets/images/semImagem.png',
                    ),
                  ),
                ),
              );
            } else {
              return SliverAppBar(
                expandedHeight: 300.0,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  background: Opacity(
                    opacity: 0.5,
                    child: Image.asset(
                      'assets/images/semImagem.png',
                    ),
                  ),
                ),
              );
            }
          }),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Obx(() {
                  if (_isLoading.value == true) {
                    return Container();
                  } else if (controller.produto.value.id == null) {
                    return const Center(
                      child: Text('Falha ao carregar infomações.'),
                    );
                  } else {
                    final produto = controller.produto.value;
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            produto.nome,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                '5x de R\$ ${((produto.valor5Vezes) / 5).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 0, 137, 205),
                                ),
                              ),
                              Text(
                                '10x de R\$ ${((produto.valor10Vezes) / 10).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 0, 137, 205),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'R\$ ${produto.valorAvista.toStringAsFixed(2)} Avista',
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Descrição',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Produto ${produto.estado}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        DateFormat('dd/MM/yyyy').format(
                                            DateTime.parse(
                                                produto.dataEntrada)),
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    produto.descricao,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Obx(() {
        if (_isLoading.value) {
          return FloatingActionButton(
            onPressed: () {
              iniciaPagina();
            },
            child: const CircularProgressIndicator(color: Colors.white),
          );
        } else {
          return FloatingActionButton.small(
            onPressed: () {},
            child: const Text('♥'),
          );
        }
      }),
    );
  }
}
