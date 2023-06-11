import 'package:e_commerce_app/app/constants/order_by_value.dart';
import 'package:e_commerce_app/app/pages/transaction/list_transaction/widgets/transaction_container.dart';
import 'package:e_commerce_app/app/providers/transaction_provider.dart';
import 'package:e_commerce_app/app/widgets/app_bar_search.dart';
import 'package:e_commerce_app/app/widgets/count_and_option.dart';
import 'package:e_commerce_app/app/widgets/sort_filter_chip.dart';
import 'package:e_commerce_app/config/flavor_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListTransactionPage extends StatefulWidget {
  const ListTransactionPage({Key? key}) : super(key: key);

  @override
  State<ListTransactionPage> createState() => _ListTransactionPageState();
}

class _ListTransactionPageState extends State<ListTransactionPage> {
  FlavorConfig flavor = FlavorConfig.instance;

  final TextEditingController _txtSearch = TextEditingController();

  OrderByEnum orderByEnum = OrderByEnum.newest;
  OrderByValue orderByValue = getEnumValue(OrderByEnum.newest);

  String search = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('${Theme.of(context).scaffoldBackgroundColor}');
    print('${Theme.of(context).appBarTheme.backgroundColor}}');
    print('${Theme.of(context).primaryColor}');

    return Scaffold(
      appBar: AppBarSearch(
        onChanged: (value) {
          search = value!;
          if (flavor.flavor == Flavor.admin) {
            context.read<TransactionProvider>().loadAllTransaction(
                  search: search,
                  orderByEnum: orderByEnum,
                );
          } else {
            context.read<TransactionProvider>().loadAccountTransaction(
                  search: search,
                  orderByEnum: orderByEnum,
                );
          }
        },
        controller: _txtSearch,
        hintText: 'Ürün işlemlerini ara',
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            child: Column(
              children: [
                CountAndOption(
                  count: value.listTransaction.length,
                  itemName: 'İşlemler',
                  isSort: true,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return SortFilterChip(
                              dataEnum: OrderByEnum.values.take(4).toList(),
                              onSelected: (value) {
                                setState(() {
                                  orderByEnum = value;
                                  orderByValue = getEnumValue(value);
                                  if (flavor.flavor == Flavor.admin) {
                                    context
                                        .read<TransactionProvider>()
                                        .loadAllTransaction(
                                          search: search,
                                          orderByEnum: orderByEnum,
                                        );
                                  } else {
                                    context
                                        .read<TransactionProvider>()
                                        .loadAccountTransaction(
                                          search: search,
                                          orderByEnum: orderByEnum,
                                        );
                                  }
                                });
                              },
                              selectedEnum: orderByEnum,
                            );
                          },
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                if (value.listTransaction.isEmpty && _txtSearch.text.isEmpty)
                  const Center(
                    child: Text(
                      'Henüz işlem yapılmamış',
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (value.listTransaction.isEmpty && _txtSearch.text.isNotEmpty)
                  const Center(
                    child: Text('İşlem Bulunamadı'),
                  ),
                if (value.listTransaction.isNotEmpty)
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        if (flavor.flavor == Flavor.admin) {
                          value.loadAllTransaction(
                            search: search,
                            orderByEnum: orderByEnum,
                          );
                        } else {
                          value.loadAccountTransaction(
                            search: search,
                            orderByEnum: orderByEnum,
                          );
                        }
                      },
                      child: ListView.builder(
                        itemCount: value.listTransaction.length,
                        itemBuilder: (_, index) {
                          final item = value.listTransaction[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: TransactionContainer(item: item),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
