// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:amazona/controller/produto_controller.dart';
import 'package:amazona/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:amazona/model/produto.dart';
import 'package:get/get.dart';

final List<String> _estado = <String>['NOVO', 'USADO'];

//ignore: must_be_immutable
class EditaProdutoPage extends StatefulWidget {
  Produto produto;
  EditaProdutoPage({
    Key? key,
    required this.produto,
  }) : super(key: key);

  @override
  State<EditaProdutoPage> createState() => _EditaProdutoPageState();
}

class _EditaProdutoPageState extends State<EditaProdutoPage> {
  final _nome = TextEditingController();
  final _valorPago = TextEditingController();
  final _valorAvista = TextEditingController();
  final _descricao = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String dropDownValue = _estado.first;
  @override
  void initState() {
    _nome.text = widget.produto.nome;
    _valorPago.text = widget.produto.valorPago.toString();
    _valorAvista.text = widget.produto.valorAvista.toString();
    _descricao.text = widget.produto.descricao;
    dropDownValue = widget.produto.estado.toUpperCase();
    super.initState();
  }

  save() {
    ProdutoController.to.editaProduto(
      Produto(
        id: widget.produto.id,
        nome: _nome.text,
        descricao: _descricao.text,
        estado: dropDownValue.toUpperCase(),
        dataEntrada: widget.produto.dataEntrada,
        dataSaida: widget.produto.dataSaida,
        anotacaoSaida: widget.produto.anotacaoSaida,
        valorPago: double.parse(_valorPago.text),
        valorAvista: double.parse(_valorAvista.text),
        valor5Vezes: 0,
        valor10Vezes: 0,
        gastosAdicionais: [],
      ),
    );

    Get.offAll(() => const HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.produto.nome),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Center(
          heightFactor: 1.4,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromARGB(100, 0, 0, 0),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            width: 400,
            height: 550,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 24,
                          bottom: 12,
                          left: 24,
                          right: 24,
                        ),
                        child: TextFormField(
                          controller: _nome,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Nome',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Informe o nome';
                            }
                            return null;
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 12, bottom: 12, left: 24, right: 12),
                              child: TextFormField(
                                controller: _valorPago,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Valor pago',
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Informe o valor gasto';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 12, bottom: 12, right: 24, left: 12),
                              child: TextFormField(
                                controller: _valorAvista,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Valor avista',
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Informe o valor avista';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 12, bottom: 12, left: 24, right: 24),
                              child: TextFormField(
                                enabled: false,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Código',
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 12, bottom: 12, right: 24, left: 0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color.fromARGB(108, 0, 0, 0),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                height: 55,
                                alignment: Alignment.center,
                                child: DropdownButton<String>(
                                  borderRadius: BorderRadius.circular(3),
                                  style: const TextStyle(
                                    fontSize: 15.5,
                                    color: Color.fromARGB(160, 0, 0, 0),
                                  ),
                                  iconSize: 16,
                                  underline: Container(
                                    color: null,
                                  ),
                                  value: dropDownValue,
                                  onChanged: (String? value) {
                                    setState(() {
                                      dropDownValue = value!;
                                    });
                                  },
                                  items: _estado.map<DropdownMenuItem<String>>(
                                    (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        child: TextFormField(
                          controller: _descricao,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Descrição',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Informe uma descrição';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
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
          ),
        ),
      ),
    );
  }
}
