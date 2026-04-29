import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/meal.dart';
import '../services/meal_api_service.dart';
import '../services/api_exception.dart';

/// Meal detail screen — fetches full meal data via /lookup.php and displays:
///   • Hero thumbnail
///   • Title, category chip, area chip
///   • YouTube link button (url_launcher)
///   • Ingredients list with measures
///   • Full instructions
class MealDetailScreen extends StatefulWidget {
  final String mealId;

  const MealDetailScreen({super.key, required this.mealId});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final MealApiService _service = MealApiService();
  late Future<Meal?> _mealFuture;

  @override
  void initState() {
    super.initState();
    _mealFuture = _service.getMealById(widget.mealId);
  }

  String _getErrorMessage(Object error) {
    if (error is SocketException) {
      return 'No internet connection';
    } else if (error is TimeoutException) {
      return 'Request timed out. Please try again.';
    } else if (error is ApiException) {
      return 'Error ${error.statusCode}: ${error.message}';
    } else if (error is FormatException) {
      return 'Unexpected data format received';
    } else {
      return 'An unexpected error occurred: $error';
    }
  }

  /// Opens the YouTube URL in an external app / browser.
  Future<void> _launchYouTube(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Meal?>(
        future: _mealFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            final errorMsg = _getErrorMessage(snapshot.error!);
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    errorMsg,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () => setState(() {
                      _mealFuture = _service.getMealById(widget.mealId);
                    }),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          if (snapshot.data == null) {
             return const Center(child: Text('No data available.'));
          }

          final meal = snapshot.data!;
          return _MealDetailBody(meal: meal, onLaunchYouTube: _launchYouTube);
        },
      ),
    );
  }
}

/// The actual scrollable body once data is loaded.
class _MealDetailBody extends StatelessWidget {
  final Meal meal;
  final Future<void> Function(String url) onLaunchYouTube;

  const _MealDetailBody({
    required this.meal,
    required this.onLaunchYouTube,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return CustomScrollView(
      slivers: [
        // ── Collapsible app bar with hero image ───────────────────────────
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          flexibleSpace: FlexibleSpaceBar(
            background: Hero(
              tag: 'meal_thumb_${meal.idMeal}',
              child: CachedNetworkImage(
                imageUrl: meal.strMealThumb,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: colorScheme.surfaceContainerHighest,
                ),
                errorWidget: (context, url, error) => Container(
                  color: colorScheme.surfaceContainerHighest,
                  child: const Icon(Icons.restaurant, size: 64),
                ),
              ),
            ),
          ),
        ),

        // ── Content ───────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  meal.strMeal,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // Category & Area chips
                Wrap(
                  spacing: 8,
                  children: [
                    if (meal.strCategory != null)
                      _InfoChip(
                        icon: Icons.category_outlined,
                        label: meal.strCategory!,
                      ),
                    if (meal.strArea != null)
                      _InfoChip(
                        icon: Icons.public,
                        label: meal.strArea!,
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                // YouTube button
                if (meal.strYoutube != null &&
                    meal.strYoutube!.isNotEmpty) ...[
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFFF0000),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => onLaunchYouTube(meal.strYoutube!),
                      icon: const Icon(Icons.play_circle_fill, size: 22),
                      label: const Text(
                        'Watch on YouTube',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // ── Ingredients ─────────────────────────────────────────
                _SectionHeader(
                  icon: Icons.restaurant_menu,
                  title: 'Ingredients',
                ),
                const Divider(),
                const SizedBox(height: 8),
                ...meal.ingredients.map(
                  (ingredient) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.fiber_manual_record,
                            size: 10,
                            color: colorScheme.primary),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            ingredient,
                            style: textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // ── Instructions ────────────────────────────────────────
                _SectionHeader(
                  icon: Icons.list_alt_outlined,
                  title: 'Instructions',
                ),
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  meal.strInstructions ?? 'No instructions available.',
                  style: textTheme.bodyMedium?.copyWith(height: 1.6),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Reusable chip widget for category / area labels.
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: colorScheme.onPrimaryContainer),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

/// Reusable section header (icon + bold title).
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
