import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalalstreetfantasy/features/contests/domain/entities/notification.dart';
import 'package:dalalstreetfantasy/utils/dropdown_items.dart';

import '../../../../constants/color.dart'; // Update with your app's color file
import '../../../../constants/elevation.dart';
import '../../../../main.dart';
import '../../../../utils/fonts.dart';
import '../../../authentication/data/repositories/users_repo.dart';
import '../../domain/entities/user.dart';
import '../widgets/dialog_box.dart';
import '../widgets/notification_model.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor60, // Use your app's background color
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(color: AppColors.backgroundColor60), // Match your app's theme
        child: SafeArea(
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back_ios,
                              color: AppColors.primaryColor30, // Update to match your theme
                              size: 20),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Notifications',
                          style: MainFonts.pageTitleText(
                              fontSize: 22,
                              weight: FontWeight.w600, // Use a bolder weight for emphasis
                              color: AppColors.primaryColor30), // Update to match your theme
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomDialogBox(
                              title: Text(
                                'Clear all',
                                style: TextStyle(fontSize: 18),
                              ),
                              content: Text(
                                'All notifications will be removed.',
                                textAlign: TextAlign.center,
                              ),
                              textButton1: TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  UsersRepo repoObj = UsersRepo();
                                  repoObj.removeAllNotifications();
                                  Navigator.pop(context, 'OK');
                                },
                              ),
                              textButton2: TextButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.pop(context, 'Cancel');
                                },
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        child: Text(
                          'Clear All',
                          style: MainFonts.filterText(color: AppColors.primaryColor30), // Match your theme
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: UsersRepo.userFireInstance.snapshots(),
                    builder: (context, snapshot) {
                      final documents;
                      documents = snapshot.data?.docs;
                      List<Map<String, dynamic>> usersData = [];
                      User? user;

                      if (documents != null && documents.isNotEmpty) {
                        final firstDocument = documents[0];

                        if (firstDocument != null &&
                            firstDocument.data() != null &&
                            firstDocument.data().containsKey('userslist')) {
                          usersData = List<Map<String, dynamic>>.from(
                              firstDocument.data()['userslist']);

                          List<User> usersList =
                          usersData.map((userData) => User.fromMap(userData)).toList();

                          List<User> users =
                          usersList.where((user) => user.uid == MyApp.userId).toList();
                          user = users.first;

                          List<MyNotification>? notifications = List.from(user.notifications!.reversed);

                          if(notifications != null && notifications.isNotEmpty){

                            return ListView.builder(
                              itemCount: notifications.length,
                              itemBuilder: (context, value) {
                                MyNotification notification = notifications[value];

                                return NotificationModel(message: notification.message, msgType: notification.msgType, ago: notification.date, postId: notification.postId);
                              },
                            );
                          }
                        }
                      }
                      return Center(child: Text('No Notification', style: MainFonts.filterText(color: AppColors.lightTextColor)));
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
