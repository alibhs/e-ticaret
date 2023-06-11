import 'package:e_commerce_app/app/pages/product/list_product/list_product_page.dart';
import 'package:e_commerce_app/app/pages/profile/profile_page.dart';
import 'package:e_commerce_app/app/pages/transaction/list_transaction/list_transaction_page.dart';
import 'package:e_commerce_app/app/pages/wishlist/list_wishlist_page.dart';
import 'package:e_commerce_app/app/providers/account_provider.dart';
import 'package:e_commerce_app/app/providers/cart_provider.dart';
import 'package:e_commerce_app/app/providers/product_provider.dart';
import 'package:e_commerce_app/app/providers/transaction_provider.dart';
import 'package:e_commerce_app/app/providers/wishlist_provider.dart';
import 'package:e_commerce_app/config/flavor_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;

  final List<Widget> _buildScreens = [];

  final List<NavigationDestination> _destinations = [];

  FlavorConfig flavor = FlavorConfig.instance;

  @override
  void initState() {
    _destinations.add(
      const NavigationDestination(
        icon: Icon(Icons.home_outlined),
        label: 'Ana Sayfa',
        selectedIcon: Icon(Icons.home_rounded),
      ),
    );

    _buildScreens.add(const ListProductPage());

    if (flavor.flavor == Flavor.user) {
      _destinations.addAll([
        const NavigationDestination(
          icon: Icon(Icons.favorite_outline_rounded),
          label: 'İstek Listesi',
          selectedIcon: Icon(Icons.favorite_rounded),
        ),
        const NavigationDestination(
          icon: Icon(Icons.receipt_long_outlined),
          label: 'İşlemlerim',
          selectedIcon: Icon(Icons.receipt_long_rounded),
        ),
      ]);
      _buildScreens.addAll([
        const ListWishlistPage(),
        const ListTransactionPage(),
      ]);
    } else {
      _destinations.addAll([
        const NavigationDestination(
          icon: Icon(Icons.receipt_long_outlined),
          label: 'İşlemlerim',
          selectedIcon: Icon(Icons.receipt_long_rounded),
        ),
      ]);
      _buildScreens.addAll([
        const ListTransactionPage(),
      ]);
    }

    _buildScreens.add(const ProfilePage());
    _destinations.add(
      const NavigationDestination(
        icon: Icon(Icons.person_outline),
        label: 'Profil',
        selectedIcon: Icon(Icons.person_rounded),
      ),
    );

    Future.microtask(
      () {
        String accountId = FirebaseAuth.instance.currentUser!.uid;
        context.read<ProductProvider>().loadListProduct();
        context.read<CartProvider>().getCart(accountId: accountId);
        if (flavor.flavor == Flavor.user) {
          context.read<WishlistProvider>().loadWishlist(accountId: accountId);
          context.read<TransactionProvider>().loadAccountTransaction();
        } else {
          context.read<TransactionProvider>().loadAllTransaction();
          context.read<AccountProvider>().getListAccount();
        }
        context.read<AccountProvider>().getProfile();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildScreens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        destinations: _destinations,
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
