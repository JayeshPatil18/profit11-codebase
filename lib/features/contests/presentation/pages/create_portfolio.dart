import 'package:flutter/material.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity'),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: "Likes"),
                Tab(text: "Comments"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildListView("Likes"),
                  _buildListView("Comments"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(String type) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const CircleAvatar(
            child: Icon(Icons.person),
          ),
          title: Text("User $index"),
          subtitle: Text("Sample $type"),
        );
      },
    );
  }
}