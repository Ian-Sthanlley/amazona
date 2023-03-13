import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:amazona/model/gasto_adicional.dart';
import 'package:amazona/repositories/produtos_repository.dart';

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
  final _dataDoGasto = TextEditingController();
  final _valorDoGasto = TextEditingController();
  final _motivo = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _dataDoGasto.text = widget.gasto.dataDoGasto;
    _valorDoGasto.text = widget.gasto.valorDoGasto;
    _motivo.text = widget.gasto.motivo;
  }

  editar() {
    Provider.of<ProdutosRepository>(context, listen: false).editaGasto(
      gastoAdicional: widget.gasto,
      data: _dataDoGasto.text,
      valor: _valorDoGasto.text,
      motivo: _motivo.text,
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
          ],
        ),
      ),
    );
  }
}
