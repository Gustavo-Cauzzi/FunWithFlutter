import 'package:flutter/material.dart';
import 'package:tde1/pages/Foods/food_list.dart';
import 'package:tde1/pages/Persons/person_list.dart';
import 'package:tde1/pages/Pets/pet_list.dart';

class Menu extends StatelessWidget {
  Menu({super.key});

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
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const FoodsList())),
                child: const Text(
                  'Comidas',
                  style: TextStyle(fontSize: 20),
                )),
            ElevatedButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const PetsList())),
                child: const Text(
                  '    Pets    ',
                  style: TextStyle(fontSize: 20),
                ))
          ],
        ),
      ),
    );
  }
}
