import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/color.dart';

class NewsCard extends StatelessWidget {
  final String imageUrl;
  final String headline;
  final String summary;
  final String url;

  NewsCard({
    required this.imageUrl,
    required this.headline,
    required this.summary,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.lightBlackColor.withOpacity(0.2),
          width: 0.9,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          _launchURL(context, url); // You can implement this to launch the URL
        },
        child: Padding(
          padding: EdgeInsets.only(top: 16.0, bottom: 16.0, right: 10, left: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image or Icon
              Image.network(
                imageUrl,
                width: 80,
                height: 100,
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.image),
              ),
              SizedBox(width: 16),
              // Text Content (Headline and Summary)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      headline,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Text(
                      summary,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL(BuildContext context, String url) async {
    // Show a confirmation dialog before launching
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Open URL'),
        content: Text('Do you want to open the following URL?\n\n$url'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close the dialog
              if (await canLaunch(url)) {
                await launch(url); // Launch the URL
              } else {
                // Show an error dialog if URL cannot be launched
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Invalid URL'),
                    content: Text('Could not open the URL. Please try again later.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            },
            child: const Text('Open'),
          ),
        ],
      ),
    );
  }
}
