import 'package:amazona/controller/produto_controller.dart';
import 'package:amazona/pages/add_gasto_adicional_page.dart';
import 'package:amazona/pages/edit_produto_page.dart';
import 'package:flutter/material.dart';
import 'package:amazona/model/produto.dart';
import 'package:get/get.dart';

//ignore: must_be_immutable
class ProdutoPage extends StatefulWidget {
  Produto produto;
  ProdutoPage({Key? key, required this.produto}) : super(key: key);

  @override
  State<ProdutoPage> createState() => _ProdutoPageState();
}

class _ProdutoPageState extends State<ProdutoPage> {
  gastoAdicional() {
    Get.to(() => AddGastoAdicionalPage(produto: widget.produto));
  }

  vendido() {
    ProdutoController.to.setVendido(widget.produto);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.produto.nome),
          actions: [
            IconButton(
              onPressed: gastoAdicional,
              icon: const Icon(Icons.add),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                icon: Icon(Icons.info_outline),
                text: 'Informações',
              ),
              Tab(
                icon: Icon(Icons.attach_money_sharp),
                text: 'Gastos',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Nome: ${widget.produto.nome}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Descrição: ${widget.produto.descricao}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Data de entrada: ${widget.produto.dataEntrada}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Valor pago: ${widget.produto.valorPago}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Avista ${widget.produto.valorAvista}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '5 vezes de ${widget.produto.valor5Vezes / 5} ',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '10 vezes de ${widget.produto.valor10Vezes / 10}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
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
                Get.to(() => EditaProdutoPage(produto: widget.produto));
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
      ),
    );
  }

  Widget addGasto() {
    final produto = widget.produto;
    final quantidade = produto.gastosAdicionais.length;

    return quantidade == 0
        ? const Center(
            child: Text('Nenhum gasto registrado!'),
          )
        : ListView.separated(
            itemCount: quantidade,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (BuildContext contexto, int index) {
              return ListTile(
                /*onTap: () {
                  Get.to(
                      () => EditaGastoPage(
                          gasto: produto.gastosAdicionais[index]),
                      fullscreenDialog: true);
                },*/
                minLeadingWidth: 80,
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(produto.gastosAdicionais[index].data),
                  ],
                ),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(produto.gastosAdicionais[index].descricao),
                  ],
                ),
                trailing: Text('R\$ ${produto.gastosAdicionais[index].valor}'),
              );
            },
          );
  }
}
