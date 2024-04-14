import 'package:flutter/material.dart';
import 'package:tde1/pages/Persons/person_list.dart';

class Menu extends StatelessWidget {
  Menu({super.key});

  // TODO: Se alguém tiver com tempo e tiver ideia de como que a gente podia fazer pra só ter uma lista assim e renderizar usando um map, se divirta. Eu não consegui
  final _buttons = [
    {'label': 'Pessoas', 'goTo': PersonsList},
    {'label': 'Pessoas', 'goTo': PersonsList},
    {'label': 'Pessoas', 'goTo': PersonsList},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PersonsList())),
                child: const Text(
                  'Pessoas',
                  style: TextStyle(fontSize: 20),
                )),
            ElevatedButton(
                onPressed: () {},
                child: const Text(
                  'Pessoas',
                  style: TextStyle(fontSize: 20),
                )),
            ElevatedButton(
                onPressed: () {},
                child: const Text(
                  'Pessoas',
                  style: TextStyle(fontSize: 20),
                ))
          ],
        ),
      ),
    );
  }
}
