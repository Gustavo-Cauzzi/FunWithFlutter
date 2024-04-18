import 'package:tde1/db/db_helper.dart';
import 'package:tde1/model/food.dart';
import 'package:flutter/material.dart';
import 'package:tde1/pages/Foods/food_form.dart';

import 'package:tde1/pages/Foods/food_form.dart';
import 'package:tde1/utils/ui_utils.dart';

void main() {
  runApp(const FoodsList());
}

class FoodsList extends StatefulWidget {
  const FoodsList({super.key});

  @override
  State<FoodsList> createState() => _FoodsListState();
}

class _FoodsListState extends State<FoodsList> {
  var bdHelper = BancoHelper();
  final _searchDebouncer = Debouncer(milliseconds: 300);
  final _nameFilterController = TextEditingController();
  final _weightFilterController = TextEditingController();

  bool _isFiltersActive = false;
  final List<Food> _data = [];

  List<Food> getFilteredList() {
    return _data
        .where((food) =>
            (_nameFilterController.text.isEmpty ||
                food.name == null ||
                food.name!
                    .toLowerCase()
                    .contains(_nameFilterController.text.toLowerCase())) &&
            (_weightFilterController.text.isEmpty ||
                food.weight.toString().contains(_weightFilterController.text)))
        .toList();
  }

  void handleToggleIsFilterActive() {
    setState(() {
      _isFiltersActive = !_isFiltersActive;
    });
  }

  void loadFoods() async {
    var r = await bdHelper.findAllFoods();

    setState(() {
      _data.clear();
      _data.addAll(r);
    });
  }

  void deleteAll() async {
    bool confirmation = await confirmationDialog(context, "Excluir tudo",
        "Você tem certeza que deseja excluir todos os registros?");

    if (!confirmation) return;

    await bdHelper.deleteAllFoods();
    loadFoods();
  }

  void delete(Food food) async {
    bool confirmation = await confirmationDialog(context, "Excluir comida",
        "Você tem certeza que deseja excluir essa comida \"${food.name}\"?");

    if (!confirmation) return;
    if (food.id == null) return;
    await bdHelper.deleteFood(food.id!);
    loadFoods();
  }

  @override
  void initState() {
    super.initState();
    loadFoods();
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
          title: const Text('Comidas'),
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
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
                                columns: ['ID', 'Nome', 'Peso', '']
                                    .map((label) => DataColumn(
                                          label: Text(
                                            label,
                                            style: const TextStyle(
                                                fontStyle: FontStyle.italic),
                                          ),
                                        ))
                                    .toList(),
                                rows: getFilteredList()
                                    .map((food) => DataRow(
                                          cells: <DataCell>[
                                            DataCell(Text(
                                                food.id?.toString() ?? '-')),
                                            DataCell(Text(
                                                food.name ?? 'Desconhecido')),
                                            DataCell(Text(food.weight
                                                    ?.toString()
                                                    .replaceAll(".", ",") ??
                                                "-")),
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
                                                                  FoodForm(
                                                                      food:
                                                                          food)));
                                                      loadFoods();
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
                                                        delete(food),
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
                              ? Container(
                                  margin: const EdgeInsets.only(bottom: 15),
                                  child:
                                      const Text("Nenhuma comida cadastrada"),
                                )
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
              child: const Icon(Icons.fastfood_rounded),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FoodForm(),
                  ),
                ).then((value) => loadFoods());
              },
            );
          },
        ),
      ),
    );
  }
}
