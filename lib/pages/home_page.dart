import 'package:empire_ent/pages/generate_tab.dart';
import 'package:empire_ent/pages/overview_tab.dart';
import 'package:empire_ent/pages/scan_tab.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: TabBar(
            labelColor: Theme.of(context).colorScheme.inversePrimary,
            tabs: const [
              Tab(
                text: 'Generate',
              ),
              Tab(
                text: 'Scan',
              ),
              Tab(
                text: 'Overview',
              ),
            ],
          ),
          // title: ,
        ),
        body: const TabBarView(
          children: [
            GenerateTab(),
            ScanTab(),
            OverviewTab(),
          ],
        ),
      ),
    );
  }
}
