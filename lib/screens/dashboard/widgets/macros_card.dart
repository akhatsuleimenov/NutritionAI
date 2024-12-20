// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:bites/core/constants/app_typography.dart';
import 'package:bites/core/models/food_model.dart';
import 'package:bites/core/widgets/cards.dart';

class CalorieCard extends StatelessWidget {
  final double targetCalories;
  final double remainingCalories;
  final bool isOnboarding;
  const CalorieCard({
    super.key,
    required this.targetCalories,
    required this.remainingCalories,
    this.isOnboarding = false,
  });
  @override
  Widget build(BuildContext context) {
    final double progress =
        (targetCalories - remainingCalories) / targetCalories;
    return BaseCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isOnboarding) ...[
                    Text(
                      'Calories Consumed',
                      style: AppTypography.bodyLarge.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      (targetCalories - remainingCalories).toStringAsFixed(0),
                      style: AppTypography.headlineLarge,
                    ),
                  ] else ...[
                    Text(
                      'Calories',
                      style: AppTypography.bodyLarge.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ]
                ],
              ),
              if (!isOnboarding) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Goal',
                      style: AppTypography.bodyMedium.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      targetCalories.toStringAsFixed(0),
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Text(
                  targetCalories.toStringAsFixed(0),
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: targetCalories > 0 ? progress : 0,
              backgroundColor: Colors.grey[200],
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class NutritionGrid extends StatelessWidget {
  final NutritionData targetNutrition;
  final NutritionData remainingNutrition;
  final bool isOnboarding;
  const NutritionGrid({
    super.key,
    required this.targetNutrition,
    required this.remainingNutrition,
    this.isOnboarding = false,
  });
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 0.8,
      children: [
        _MacroCard(
          title: 'Protein',
          consumed:
              (targetNutrition.protein - remainingNutrition.protein).toInt(),
          target: targetNutrition.protein.toInt(),
          unit: 'g',
          color: Colors.red[400]!,
          isOnboarding: isOnboarding,
        ),
        _MacroCard(
          title: 'Carbs',
          consumed: (targetNutrition.carbs - remainingNutrition.carbs).toInt(),
          target: targetNutrition.carbs.toInt(),
          unit: 'g',
          color: Colors.blue[400]!,
          isOnboarding: isOnboarding,
        ),
        _MacroCard(
          title: 'Fat',
          consumed: (targetNutrition.fats - remainingNutrition.fats).toInt(),
          target: targetNutrition.fats.toInt(),
          unit: 'g',
          color: Colors.orange[400]!,
          isOnboarding: isOnboarding,
        ),
      ],
    );
  }
}

class _MacroCard extends StatelessWidget {
  final String title;
  final int consumed;
  final int target;
  final String unit;
  final Color color;
  final bool isOnboarding;

  const _MacroCard({
    required this.title,
    required this.consumed,
    required this.target,
    required this.unit,
    required this.color,
    required this.isOnboarding,
  });
  @override
  Widget build(BuildContext context) {
    return BaseCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableHeight = constraints.maxHeight;
          final progressSize = availableHeight * 0.5;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: progressSize,
                width: progressSize,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: target > 0 ? consumed / target : 0,
                      backgroundColor: Colors.grey[200],
                      color: color,
                      strokeWidth: 8,
                    ),
                    Icon(
                      _getIconForMacro(title),
                      color: color,
                      size: progressSize * 0.4,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: AppTypography.bodySmall.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  !isOnboarding ? '$consumed/$target$unit' : '$target$unit',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  IconData _getIconForMacro(String title) {
    switch (title.toLowerCase()) {
      case 'protein':
        return Icons.egg_outlined;
      case 'carbs':
        return Icons.breakfast_dining;
      case 'fat':
        return Icons.water_drop_outlined;
      default:
        return Icons.circle_outlined;
    }
  }
}
