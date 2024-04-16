import 'package:flutter/material.dart';
import 'package:tde1/db/db_helper.dart';
import 'package:tde1/model/Pet.dart';

class PetForm extends StatefulWidget {
  Pet? pet;
  PetForm({Key? key, this.pet}) : super(key: key);

  @override
  _PetFormState createState() => _PetFormState(pet: this.pet);
}

class _PetFormState extends State<PetForm> {
  Pet? pet;
  _PetFormState({this.pet});

  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerTipo = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void saveShit() async {
    if (_formKey.currentState!.validate()) {
      var bdHelper = BancoHelper();

      Map<String, dynamic> row = {
        BancoHelper.idColumn: pet?.id,
        BancoHelper.nameColumn: _controllerNome.text,
        BancoHelper.ageColumn: _controllerTipo.text
      };

      await bdHelper.insert(row);

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _controllerNome.dispose();
    _controllerTipo.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (Pet == null) return;
    _controllerTipo.text = pet?.type.toString() ?? "";
    _controllerNome.text = pet?.name.toString() ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Pets'),
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
                  controller: _controllerTipo,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'É obrigatório informar o tipo.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(8.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: "Tipo",
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
