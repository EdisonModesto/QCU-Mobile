import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:qcu/cosntants/colors.dart';
import 'package:qcu/features/Admins/dashboard/aDashboardView.dart';
import 'package:qcu/features/Sellers/orders/sOrdersView.dart';
import 'package:qcu/features/Sellers/profile/sProfileView.dart';
import 'package:qcu/features/Sellers/store/sStoreView.dart';
import 'package:qcu/services/FirestoreService.dart';

import '../services/borzo/BorzoService.dart';
import 'Admins/accounts/aAccountsView.dart';
import 'Sellers/notifications/sNotifView.dart';
import 'Users/home/uHomeView.dart';
import 'Users/mall/uMallView.dart';
import 'Users/notifications/uNotifView.dart';
import 'Users/profile/uProfileView.dart';
import 'ViewModels/AuthViewModel.dart';
import 'ViewModels/UserViewModel.dart';

class AppNavBar extends ConsumerStatefulWidget {
  const AppNavBar({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AppNavBarState();
}

class _AppNavBarState extends ConsumerState<AppNavBar>{
  PersistentTabController _controller = PersistentTabController(initialIndex: 0);



  List<Widget> _userScreens() {
    return [
      const HomeView(),
      const MallView(),
      const NotifView(),
      const ProfileView()
    ];
  }

  List<Widget> _sellerScreens() {
    return [
      const SStoreView(),
      const SOrdersView(),
      const SNotifView(),
      const SProfileView()
    ];
  }

  List<Widget> _adminScreens() {
    return [
      const ADashboardView(),
      const AAccountsView(),
    /*  const NotifView(),
      const ProfileView()*/
    ];
  }


  List<PersistentBottomNavBarItem> _userItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.home),
        title: ("Home"),
        activeColorPrimary: AppColors().primary,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.bag),
        title: ("Mall"),
        activeColorPrimary: AppColors().primary,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.bell),
        title: ("Notification"),
        activeColorPrimary: AppColors().primary,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.person),
        title: ("Profile"),
        activeColorPrimary: AppColors().primary,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  List<PersistentBottomNavBarItem> _sellerItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.store_mall_directory_outlined),
        title: ("Your Store"),
        activeColorPrimary: AppColors().primary,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.local_shipping_outlined),
        title: ("Orders"),
        activeColorPrimary: AppColors().primary,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.bell),
        title: ("Notification"),
        activeColorPrimary: AppColors().primary,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.person),
        title: ("Profile"),
        activeColorPrimary: AppColors().primary,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  List<PersistentBottomNavBarItem> _adminItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.dashboard),
        title: ("Dashboard"),
        activeColorPrimary: AppColors().primary,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.person_2),
        title: ("Accounts"),
        activeColorPrimary: AppColors().primary,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
     /* PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.bell),
        title: ("Notification"),
        activeColorPrimary: AppColors().primary,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.person),
        title: ("Profile"),
        activeColorPrimary: AppColors().primary,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),*/
    ];
  }


  @override
  void initState() {
   // BorzoService().makeRequest();
    print("Borzo");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var authState = ref.watch(authStateProvider);
    ref.watch(userProvider);

    return authState.when(
      data: (data){
        if(data != null){
          return FutureBuilder(
              future:  FirestoreService().checkUserType(data.uid),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  return PersistentTabView(
                    context,
                    controller: _controller,
                    screens: snapshot.data == "Buyer" ? _userScreens() : snapshot.data == "Seller" ? _sellerScreens() : _adminScreens(),
                    items: snapshot.data == "Buyer" ? _userItems() : snapshot.data == "Seller" ? _sellerItems() : _adminItems(),
                    confineInSafeArea: true,
                    backgroundColor: Colors.white, // Default is Colors.white.
                    handleAndroidBackButtonPress: true, // Default is true.
                    resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
                    stateManagement: true, // Default is true.
                    hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
                    decoration: NavBarDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      colorBehindNavBar: Colors.white,
                    ),
                    popAllScreensOnTapOfSelectedTab: true,
                    popActionScreens: PopActionScreensType.all,
                    itemAnimationProperties: const ItemAnimationProperties( // Navigation Bar's items animation properties.
                      duration: Duration(milliseconds: 200),
                      curve: Curves.ease,
                    ),
                    screenTransitionAnimation: const ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
                      animateTabTransition: true,
                      curve: Curves.ease,
                      duration: Duration(milliseconds: 200),
                    ),
                    navBarStyle: NavBarStyle.style2, // Choose the nav bar style with this property.
                  );
                }
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
          );
        }
        return PersistentTabView(
          context,
          controller: _controller,
          screens: _userScreens(),
          items: _userItems(),
          confineInSafeArea: true,
          backgroundColor: Colors.white, // Default is Colors.white.
          handleAndroidBackButtonPress: true, // Default is true.
          resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
          stateManagement: true, // Default is true.
          hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(10.0),
            colorBehindNavBar: Colors.white,
          ),
          popAllScreensOnTapOfSelectedTab: true,
          popActionScreens: PopActionScreensType.all,
          itemAnimationProperties: const ItemAnimationProperties( // Navigation Bar's items animation properties.
            duration: Duration(milliseconds: 200),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: const ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
            animateTabTransition: true,
            curve: Curves.ease,
            duration: Duration(milliseconds: 200),
          ),
          navBarStyle: NavBarStyle.style2, // Choose the nav bar style with this property.
        );
      },
      error: (error, stack){
        return const Center(child: Text("Error"));
      },
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
