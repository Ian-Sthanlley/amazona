import 'package:amazona/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: use_key_in_widget_constructors
class PageInicial extends StatefulWidget {
  @override
  State<PageInicial> createState() => _PageInicialState();
}

class _PageInicialState extends State<PageInicial> {
  final PageController pageController = PageController();

  final _email = TextEditingController();
  final _senha = TextEditingController();
  final _formKeyLogin = GlobalKey<FormState>();
  var isLoading = false.obs;

  login() async {
    isLoading.value = true;
    await AuthService.to.login(_email.text, _senha.text);
    isLoading.value = false;
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: PageView(
        controller: pageController,
        physics: const ScrollPhysics(
          parent: NeverScrollableScrollPhysics(),
        ),
        children: [
          pageInicialAnonima(),
          pageInicialAdimin(),
        ],
      ),
    );
  }

  Widget pageInicialAnonima() {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 228, 223, 230),
      appBar: AppBar(
        backgroundColor: const Color(0x00000000),
        elevation: 0,
      ),
      body: Obx(
        () => isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/prima.png',
                    alignment: Alignment.topCenter,
                    width: 350,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 25, right: 25, top: 179),
                    child: ElevatedButton(
                      onPressed: () async {
                        isLoading.value = true;
                        await AuthService.to.anonimo();
                        isLoading.value = false;
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              'Começar',
                              style: TextStyle(fontSize: 18),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      margin: const EdgeInsets.all(24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              pageController.animateToPage(
                                1,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeOutSine,
                              );
                            },
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                alignment: Alignment.centerLeft,
                                minimumSize: Size.zero),
                            child: const Text(
                              'Administração',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.indigo),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget pageInicialAdimin() {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 228, 223, 230),
      appBar: AppBar(
        leading: ElevatedButton(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            backgroundColor: MaterialStateProperty.all(
              const Color(0x00000000),
            ),
          ),
          onPressed: () async {
            FocusScopeNode focus = FocusScope.of(context);
            if (!focus.hasPrimaryFocus) {
              focus.unfocus();
              await Future.delayed(const Duration(milliseconds: 200));
            }

            pageController.animateToPage(
              0,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutSine,
            );
          },
          child: const Icon(Icons.arrow_back_ios, color: Colors.indigo),
        ),
        backgroundColor: const Color(0x00000000),
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(
        () => isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _formKeyLogin,
                child: SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/prima.png',
                        alignment: Alignment.topCenter,
                        width: 350,
                      ),
                      Container(
                        padding: const EdgeInsets.all(1),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              child: TextFormField(
                                controller: _email,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'E-mail'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Informe seu E-mail';
                                  } else if (!isEmail(value)) {
                                    return 'E-mail inválido';
                                  }

                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              child: TextFormField(
                                obscureText: true,
                                controller: _senha,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Senha'),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Informe a Senha';
                                  } else if (value.length < 6) {
                                    return 'Sua senha deve ter no mínimo 6 caracteres';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              child: ElevatedButton(
                                onPressed: () async {
                                  FocusScopeNode focus = FocusScope.of(context);
                                  if (!focus.hasPrimaryFocus) {
                                    focus.unfocus();
                                    await Future.delayed(
                                        const Duration(milliseconds: 300));
                                  }
                                  if (_formKeyLogin.currentState!.validate()) {
                                    login();
                                  }
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check),
                                    Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Text(
                                        'Entrar',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(p);

    return regExp.hasMatch(em);
  }
}
