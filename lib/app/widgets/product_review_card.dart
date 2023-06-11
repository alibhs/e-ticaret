import 'package:e_commerce_app/app/widgets/star_count.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../core/domain/entities/review/review.dart';

class ProductReviewCard extends StatelessWidget {
  final Review item;
  const ProductReviewCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item.reviewerName,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              timeago.format(item.createdAt, locale: "tr"),
              style: Theme.of(context).textTheme.bodySmall,
            )
          ],
        ),
        const SizedBox(height: 4),
        StarRating(
          star: item.star,
          starSize: 16,
        ),
        const SizedBox(height: 8),
        Text(
          item.description ?? '',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
