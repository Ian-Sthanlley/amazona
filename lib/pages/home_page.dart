import 'package:amazona/pages/produto_page.dart';
import 'package:amazona/repositories/produtos_repository.dart';
import 'package:amazona/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
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
      body: Consumer<ProdutosRepository>(
        builder: (context, repositorio, child) {
          return ListView.separated(
            itemCount: repositorio.produtos.length,
            itemBuilder: (BuildContext contexto, int produto) {
              final catalogo = repositorio.produtos;
              return ListTile(
                title: Text(catalogo[produto].nome),
                subtitle: Text(catalogo[produto].dataEntrada),
                trailing: Column(
                  children: [
                    Text('Valor pago: ${catalogo[produto].valorPago}'),
                    const Text('Valor de venda avista: '),
                  ],
                ),
                onTap: () {
                  Get.to(
                    () => ProdutoPage(
                      key: Key(catalogo[produto].nome),
                      produto: catalogo[produto],
                    ),
                  );
                },
              );
            },
            separatorBuilder: (_, __) => const Divider(),
            padding: const EdgeInsets.all(16),
          );
        },
      ),
    );
  }
}
