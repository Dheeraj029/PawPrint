import 'package:animal/animals/animal_detail.dart';
import 'package:flutter/material.dart';
import 'package:animal/services/firestore.dart';
import 'package:animal/services/models.dart';
import 'package:animal/services/services.dart';
import 'package:animal/shared/shared.dart';
import 'package:animal/animals/animals_item.dart';
import 'package:animal/theme.dart'; // Import the theme.dart file

class AnimalsScreen extends StatefulWidget {
  const AnimalsScreen({super.key});

  @override
  _AnimalsScreenState createState() => _AnimalsScreenState();
}

class _AnimalsScreenState extends State<AnimalsScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Animal> _allAnimals = [];
  List<Animal> _filteredAnimals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadAnimals();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // Fetch the animals from the Firestore service
  Future<void> _loadAnimals() async {
    try {
      List<Animal> animals = await FirestoreService().getAnimals();
      setState(() {
        _allAnimals = animals;
        _filteredAnimals = animals;
        _isLoading =
            false; // Once data is fetched, stop showing loading indicator
      });
    } catch (e) {
      setState(() {
        _filteredAnimals = [];
        _isLoading = false;
      });
    }
  }

  // Filter animals based on search query
  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredAnimals = _allAnimals.where((animal) {
        return animal.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const LoadingScreen() // Only show loading when initially loading animals
        : _buildMainScreen(context);
  }

  Widget _buildMainScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: premiumBackgroundColor, // Use the theme background color
      body: CustomScrollView(
        slivers: [
          // Modern app bar with gradient
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      premiumPrimaryColor, // Dark teal for gradient start
                      premiumAccentColor, // Soft gold for gradient end
                    ],
                  ),
                ),
              ),
              title: const Text(
                'Paw Print',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: premiumTextColor, // Light text color from theme
                ),
              ),
              centerTitle: true,
            ),
          ),
          // Search bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: premiumCardColor, // Use the card color from theme
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search animals...',
                    prefixIcon: Icon(Icons.search,
                        color:
                            premiumSecondaryTextColor), // Accent color for search icon
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor:
                        premiumBackgroundColor, // Use the background color
                  ),
                ),
              ),
            ),
          ),
          // Grid of animal cards
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => AnimalCard(animal: _filteredAnimals[index]),
                childCount: _filteredAnimals.length,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Add new animal scan functionality
      //   },
      //   backgroundColor: premiumAccentColor, // Soft gold for FAB
      //   child: const Icon(Icons.add_a_photo, color: premiumTextColor),
      // ),
    );
  }
}

class AnimalCard extends StatelessWidget {
  final Animal animal;
  const AnimalCard({super.key, required this.animal});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AnimalDetailScreen(animal: animal),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: premiumCardColor, // Dark grey card color from theme
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section with gradient overlay
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: Image.network(
                      animal.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Gradient overlay
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Footprint type badge
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: premiumBackgroundColor
                            .withOpacity(0.9), // Use the background color
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        animal.name ?? "Unknown",
                        style: TextStyle(
                          color: premiumAccentColor, // Soft gold for text
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Info section
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        animal.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color:
                              premiumTextColor, // Light text color from theme
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.category_outlined,
                          size: 14,
                          color:
                              premiumSecondaryTextColor, // Subtle grey for icon
                        ),
                        const SizedBox(width: 4),
                        Text(
                          animal.name ?? "Unclassified",
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                premiumSecondaryTextColor, // Subtle grey for text
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  final String message;
  const ErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            'Oops! Something went wrong',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class EmptyStateView extends StatelessWidget {
  const EmptyStateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.pets, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No animals found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: premiumSecondaryTextColor, // Using subtle grey
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adding some animal footprints',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: premiumSecondaryTextColor, // Subtle grey
                ),
          ),
        ],
      ),
    );
  }
}
