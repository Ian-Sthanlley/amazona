// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class GastoAdicional {
  int? id;
  String data;
  double valor;
  String descricao;
  GastoAdicional({
    this.id,
    required this.data,
    required this.valor,
    required this.descricao,
  });
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'data': data,
      'valor': valor,
      'descricao': descricao,
    };
  }

  factory GastoAdicional.fromMap(Map<String, dynamic> map) {
    return GastoAdicional(
      id: map['id'] != null ? map['id'] as int : null,
      data: map['data'] as String,
      valor: map['valor'] as double,
      descricao: map['descricao'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory GastoAdicional.fromJson(String source) =>
      GastoAdicional.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GastoAdicional(id: $id, data: $data, valor: $valor, descricao: $descricao)';
  }
}
