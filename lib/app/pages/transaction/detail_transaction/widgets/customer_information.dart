import 'package:e_commerce_app/core/domain/entities/account/account.dart';
import 'package:e_commerce_app/utils/extension.dart';
import 'package:flutter/material.dart';

class CustomerInformation extends StatelessWidget {
  final Account customer;
  const CustomerInformation({
    super.key,
    required this.customer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Müşteri Bilgileri',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Adı',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              customer.fullName,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'E-posta',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              customer.emailAddress,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Telefon Numarası',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              customer.phoneNumber.separateCountryCode(),
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
      ],
    );
  }
}
