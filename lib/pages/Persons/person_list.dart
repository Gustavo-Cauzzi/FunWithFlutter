import 'package:tde1/db/db_helper.dart';
import 'package:tde1/model/person.dart';
import 'package:flutter/material.dart';

import 'package:tde1/pages/Persons/person_form.dart';
import 'package:tde1/utils/ui_utils.dart';

void main() {
  runApp(const PersonsList());
}

class PersonsList extends StatefulWidget {
  const PersonsList({super.key});

  @override
  State<PersonsList> createState() => _PersonsListState();
}

class _PersonsListState extends State<PersonsList> {
  var bdHelper = BancoHelper();
  final _searchDebouncer = Debouncer(milliseconds: 300);
  final _nameFilterController = TextEditingController();
  final _ageFilterController = TextEditingController();

  bool _isFiltersActive = false;
  final List<Person> _data = [];

  List<Person> getFilteredList() {
    return _data
        .where((person) =>
            (_nameFilterController.text.isEmpty ||
                person.name == null ||
                person.name!
                    .toLowerCase()
                    .contains(_nameFilterController.text.toLowerCase())) &&
            (_ageFilterController.text.isEmpty ||
                person.age.toString().contains(_ageFilterController.text)))
        .toList();
  }

  void handleToggleIsFilterActive() {
    setState(() {
      _isFiltersActive = !_isFiltersActive;
    });
  }

  void loadPersons() async {
    var r = await bdHelper.findAll();

    setState(() {
      _data.clear();
      _data.addAll(r);
    });
  }

  void deleteAll() async {
    bool confirmation = await confirmationDialog(context, "Excluir tudo",
        "Você tem certeza que deseja excluir todos os registros?");

    if (!confirmation) return;

    await bdHelper.deleteAll();
    loadPersons();
  }

  void delete(Person person) async {
    bool confirmation = await confirmationDialog(context, "Excluir pessoa",
        "Você tem certeza que deseja excluir a pessoa \"${person.name}\"?");

    if (!confirmation) return;
    if (person.id == null) return;
    await bdHelper.delete(person.id!);
    loadPersons();
  }

  @override
  void initState() {
    super.initState();
    loadPersons();
  }

  @override
  void dispose() {
    super.dispose();
    _searchDebouncer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Pessoas'),
          actions: [
            IconButton(
                onPressed: handleToggleIsFilterActive,
                icon: Icon(_isFiltersActive
                    ? Icons.filter_alt
                    : Icons.filter_alt_outlined))
          ],
        ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                _isFiltersActive
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Filtros:",
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 35,
                            margin: const EdgeInsets.only(bottom: 5),
                            child: TextField(
                                controller: _nameFilterController,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(8.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  hintText: "Nome",
                                ),
                                onChanged: (text) =>
                                    _searchDebouncer.run(() => setState(() {
                                          _nameFilterController.text = text;
                                        }))),
                          ),
                          Container(
                            height: 35,
                            margin: const EdgeInsets.only(bottom: 15),
                            child: TextField(
                              controller: _ageFilterController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(8.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                hintText: "Idade",
                              ),
                              onChanged: (text) =>
                                  _searchDebouncer.run(() => setState(() {
                                        _ageFilterController.text = text;
                                      })),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height -
                          (_isFiltersActive ? 343 : 225)),
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(245, 245, 245, 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 9),
                          ),
                        ],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height - 225),
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.only(bottom: 20),
                              scrollDirection: Axis.vertical,
                              child: DataTable(
                                columnSpacing: 30,
                                columns: ['ID', 'Nome', 'Idade', '']
                                    .map((label) => DataColumn(
                                          label: Text(
                                            label,
                                            style: const TextStyle(
                                                fontStyle: FontStyle.italic),
                                          ),
                                        ))
                                    .toList(),
                                rows: getFilteredList()
                                    .map((person) => DataRow(
                                          cells: <DataCell>[
                                            DataCell(Text(
                                                person.id?.toString() ?? '-')),
                                            DataCell(Text(
                                                person.name ?? 'Desconhecido')),
                                            DataCell(Text(
                                                person.age?.toString() ?? "-")),
                                            DataCell(
                                              Row(children: [
                                                Ink(
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                    color: Colors.purple[400],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: IconButton(
                                                    icon: const Icon(Icons.edit,
                                                        size: 14),
                                                    color: Colors.white,
                                                    onPressed: () async {
                                                      await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  PersonForm(
                                                                      person:
                                                                          person)));
                                                      loadPersons();
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Ink(
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                    color: Colors.red[600],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: IconButton(
                                                    icon: const Icon(
                                                        Icons.delete,
                                                        size: 14),
                                                    color: Colors.white,
                                                    onPressed: () =>
                                                        delete(person),
                                                  ),
                                                )
                                              ]),
                                            ),
                                          ],
                                        ))
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: _data.isEmpty
                              ? const Text("Nenhuma pessoa cadastrada")
                              : const SizedBox(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 30,
                      child: ElevatedButton(
                          onPressed: _data.isEmpty ? null : deleteAll,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[400],
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10)),
                          child: (const Row(
                            children: [
                              Text("Excluir tudo",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12)),
                              Icon(
                                Icons.delete_outline_outlined,
                                color: Colors.white,
                                size: 16,
                              )
                            ],
                          ))),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        floatingActionButton: Builder(
          builder: (BuildContext context) {
            return FloatingActionButton(
              child: const Icon(Icons.person_add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonForm(),
                  ),
                ).then((value) => loadPersons());
              },
            );
          },
        ),
      ),
    );
  }
}
