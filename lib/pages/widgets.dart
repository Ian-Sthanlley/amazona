import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Color primaryColor = Color.fromARGB(255, 86, 117, 255);
const Color secondColor = Color.fromARGB(255, 255, 255, 255);
const Color details = Color.fromARGB(186, 155, 155, 155);
const Color textColor = Color.fromARGB(255, 70, 70, 70);

boxDeco() {
  return BoxDecoration(
    color: secondColor,
    border: Border.all(
      color: details,
      width: 2.0,
    ),
    borderRadius: BorderRadius.circular(7.0),
  );
}

padingDeco() {
  return const Padding(
    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
  );
}

marginDeco() {
  return const EdgeInsets.symmetric(
    vertical: 10.0,
    horizontal: 20.0,
  );
}

caixaText(Widget meio, double largura) {
  if (largura == 0) {
    largura = double.infinity;
  }
  return Container(
    decoration: boxDeco(),
    margin: marginDeco(),
    width: largura,
    child: Column(
      children: [
        Row(
          children: [
            padingDeco(),
            Expanded(
              child: meio,
            ),
            padingDeco(),
          ],
        ),
      ],
    ),
  );
}

caixaForm(String nome, TextEditingController controller, TextInputType tipo) {
  return TextFormField(
    controller: controller,
    style: const TextStyle(color: textColor),
    decoration: InputDecoration(
      border: InputBorder.none,
      hintText: nome,
      hintStyle: const TextStyle(color: textColor),
    ),
    keyboardType: tipo,
    inputFormatters: <TextInputFormatter>[
      FilteringTextInputFormatter.singleLineFormatter
    ],
  );
}
