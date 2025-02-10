import 'package:flutter/material.dart';
import 'package:animal/services/models.dart';
import 'package:animal/theme.dart'; // Import the theme.dart file

class AnimalDetailScreen extends StatelessWidget {
  final Animal animal;

  const AnimalDetailScreen({super.key, required this.animal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          animal.name,
          style: Theme.of(context)
              .textTheme
              .headlineMedium, // Use the theme for text styling
        ),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Hero Image with Animation
          Hero(
            tag: animal.id,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                animal.imageUrl,
                width: MediaQuery.of(context).size.width,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Animal Description
          Text(
            animal.description,
            style: Theme.of(context)
                .textTheme
                .bodyMedium, // Use the theme for body text
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 20),

          // Grouping animal details inside a Card
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: premiumCardColor, // Use the premium card color from theme
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(
                      Icons.location_on, 'Habitat', animal.habitat, context),
                  _buildDetailRow(Icons.accessibility, 'Distinctive Traits',
                      animal.distinctive_traits, context),
                  _buildDetailRow(
                      Icons.height, 'Height', animal.height, context),
                  _buildDetailRow(
                      Icons.access_time, 'Lifespan', animal.lifespan, context),
                  _buildDetailRow(
                      Icons.fitness_center, 'Weight', animal.weight, context),
                  _buildDetailRow(Icons.run_circle, 'Running Speed',
                      animal.running_speed, context),
                  _buildDetailRow(Icons.science, 'Scientific Name',
                      animal.scientific_name, context),
                  _buildDetailRow(
                      Icons.food_bank, 'Diet', animal.diet, context),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Footprint Image (if available)
          if (animal.footImage.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                animal.footImage,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          if (animal.footImage.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: Text(
                  'No foot image available.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color:
                            premiumSecondaryTextColor, // Using secondary text color
                      ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Helper method to create the detail rows with theme-based styling
  Widget _buildDetailRow(
      IconData icon, String title, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon,
              color: premiumAccentColor, size: 24), // Accent color for icons
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$title: $value',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color:
                        premiumTextColor, // Applying the text color from theme
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
