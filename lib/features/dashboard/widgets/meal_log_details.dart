import 'package:flutter/material.dart';
import 'package:nutrition_ai/core/constants/app_typography.dart';
import 'package:nutrition_ai/core/models/meal_log.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MealLogDetails extends StatelessWidget {
  final MealLog mealLog;

  const MealLogDetails({
    super.key,
    required this.mealLog,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (mealLog.imagePath.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: mealLog.imagePath,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mealLog.items.first.name,
                      style: AppTypography.headlineMedium,
                    ),
                    Text(
                      '${mealLog.totalCalories.toInt()} calories',
                      style: AppTypography.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...mealLog.items.map((item) => _ItemCard(item: item)),
        ],
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final FoodItem item;

  const _ItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.name,
              style: AppTypography.headlineSmall,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NutrientInfo(
                  label: 'Calories',
                  value: item.totalNutrition['calories']!.toString(),
                  unit: 'kcal',
                ),
                _NutrientInfo(
                  label: 'Protein',
                  value: item.totalNutrition['protein']!.toString(),
                  unit: 'g',
                ),
                _NutrientInfo(
                  label: 'Carbs',
                  value: item.totalNutrition['carbs']!.toString(),
                  unit: 'g',
                ),
                _NutrientInfo(
                  label: 'Fat',
                  value: item.totalNutrition['fat']!.toString(),
                  unit: 'g',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NutrientInfo extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const _NutrientInfo({
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey[600]),
        ),
        Text(
          '$value$unit',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}