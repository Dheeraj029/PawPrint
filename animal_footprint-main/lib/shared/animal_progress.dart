import 'package:animal/shared/animated_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:animal/services/models.dart';
import 'package:provider/provider.dart';

class AnimalProgress extends StatelessWidget {
  final Animal animal;
  const AnimalProgress({super.key, required this.animal});

  @override
  Widget build(BuildContext context) {
    // Get the current user's data (User model)
    User user = Provider.of<User>(context);

    return Row(
      children: [
        _progressCount(user, animal),
        Expanded(
          child: AnimatedProgressbar(
            value: _calculateProgress(user, animal),
            height: 8,
          ),
        ),
      ],
    );
  }

  // Count the number of classifications for this specific animal
  Widget _progressCount(User user, Animal animal) {
    // Get all classifications for this animal from the user's history
    List<ClassificationHistory> animalClassifications = user.history
        .where((classification) =>
            classification.predictedAnimalName == animal.name)
        .toList();

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        '${animalClassifications.length} / 5', // Assuming 5 classifications are required per animal
        style: const TextStyle(fontSize: 10, color: Colors.grey),
      ),
    );
  }

  // Calculate the progress of classification for this animal
  double _calculateProgress(User user, Animal animal) {
    try {
      int totalClassifications =
          5; // Example: 5 classifications required per animal
      // Get all classifications for the animal from the user's history
      int completedClassifications = user.history
          .where((classification) =>
              classification.predictedAnimalName == animal.name)
          .length;

      return completedClassifications / totalClassifications;
    } catch (err) {
      return 0.0;
    }
  }
}
