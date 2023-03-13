// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:amazona/model/gasto_adicional.dart';

class Produto {
  int codigo;
  String nome;
  String descricao;
  String dataEntrada;
  String valorPago;
  List<GastoAdicional> gastosAdicionais = [];
  Produto({
    required this.codigo,
    required this.nome,
    required this.descricao,
    required this.dataEntrada,
    required this.valorPago,
  });
}
