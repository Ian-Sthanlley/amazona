// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import 'package:amazona/controller/produto_controller.dart';
import 'package:amazona/pages/add_gasto_adicional_page.dart';
import 'package:amazona/pages/edit_produto_page.dart';

//ignore: must_be_immutable
class ProdutoPage extends StatefulWidget {
  int id;

  ProdutoPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<ProdutoPage> createState() => _ProdutoPageState();
}

class _ProdutoPageState extends State<ProdutoPage> {
  final controller = Get.put(ProdutoController());
  final _isLoading = false.obs;
  final PageController pageController = PageController();

  gastoAdicional() {
    Get.to(() => AddGastoAdicionalPage(produto: controller.produto.value));
  }

  vendido() {
    ProdutoController.to.setVendido(controller.produto.value);
    Get.back();
  }

  @override
  void initState() {
    pegaGastos();
    iniciaPagina();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  iniciaPagina() async {
    _isLoading.value = true;
    await controller.findProduto(widget.id);
    _isLoading.value = false;
  }

  pegaGastos() async {
    await controller.findGastos(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: [
          infoProduto(),
          addGasto(),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: null,
            onPressed: () {
              Get.to(() => EditaProdutoPage(produto: controller.produto.value));
            },
            child: const Icon(Icons.edit),
          ),
          const Divider(color: Color.fromARGB(0, 255, 255, 255)),
          FloatingActionButton.large(
            heroTag: null,
            onPressed: () {
              vendido();
            },
            child: const Text('Vendido'),
          ),
        ],
      ),
    );
  }

  Widget infoProduto() {
    return CustomScrollView(
      slivers: <Widget>[
        Obx(() {
          if (_isLoading.value == true) {
            return const SliverAppBar(
              title: Text('Aguarde...'),
            );
          } else if (controller.produto.value.id == null) {
            return SliverAppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    pageController.animateToPage(
                      1,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutSine,
                    );
                  },
                  icon: const Icon(Icons.attach_money_rounded),
                )
              ],
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
              actions: [
                IconButton(
                  onPressed: () {
                    pageController.animateToPage(
                      1,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutSine,
                    );
                  },
                  icon: const Icon(Icons.attach_money_rounded),
                ),
              ],
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              produto.nome,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Custo R\$ ${produto.valorPago.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              '5x de R\$ ${((produto.valor5Vezes) / 5).toStringAsFixed(2)}',
                              style: TextStyle(
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
                                          DateTime.parse(produto.dataEntrada)),
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
    );
  }

  Widget addGasto() {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.findGastos(widget.id);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gastos'),
          actions: [
            IconButton(
              onPressed: () {
                gastoAdicional();
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: Obx(() {
          if (controller.gasto.isEmpty) {
            return const Center(
              child: Text('Nenhum gasto registrado!'),
            );
          } else {
            final gastos = controller.gasto;
            return ListView.separated(
              itemCount: controller.gasto.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (BuildContext contexto, int index) {
                return ListTile(
                  /* onTap: () {
                    Get.to(() => EditaGastoPage(gasto: gastos[index]),
                        fullscreenDialog: true);
                  },*/
                  minLeadingWidth: 80,
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('dd/MM/yyyy')
                            .format(DateTime.parse(gastos[index].data)),
                      ),
                    ],
                  ),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(gastos[index].descricao),
                    ],
                  ),
                  trailing: Text('R\$ ${gastos[index].valor}'),
                );
              },
            );
          }
        }),
      ),
    );
  }
}
