import 'package:flutter/material.dart';
import 'package:recurseo/core/constants/app_colors.dart';

/// Widget para mostrar rating con estrellas
class RatingDisplay extends StatelessWidget {
  final double rating;
  final int? reviewCount;
  final double size;
  final bool showNumber;
  final Color? color;

  const RatingDisplay({
    super.key,
    required this.rating,
    this.reviewCount,
    this.size = 16,
    this.showNumber = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Estrellas
        ...List.generate(5, (index) {
          final starRating = index + 1;
          IconData icon;

          if (rating >= starRating) {
            icon = Icons.star;
          } else if (rating >= starRating - 0.5) {
            icon = Icons.star_half;
          } else {
            icon = Icons.star_border;
          }

          return Icon(
            icon,
            size: size,
            color: color ?? AppColors.warning,
          );
        }),

        if (showNumber) ...[
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: size * 0.875,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ],

        if (reviewCount != null) ...[
          const SizedBox(width: 4),
          Text(
            '($reviewCount)',
            style: TextStyle(
              fontSize: size * 0.75,
              color: Colors.grey[600],
            ),
          ),
        ],
      ],
    );
  }
}

/// Widget interactivo para seleccionar rating
class RatingSelector extends StatefulWidget {
  final int initialRating;
  final ValueChanged<int> onRatingChanged;
  final double size;

  const RatingSelector({
    super.key,
    this.initialRating = 0,
    required this.onRatingChanged,
    this.size = 32,
  });

  @override
  State<RatingSelector> createState() => _RatingSelectorState();
}

class _RatingSelectorState extends State<RatingSelector> {
  late int _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starRating = index + 1;
        return IconButton(
          onPressed: () {
            setState(() {
              _currentRating = starRating;
            });
            widget.onRatingChanged(starRating);
          },
          icon: Icon(
            starRating <= _currentRating ? Icons.star : Icons.star_border,
            size: widget.size,
            color: AppColors.warning,
          ),
        );
      }),
    );
  }
}
