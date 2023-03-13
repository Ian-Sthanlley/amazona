import 'package:amazona/model/gasto_adicional.dart';
import 'package:amazona/repositories/produtos_repository.dart';
import 'package:flutter/material.dart';

import 'package:amazona/model/produto.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

//ignore: must_be_immutable
class AddGastoAdicionalPage extends StatefulWidget {
  Produto produto;

  AddGastoAdicionalPage({
    Key? key,
    required this.produto,
  }) : super(key: key);

  @override
  State<AddGastoAdicionalPage> createState() => _AddGastoAdicionalPageState();
}

class _AddGastoAdicionalPageState extends State<AddGastoAdicionalPage> {
  final _dataDoGasto = TextEditingController();
  final _valorDoGasto = TextEditingController();
  final _motivo = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  save() {
    Provider.of<ProdutosRepository>(context, listen: false).addGasto(
      produto: widget.produto,
      gastosAdicionais: GastoAdicional(
          dataDoGasto: _dataDoGasto.text,
          valorDoGasto: _valorDoGasto.text,
          motivo: _motivo.text),
    );
    Get.back();
    Get.snackbar(
      'Salvo!',
      'Gasto adicionado.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.greenAccent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar gasto'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 48, right: 24, left: 24, bottom: 12),
              child: TextFormField(
                controller: _dataDoGasto,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Dia',
                ),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Informe a data do gasto';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              child: TextFormField(
                controller: _valorDoGasto,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Valor',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Informe o valor do gasto';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              child: TextFormField(
                controller: _motivo,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Descrição',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Informe uma descrição do gasto';
                  }
                  return null;
                },
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.all(24),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      save();
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Salvar',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
