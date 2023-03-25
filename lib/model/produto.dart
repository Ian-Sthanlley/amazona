// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:amazona/model/gasto_adicional.dart';

class Produto {
  int? id;
  String nome;
  String descricao;
  String estado;
  String dataEntrada;
  String? dataSaida;
  String? anotacaoSaida;
  double valorPago;
  double valorAvista;
  double valor5Vezes;
  double valor10Vezes;
  List<GastoAdicional> gastosAdicionais = [];

  Produto({
    this.id,
    required this.nome,
    required this.descricao,
    required this.estado,
    required this.dataEntrada,
    required this.dataSaida,
    required this.anotacaoSaida,
    required this.valorPago,
    required this.valorAvista,
    required this.valor5Vezes,
    required this.valor10Vezes,
    required this.gastosAdicionais,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'estado': estado,
      'dataEntrada': dataEntrada,
      'dataSaida': dataSaida,
      'anotacaoSaida': anotacaoSaida,
      'valorPago': valorPago,
      'valorAvista': valorAvista,
      'valor5Vezes': valor5Vezes,
      'valor10Vezes': valor10Vezes,
      'gastosAdicionais': gastosAdicionais.map((x) => x.toMap()).toList(),
    };
  }

  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      id: map['id'] != null ? map['id'] as int : null,
      nome: map['nome'] as String,
      descricao: map['descricao'] as String,
      estado: map['estado'] as String,
      dataEntrada: map['dataEntrada'] as String,
      dataSaida: map['dataSaida'] != null ? map['dataSaida'] as String : null,
      anotacaoSaida:
          map['anotacaoSaida'] != null ? map['anotacaoSaida'] as String : null,
      valorPago: map['valorPago'] as double,
      valorAvista: map['valorAvista'] as double,
      valor5Vezes: map['valor5Vezes'] as double,
      valor10Vezes: map['valor10Vezes'] as double,
      gastosAdicionais: List<GastoAdicional>.from(
        (map['gastosAdicionais'] as List<dynamic>).map<GastoAdicional>(
          (x) => GastoAdicional.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Produto.fromJson(String source) =>
      Produto.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Produto(id: $id, nome: $nome, descricao: $descricao, estado: $estado, dataEntrada: $dataEntrada, dataSaida: $dataSaida, anotacaoSaida: $anotacaoSaida, valorPago: $valorPago, valorAvista: $valorAvista, valor5Vezes: $valor5Vezes, valor10Vezes: $valor10Vezes, gastosAdicionais: $gastosAdicionais)';
  }
}
