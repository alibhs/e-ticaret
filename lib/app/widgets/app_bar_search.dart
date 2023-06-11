import 'package:e_commerce_app/app/widgets/cart/cart_badge.dart';
import 'package:e_commerce_app/config/flavor_config.dart';
import 'package:flutter/material.dart';

import '../../utils/debouncer.dart';

class AppBarSearch extends StatefulWidget implements PreferredSizeWidget {
  final void Function(String?) onChanged;
  final TextEditingController controller;
  final String hintText;
  final PreferredSizeWidget? bottom;
  const AppBarSearch({
    Key? key,
    required this.onChanged,
    required this.controller,
    required this.hintText,
    this.bottom,
  }) : super(key: key);

  @override
  State<AppBarSearch> createState() => _AppBarSearchState();

  @override
  Size get preferredSize => _PreferredAppBarSize(kToolbarHeight, bottom?.preferredSize.height);
}

class _AppBarSearchState extends State<AppBarSearch> {
  FlavorConfig flavor = FlavorConfig.instance;

  Debouncer db = Debouncer(
    delay: const Duration(milliseconds: 500),
  );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      title: TextField(
        controller: widget.controller,
        style: Theme.of(context).textTheme.bodySmall,
        decoration: InputDecoration(
          hintText: widget.hintText,
          isDense: true,
          prefixIcon: const Icon(Icons.search_rounded),
          prefixIconConstraints: const BoxConstraints(
            minHeight: 36,
            minWidth: 36,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
        ),
        onChanged: (value) {
          db.call(() {
            widget.onChanged(value);
          });
        },
      ),
      actions: flavor.flavor == Flavor.user
          ? [
              const CartBadge(),
              const SizedBox(width: 32),
            ]
          : null,
    );
  }
}

class _PreferredAppBarSize extends Size {
  _PreferredAppBarSize(this.toolbarHeight, this.bottomHeight)
      : super.fromHeight((toolbarHeight ?? kToolbarHeight) + (bottomHeight ?? 0));

  final double? toolbarHeight;
  final double? bottomHeight;
}
