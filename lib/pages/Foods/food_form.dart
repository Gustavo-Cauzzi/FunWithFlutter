import 'package:tde1/db/db_helper.dart';

import 'package:tde1/model/food.dart';
import 'package:tde1/model/food.dart';
import 'package:flutter/material.dart';

class FoodForm extends StatefulWidget {
  Food? food;
  FoodForm({Key? key, this.food}) : super(key: key);

  @override
  _FoodFormState createState() => _FoodFormState(food: this.food);
}

class _FoodFormState extends State<FoodForm> {
  Food? food;
  _FoodFormState({this.food});

  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerPeso = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void saveFood() async {
    if (_formKey.currentState!.validate()) {
      var bdHelper = BancoHelper();

      Map<String, dynamic> row = {
        BancoHelper.idColumn: food?.id,
        BancoHelper.nameColumn: _controllerNome.text,
        BancoHelper.weightColumn: _controllerPeso.text
      };

      await bdHelper.insertFood(row);

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _controllerNome.dispose();
    _controllerPeso.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (food == null) return;
    _controllerPeso.text = food?.weight.toString() ?? "";
    _controllerNome.text = food?.name.toString() ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Comidas'),
      ),
      body: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.only(left: 50, right: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _controllerNome,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'É obrigatório informar o nome.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(8.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: "Nome",
                  ),
                ),
                const SizedBox(
                  height: 15.7,
                ),
                TextFormField(
                  controller: _controllerPeso,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'É obrigatório informar o peso.';
                    }
                    if (value.contains(",")) {
                      if (value.split(",").length > 19) {
                        return "Número não pode ser maior que 19 dígitos";
                      }
                      if (value.split(',')[1].length > 4) {
                        return "Decimais não podem ser maiores que 4 dígitos";
                      }
                      value.replaceAll(",", ".");
                    } else if (value.length > 19) {
                      return "Número não pode ser maior que 19 dígitos";
                    }
                    if (value.contains('-') || value.trim().contains(" ")) {
                      return "Número inválido";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(8.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: "Peso",
                  ),
                )
              ],
            ),
          )),
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return FloatingActionButton(
            child: const Icon(Icons.save),
            onPressed: () {
              saveFood();
            },
          );
        },
      ),
    );
  }
}
