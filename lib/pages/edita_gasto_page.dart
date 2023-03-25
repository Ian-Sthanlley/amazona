import 'package:amazona/controller/produto_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amazona/model/gasto_adicional.dart';

//ignore: must_be_immutable
class EditaGastoPage extends StatefulWidget {
  GastoAdicional gasto;
  EditaGastoPage({
    Key? key,
    required this.gasto,
  }) : super(key: key);

  @override
  State<EditaGastoPage> createState() => _EditaGastoPageState();
}

class _EditaGastoPageState extends State<EditaGastoPage> {
  final _data = TextEditingController();
  final _valor = TextEditingController();
  final _descricao = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _data.text = widget.gasto.data;
    _valor.text = widget.gasto.valor.toString();
    _descricao.text = widget.gasto.descricao;
  }

  editar() {
    ProdutoController.to.editaGasto(
      gastoAdicional: widget.gasto,
      data: _data.text,
      valor: _valor.text as double,
      motivo: _descricao.text,
    );
    Get.back();
    Get.snackbar(
      'Salvo!',
      'Gasto editado.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.greenAccent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Gasto'),
        actions: [
          IconButton(
            onPressed: editar,
            icon: const Icon(Icons.check),
          ),
        ],
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
                controller: _data,
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
                controller: _valor,
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
                controller: _descricao,
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
          ],
        ),
      ),
    );
  }
}
