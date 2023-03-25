import 'package:amazona/controller/produto_controller.dart';
import 'package:amazona/model/produto.dart';
import 'package:amazona/pages/home_page.dart';
import 'package:amazona/pages/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

final List<String> _estado = <String>['Selecione', 'NOVO', 'USADO'];

class AddProdutoPage extends StatefulWidget {
  const AddProdutoPage({super.key});

  @override
  State<AddProdutoPage> createState() => _AddProdutoPageState();
}

class _AddProdutoPageState extends State<AddProdutoPage> {
  final _nome = TextEditingController();
  final _valorPago = TextEditingController();
  final _valorAvista = TextEditingController();
  final _descricao = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String dropDownValue = _estado.first;

  save() {
    ProdutoController.to.cadastraProduto(
      Produto(
        nome: _nome.text,
        descricao: _descricao.text,
        estado: dropDownValue.toUpperCase(),
        dataEntrada: '',
        dataSaida: '',
        anotacaoSaida: '',
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
        title: const Text('Novo produto'),
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
                  caixaText(
                    caixaForm(
                      'Nome',
                      _nome,
                      TextInputType.name,
                    ),
                    0,
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: caixaText(
                              caixaForm(
                                'Valor pago',
                                _valorPago,
                                TextInputType.number,
                              ),
                              0,
                            ),
                          ),
                          Expanded(
                            child: caixaText(
                              caixaForm(
                                'Valor avista',
                                _valorAvista,
                                TextInputType.number,
                              ),
                              0,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: boxDeco(),
                        margin: marginDeco(),
                        height: 165,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                padingDeco(),
                                Expanded(
                                  child: TextFormField(
                                    controller: _descricao,
                                    style: const TextStyle(color: textColor),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Descrição',
                                      hintStyle: TextStyle(color: textColor),
                                    ),
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 7,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter
                                          .singleLineFormatter
                                    ],
                                  ),
                                ),
                                padingDeco(),
                              ],
                            ),
                          ],
                        ),
                      ),
                      caixaText(
                        DropdownButton<String>(
                          borderRadius: BorderRadius.circular(3),
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
                        150,
                      )
                    ],
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      margin: const EdgeInsets.all(24),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            FocusScopeNode focus = FocusScope.of(context);
                            if (!focus.hasPrimaryFocus) {
                              focus.unfocus();
                              await Future.delayed(
                                const Duration(milliseconds: 200),
                              );
                            }
                            if (_nome.text.isNotEmpty &&
                                _valorPago.text.isNotEmpty &&
                                _valorAvista.text.isNotEmpty &&
                                /*_codigo.text.isNotEmpty &&*/
                                _descricao.text.isNotEmpty &&
                                dropDownValue != 'Selecione') {
                              save();
                            } else {
                              Get.snackbar(
                                'Opa..',
                                'Falta algum campo para preecher.',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor:
                                    const Color.fromARGB(132, 255, 82, 82),
                              );
                            }
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
