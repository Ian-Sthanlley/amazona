import 'package:amazona/pages/add_gasto_adicional_page.dart';
import 'package:amazona/pages/edita_gasto_page.dart';
import 'package:amazona/repositories/produtos_repository.dart';
import 'package:flutter/material.dart';
import 'package:amazona/model/produto.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

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
                    'Valor pago: ${widget.produto.valorPago}',
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
              ],
            ),
            addGasto()
          ],
        ),
      ),
    );
  }

  Widget addGasto() {
    final produto = Provider.of<ProdutosRepository>(context)
        .produtos
        .firstWhere((p) => p.codigo == widget.produto.codigo);
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
                onTap: () {
                  Get.to(EditaGastoPage(gasto: produto.gastosAdicionais[index]),
                      fullscreenDialog: true);
                },
                minLeadingWidth: 80,
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(produto.gastosAdicionais[index].dataDoGasto),
                  ],
                ),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(produto.gastosAdicionais[index].motivo),
                  ],
                ),
                trailing:
                    Text('R\$ ${produto.gastosAdicionais[index].valorDoGasto}'),
              );
            },
          );
  }
}
