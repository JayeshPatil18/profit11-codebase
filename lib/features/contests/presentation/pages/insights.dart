import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../constants/color.dart';
import '../../../../main.dart';
import '../../data/models/leauge_item.dart';
import '../widgets/app_bar.dart';
import '../widgets/line.dart';
import '../widgets/live_card.dart';
import '../widgets/upcoming_card.dart';

class InsightsPage extends StatefulWidget {
  @override
  _InsightsPageState createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor60,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Header section with title and icons
              appBarBuildSection(context, 'Insights'),
              // Tab bar
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: TabBar(
                  labelColor: AppColors.primaryColor30,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: AppColors.secondaryColor10,
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(
                        width: 2.0, color: AppColors.secondaryColor10),
                    // Adjust the thickness of the underline
                    insets: EdgeInsets.symmetric(
                        horizontal:
                        20.0), // Adjust the insets to control the width of the indicator
                  ),
                  tabs: [
                    Tab(text: 'Blogs'),
                    Tab(text: 'Tweets'),
                  ],
                ),
              ),
              Line(height: 0.3),
              // Tab views
              Expanded(
                child: TabBarView(
                  children: [
                    _buildBlogTab(),
                    _buildTweetTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBlogTab() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _buildBlogCard(
          imageUrl: 'assets/stock_market.jpg', // Replace with actual image assets
          title: 'Top stock market trends to watch in 2025: insights for smart investors',
          description: 'Stock market is the dynamic landscape, continuously evolving with new ...',
          timeAgo: '2 days ago',
        ),
        SizedBox(height: 16),
        _buildBlogCard(
          imageUrl: 'assets/bull_market.jpg', // Replace with actual image assets
          title: 'Top stock market trends to watch in 2025: insights for smart investors',
          description: 'Stock market is the dynamic landscape, continuously evolving with new ...',
          timeAgo: '2 days ago',
        ),
      ],
    );
  }

  Widget _buildTweetTab() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _buildTweetCard(
          profileImageUrl: 'assets/profile.jpg',
          username: 'Username',
          timeAgo: '10 days ago',
          content: 'Hey everyone, I wanted to start a discussion on the current state of the stock market...',
          comments: 46,
          likes: 363,
        ),
        SizedBox(height: 16),
        _buildTweetCard(
          profileImageUrl: 'assets/profile.jpg',
          username: 'Username',
          timeAgo: '10 days ago',
          content: 'Hey everyone, I wanted to start a discussion on the current state of the stock market...',
          comments: 46,
          likes: 363,
        ),
      ],
    );
  }

  Widget _buildBlogCard({required String imageUrl, required String title, required String description, required String timeAgo}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network('https://media.istockphoto.com/id/887987150/photo/blogging-woman-reading-blog.jpg?s=612x612&w=0&k=20&c=7SScR_Y4n7U3k5kBviYm3VwEmW4vmbngDUa0we429GA=', height: 150, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  timeAgo,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTweetCard({
    required String profileImageUrl,
    required String username,
    required String timeAgo,
    required String content,
    required int comments,
    required int likes,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(profileImageUrl),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(username, style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(timeAgo, style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(content),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.comment, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text('$comments'),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.favorite, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text('$likes'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
