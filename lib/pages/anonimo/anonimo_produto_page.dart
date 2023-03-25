import 'package:flutter/material.dart';
import 'package:amazona/model/produto.dart';

//ignore: must_be_immutable
class AnonimoProdutoPage extends StatefulWidget {
  Produto produto;
  AnonimoProdutoPage({
    Key? key,
    required this.produto,
  }) : super(key: key);

  @override
  State<AnonimoProdutoPage> createState() => _AnonimoProdutoPageState();
}

class _AnonimoProdutoPageState extends State<AnonimoProdutoPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                icon: Icon(Icons.info_outline),
                text: 'Informações',
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
                    widget.produto.nome,
                    style: const TextStyle(fontSize: 22),
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
                    'Avista: R\$ ${widget.produto.valorAvista.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '5 vezes de R\$ ${(widget.produto.valor5Vezes / 5).toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '10 vezes de R\$ ${(widget.produto.valor10Vezes / 10).toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
