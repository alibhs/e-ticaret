import 'package:e_commerce_app/app/pages/transaction/detail_transaction/widgets/transaction_status_checkbox.dart';
import 'package:e_commerce_app/app/providers/transaction_provider.dart';
import 'package:e_commerce_app/core/domain/entities/transaction/transaction.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminActionTransactionButton extends StatelessWidget {
  final String transactionID;
  final int transactionStatus;
  const AdminActionTransactionButton({
    super.key,
    required this.transactionStatus,
    required this.transactionID,
  });

  @override
  Widget build(BuildContext context) {
    TransactionStatus status = TransactionStatus.values
        .where((element) => element.value == transactionStatus)
        .first;

    void Function()? onPressed;
    String labelText = '';

    switch (status) {
      case TransactionStatus.tamamlandi:
        labelText = 'Tamamlandı';
        break;
      case TransactionStatus.yorumlandi:
        labelText = 'Değerlendirildi';
        break;
      default:
        labelText = 'Durumu Değiştir';
        onPressed = () async {
          await showModalBottomSheet<TransactionStatus>(
            context: context,
            builder: (context) {
              return TransactionStatusCheckbox(selectedStatus: status);
            },
          ).then((status) {
            if (status != null) {
              context.read<TransactionProvider>().changeStatus(
                  transactionID: transactionID, status: status.value);
            }
          });
        };
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(labelText),
      ),
    );
  }
}
