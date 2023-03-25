import 'dart:async';

import 'package:amazona/controller/getx_produto_controller.dart';
import 'package:amazona/pages/add_produto_page.dart';
import 'package:amazona/pages/produto_page.dart';
import 'package:amazona/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Get.put(GetxProdutoController());
  final _isSearching = false.obs;
  final _pesquisa = TextEditingController();

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    controller.initController();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      controller.initController();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            await controller.initController();
          },
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                floating: true,
                snap: true,
                centerTitle: true,
                title: Image.asset(
                  'assets/images/amazonas.png',
                  width: 78,
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () => AuthService.to.logout(),
                  ),
                ],
                bottom: AppBar(
                  elevation: 0,
                  title: Container(
                    width: double.infinity,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: const Color.fromARGB(255, 1, 0, 76),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            textAlignVertical: TextAlignVertical.center,
                            controller: _pesquisa,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                _isSearching.value = true;
                                controller.searchQuery.value = value;
                                controller.updateFilteredItems();
                              } else {
                                _isSearching.value = false;
                              }
                            },
                            textCapitalization: TextCapitalization.sentences,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(bottom: 8),
                              border: InputBorder.none,
                              hintText: 'Pesquisa...',
                              prefixIcon: Icon(
                                Icons.search,
                              ),
                            ),
                          ),
                        ),
                        Obx(() => _isSearching.value
                            ? SizedBox(
                                width: 40,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.highlight_remove_rounded,
                                    color: Colors.blueGrey,
                                  ),
                                  onPressed: () {
                                    controller.searchQuery.value = '';
                                    _isSearching.value = false;
                                    _pesquisa.text = '';
                                  },
                                ),
                              )
                            : Container()),
                      ],
                    ),
                  ),
                ),
              ),
              Obx(
                () {
                  if (_isSearching.value == true) {
                    if (controller.filteredProdutos.isNotEmpty) {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return ListTile(
                            title:
                                Text(controller.filteredProdutos[index].nome),
                            subtitle: Text(
                                controller.filteredProdutos[index].dataEntrada),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    'Valor Avista: ${controller.filteredProdutos[index].valorAvista}'),
                                Text(
                                    'Estado: ${controller.filteredProdutos[index].estado}'),
                              ],
                            ),
                            onTap: () {
                              Get.to(
                                () => ProdutoPage(
                                  key: Key(
                                      controller.filteredProdutos[index].nome),
                                  produto: controller.filteredProdutos[index],
                                ),
                              );
                            },
                          );
                        }, childCount: controller.filteredProdutos.length),
                      );
                    } else {
                      return const SliverFillRemaining(
                        child: Center(
                          child: Text('Nada encontrado!'),
                        ),
                      );
                    }
                  } else if (controller.produtos.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Center(
                        heightFactor: 5,
                        child: Column(
                          children: [
                            const Text(
                                'Não foi possível carregar a lista de produtos!'),
                            IconButton(
                                onPressed: () {
                                  controller.initController();
                                },
                                icon: const Icon(Icons.refresh)),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return ListTile(
                            title: Text(controller.produtos[index].nome),
                            subtitle: Text(controller.produtos[index].estado),
                            trailing: SizedBox(
                              width: 120,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Avista R\$ ${controller.produtos[index].valorAvista.toStringAsFixed(2)}'),
                                ],
                              ),
                            ),
                            onTap: () {
                              Get.to(
                                () => ProdutoPage(
                                  key: Key(controller.produtos[index].nome),
                                  produto: controller.produtos[index],
                                ),
                              );
                            },
                          );
                        },
                        childCount: controller.produtos.length,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: null,
              onPressed: () {},
              child: const Icon(Icons.search),
            ),
            const Divider(color: Color.fromARGB(0, 255, 255, 255)),
            FloatingActionButton.large(
              heroTag: null,
              onPressed: () {
                Get.to(() => const AddProdutoPage());
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}



/*  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Amazona'),
        actions: [
          IconButton(
            onPressed: () => AuthService.to.logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Consumer<ProdutoController>(
        builder: (context, controller, child) {
          return RefreshIndicator(
            child: ListView.separated(
              itemCount: controller.produtos.length,
              itemBuilder: (BuildContext contexto, int produto) {
                final catalogo = controller.produtos;
                return ListTile(
                  title: Text(catalogo[produto].nome),
                  subtitle: Text(catalogo[produto].dataEntrada),
                  trailing: Column(
                    children: [
                      Text('Valor pago: ${catalogo[produto].valorPago}'),
                      Text('Estado: ${catalogo[produto].estado}'),
                    ],
                  ),
                  onTap: () {
                    Get.to(
                      () => ProdutoPage(
                        produto: catalogo[produto],
                      ),
                    );
                  },
                );
              },
              separatorBuilder: (_, __) => const Divider(),
              padding: const EdgeInsets.all(16),
            ),
            onRefresh: () => controller.initController(),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: null,
            onPressed: () {},
            child: const Icon(Icons.search),
          ),
          const Divider(color: Color.fromARGB(0, 255, 255, 255)),
          FloatingActionButton.large(
            heroTag: null,
            onPressed: () {
              Get.to(() => const AddProdutoPage());
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }*/