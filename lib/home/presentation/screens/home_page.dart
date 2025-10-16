// ignore_for_file: unused_import, unused_field, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_testing_lab/home/data/tabs_and_views.dart';
import 'package:flutter_testing_lab/home/presentation/widgets/nav_bar_widget.dart';
import 'package:flutter_testing_lab/home/presentation/widgets/warning_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController; 
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flutter Testing Lab',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        bottom: TabBar(
          controller: _tabController,
          tabs: tabs,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey.shade50, Colors.grey.shade100],
          ),
        ),
        child: Column(
          children: [
            // WarningWidget(currentIndex: _currentIndex),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: tabViews.map((widget) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: widget,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: NavBarWidget(),
    );
  }
}
