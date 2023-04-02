import 'dart:async';
import 'dart:math';

import 'package:amazona/controller/getx_produto_controller.dart';
import 'package:amazona/pages/add_produto_page.dart';
import 'package:amazona/pages/produto_page.dart';
import 'package:amazona/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Get.put(GetxProdutoController());
  final _isSearching = false.obs;
  final _pesquisa = TextEditingController();

  final _isLoading = false.obs;

  int _currentEmojiIndex = 0;
  final List<String> _emojis = [
    '😀',
    '😎',
    '😍',
    '🤔',
    '🤩',
    '❤',
    '😁',
    '🎉',
    '🙌',
    '✨',
    '😆',
    '🥰',
    '🤑',
    '😇',
    '🤡',
  ];

  Timer? _timer;

  @override
  void initState() {
    _changeEmoji();
    encheList();
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 45), (_) {
      encheList();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  encheList() async {
    _isLoading.value = true;
    await controller.initController();
    _isLoading.value = false;
  }

  void _changeEmoji() {
    setState(() {
      _currentEmojiIndex = Random().nextInt(_emojis.length);
    });
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
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/amazonas.png',
                      width: 110,
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                ),
              ),
              ListTile(
                leading: Icon(Icons.moving_outlined),
                title: Text('Vendas'),
                onTap: () {},
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                color: Colors.blueGrey,
                height: 1,
              ),
              SizedBox(
                height: 8,
              ),
              ListTile(
                leading: Icon(Icons.moving_outlined),
                title: Text('Relatótio 2'),
                onTap: () {},
              ),
            ],
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await encheList();
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
                  automaticallyImplyLeading: false,
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
                  if (_isLoading.value == true) {
                    return const SliverPadding(
                      padding: EdgeInsets.all(0),
                    );
                  } else if (_isSearching.value == true) {
                    if (controller.filteredProdutos.isNotEmpty) {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return ListTile(
                            title:
                                Text(controller.filteredProdutos[index].nome),
                            subtitle: Text(
                              DateFormat('dd/MM/yyyy').format(DateTime.parse(
                                  controller
                                      .filteredProdutos[index].dataEntrada)),
                            ),
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
                                  id: controller.filteredProdutos[index].id!,
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
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 2),
                            child: ListTile(
                              tileColor:
                                  const Color.fromARGB(255, 240, 241, 243),
                              leading: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey[50],
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(3.0),
                                ),
                                child: Opacity(
                                  opacity: 0.5,
                                  child: Image.asset(
                                    'assets/images/semImagem.png',
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ),
                              title: Text(controller.produtos[index].nome),
                              subtitle: Text(controller.produtos[index].estado),
                              trailing: SizedBox(
                                width: 120,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                        'Avista R\$ ${controller.produtos[index].valorAvista.toStringAsFixed(2)}'),
                                  ],
                                ),
                              ),
                              onTap: () {
                                Get.to(
                                  () => ProdutoPage(
                                    id: controller.produtos[index].id!,
                                  ),
                                );
                              },
                            ),
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
        floatingActionButton: Obx(() {
          if (_isLoading.value == true) {
            return FloatingActionButton(
              onPressed: () {},
              child: const CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: _changeEmoji,
                  child: Text(
                    _emojis[_currentEmojiIndex],
                    style: const TextStyle(fontSize: 24),
                  ),
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
            );
          }
        }),
      ),
    );
  }
}
