// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:amazona/controller/getx_produto_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amazona/pages/anonimo/anonimo_produto_page.dart';
import 'package:amazona/services/auth_service.dart';

var isAppBarTall = false.obs;

class AnonimoPage extends StatefulWidget {
  const AnonimoPage({super.key});

  @override
  State<AnonimoPage> createState() => _AnonimoPageState();
}

class _AnonimoPageState extends State<AnonimoPage> {
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
                            autofocus: false,
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
                                () => AnonimoProdutoPage(
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
                                () => AnonimoProdutoPage(
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
      ),
    );
  }
}
