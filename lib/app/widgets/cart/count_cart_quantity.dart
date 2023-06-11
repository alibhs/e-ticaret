import 'package:e_commerce_app/app/constants/colors_value.dart';
import 'package:e_commerce_app/utils/extension.dart';
import 'package:flutter/material.dart';

class CountCartQuantity extends StatelessWidget {
  final int quantity;
  final void Function()? onTapAdd;
  final void Function()? onTapRemove;
  const CountCartQuantity({
    Key? key,
    required this.quantity,
    this.onTapAdd,
    this.onTapRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTapRemove,
          child: Icon(
            Icons.remove_rounded,
            color: ColorsValue.primaryColor(context),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          quantity.toNumericFormat(),
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(width: 12),
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTapAdd,
          child: Icon(
            Icons.add_rounded,
            color: ColorsValue.primaryColor(context),
          ),
        ),
      ],
    );
  }
}
