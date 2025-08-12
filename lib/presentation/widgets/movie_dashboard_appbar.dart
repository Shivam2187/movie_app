import 'package:flutter/material.dart';

AppBar movieDashboardAppBar({
  required String title,
  required BuildContext context,
  List<Widget>? tabsName,
  TabController? tabController,
  double? fontSize,
  bool isLogoutButtonVisible = false,
}) {
  return AppBar(
    title: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: fontSize ?? 24,
        ),
      ),
    ),
    centerTitle: false,
    backgroundColor: Colors.white,
    elevation: 12,
    toolbarHeight: 24,
    bottom: tabController == null
        ? null
        : TabBar(
            //indicatorSize: TabBarIndicatorSize.tab,
            controller: tabController,
            isScrollable: false,
            tabAlignment: TabAlignment.fill,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey.shade700,
            indicatorColor: Colors.blue,
            indicatorWeight: 8.0,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 16.0,
            ),
            tabs: tabsName ?? [],
          ),
  );
}
