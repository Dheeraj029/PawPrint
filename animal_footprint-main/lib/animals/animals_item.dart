import 'package:animal/animals/animal_detail.dart';
import 'package:animal/shared/animal_progress.dart';
import 'package:flutter/material.dart';
import 'package:animal/services/models.dart';
import 'package:animal/shared/progress_bar.dart';

class AnimalItem extends StatelessWidget {
  final Animal animal;
  const AnimalItem({super.key, required this.animal});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: animal.id,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    AnimalDetailScreen(animal: animal),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 3,
                child: SizedBox(
                  child: Image.network(
                    animal.imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    animal.name,
                    style: const TextStyle(
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.fade,
                    softWrap: false,
                  ),
                ),
              ),
              //         Flexible(child: AnimalProgress(animal: animal)),
            ],
          ),
        ),
      ),
    );
  }
}
