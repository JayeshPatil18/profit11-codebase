import 'package:flutter/material.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity'),
        automaticallyImplyLeading: false,
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
                  _buildLikesTab(),
                  _buildCommentsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLikesTab() {
    return ListView.builder(
      itemCount: 5, // Demo count
      itemBuilder: (context, index) {
        return _buildActivityCard(
          username: "User $index",
          action: "liked your post",
          timeAgo: "${index + 1}h ago",
        );
      },
    );
  }

  Widget _buildCommentsTab() {
    return ListView.builder(
      itemCount: 5, // Demo count
      itemBuilder: (context, index) {
        return _buildActivityCard(
          username: "User $index",
          action: "commented on your post",
          timeAgo: "${index + 1}h ago",
        );
      },
    );
  }

  Widget _buildActivityCard({
    required String username,
    required String action,
    required String timeAgo,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.person),
        ),
        title: Text(username),
        subtitle: Text(action),
        trailing: Text(timeAgo),
        onTap: () {},
      ),
    );
  }
}