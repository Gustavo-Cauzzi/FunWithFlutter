import 'dart:ffi';

import 'package:tde1/db/db_helper.dart';
import 'package:tde1/model/person.dart';
import 'package:flutter/material.dart';

class PersonForm extends StatefulWidget {
  Person? person;
  PersonForm({Key? key, this.person}) : super(key: key);

  @override
  _PersonFormState createState() => _PersonFormState(person: this.person);
}

class _PersonFormState extends State<PersonForm> {
  Person? person;
  _PersonFormState({this.person});

  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerIdade = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void saveShit() async {
    if (_formKey.currentState!.validate()) {
      var bdHelper = BancoHelper();

      Map<String, dynamic> row = {
        BancoHelper.nameColumn: _controllerNome.text,
        BancoHelper.ageColumn: _controllerIdade.text
      };

      await bdHelper.insert(row);

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _controllerNome.dispose();
    _controllerIdade.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (person == null) return;
    _controllerIdade.text = person?.age.toString() ?? "";
    _controllerNome.text = person?.name.toString() ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Persons'),
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
                  controller: _controllerIdade,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'É obrigatório informar a idade.';
                    }
                    if (value.contains('.') || value.contains(",")) {
                      return "Número necessita ser inteiro";
                    }
                    if (value.contains('-') ||
                        value.trim().contains(" ") ||
                        RegExp(r'\D').hasMatch(value)) {
                      return "Número inválido";
                    }
                    if (value.length > 19) {
                      return "Número não pode ser maior que 19 dígitos";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(8.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: "Idade",
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
              saveShit();
            },
          );
        },
      ),
    );
  }
}
