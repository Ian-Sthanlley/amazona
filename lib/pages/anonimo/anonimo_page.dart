// ignore_for_file: public_member_api_docs, sort_constructors_first, depend_on_referenced_packages
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:amazona/controller/getx_produto_controller.dart';
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

  void _changeEmoji() {
    setState(() {
      _currentEmojiIndex = Random().nextInt(_emojis.length);
    });
  }

  encheList() async {
    _isLoading.value = true;
    await controller.initController();
    _isLoading.value = false;
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
            encheList();
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
                  if (_isLoading.value == true) {
                    return const SliverPadding(
                      padding: EdgeInsets.all(0),
                    );
                  } else if (_isSearching.value == true) {
                    if (controller.filteredProdutos.isNotEmpty) {
                      final filtrada = controller.filteredProdutos;
                      return SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return ListTile(
                            title: Text(filtrada[index].nome),
                            subtitle: Text(
                              DateFormat('dd/MM/yyyy').format(
                                  DateTime.parse(filtrada[index].dataEntrada)),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    'Valor Avista: ${filtrada[index].valorAvista}'),
                                Text('Estado: ${filtrada[index].estado}'),
                              ],
                            ),
                            onTap: () {
                              Get.to(
                                () =>
                                    AnonimoProdutoPage(id: filtrada[index].id!),
                              );
                            },
                          );
                        }, childCount: filtrada.length),
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
                    final lista = controller.produtos;
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
                              title: Text(lista[index].nome),
                              subtitle: Text(lista[index].estado),
                              trailing: SizedBox(
                                width: 120,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                        'Avista R\$ ${lista[index].valorAvista.toStringAsFixed(2)}'),
                                  ],
                                ),
                              ),
                              onTap: () {
                                Get.to(() =>
                                    AnonimoProdutoPage(id: lista[index].id!));
                              },
                            ),
                          );
                        },
                        childCount: lista.length,
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
            return FloatingActionButton.large(
              onPressed: _changeEmoji,
              child: Text(
                _emojis[_currentEmojiIndex],
                style: const TextStyle(fontSize: 24),
              ),
            );
          }
        }),
      ),
    );
  }
}
