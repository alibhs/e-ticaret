import 'package:e_commerce_app/app/pages/transaction/detail_transaction/widgets/review_product_form.dart';
import 'package:e_commerce_app/app/providers/account_provider.dart';
import 'package:e_commerce_app/app/providers/transaction_provider.dart';
import 'package:e_commerce_app/core/domain/entities/account/account.dart';
import 'package:e_commerce_app/core/domain/entities/review/review.dart';
import 'package:e_commerce_app/core/domain/entities/transaction/transaction.dart';
import 'package:e_commerce_app/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActionTransactionButton extends StatelessWidget {
  final int transactionStatus;
  final Transaction data;
  const ActionTransactionButton(
      {super.key, required this.transactionStatus, required this.data});

  @override
  Widget build(BuildContext context) {
    void Function()? onPressed;
    String labelText = '';
    TransactionStatus status = TransactionStatus.values
        .where((element) => element.value == transactionStatus)
        .first;

    switch (status) {
      case TransactionStatus.gonderiliyor:
        labelText = 'İşleniyor';
        break;
      case TransactionStatus.gonderildi:
        labelText = 'Gönderildi';
        break;
      case TransactionStatus.ulastirildi:
        labelText = 'Kabul Edildi';
        onPressed = () {
          context.read<TransactionProvider>().accept();
        };
        break;
      case TransactionStatus.tamamlandi:
        labelText = 'Yorum Yap';
        onPressed = () async {
          List<Review> dataReview = [];

          Account currentUser = context.read<AccountProvider>().account;

          dataReview.addAll(
            data.purchasedProduct.map(
              (e) => Review(
                reviewId: ''.generateUID(),
                productId: e.productId,
                product: e.product!,
                accountId: data.accountId,
                star: 0,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
                reviewerName: currentUser.fullName,
              ),
            ),
          );

          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ...dataReview.map(
                          (review) => ReviewProductForm(
                            data: review,
                            onTapStar: (star) {
                              setState(() {
                                review.star = star;
                              });
                            },
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Consumer<TransactionProvider>(
                            builder: (context, value, child) {
                              if (value.isLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              return ElevatedButton(
                                onPressed: dataReview
                                        .every((element) => element.star > 0)
                                    ? () async {
                                        await value
                                            .submitReview(
                                              transactionId: data.transactionId,
                                              data: dataReview,
                                            )
                                            .whenComplete(
                                              () => Navigator.of(context).pop(),
                                            );
                                      }
                                    : null,
                                child: const Text('Yorum Yap'),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  );
                },
              );
            },
          );
        };
        break;
      case TransactionStatus.reddedildi:
        labelText = 'Reddedildi';
        break;
      case TransactionStatus.yorumlandi:
        labelText = 'Değerlendirildi';
        break;
      default:
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16.0),
      child: Consumer<TransactionProvider>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ElevatedButton(
            onPressed: onPressed,
            child: Text(labelText),
          );
        },
      ),
    );
  }
}
