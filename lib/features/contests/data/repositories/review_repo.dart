import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dalalstreetfantasy/features/authentication/data/repositories/users_repo.dart';
import 'package:dalalstreetfantasy/utils/methods.dart';

import '../../domain/entities/upload_review.dart';
import 'package:path/path.dart' as p;

class ReviewRepo {
  final _db = FirebaseFirestore.instance;
  static final reviewFireInstance = FirebaseFirestore.instance
                            .collection('posts');

  Future<bool> checkExist(String docID) async {
    bool exist = false;
    try {
      await _db.doc("posts/$docID").get().then((doc) {
        exist = doc.exists;
      });
      return exist;
    } catch (e) {
      // If any error
      return false;
    }
  }

  
  Future<bool> uploadReview(UploadReviewModel uploadReviewModel, File? imageSelected) async {

    try {
      final reference = _db.collection('posts');

      // Next Post Id
      String postId = reference.doc().id;

      List<String>? details = await getLoginDetails();
      int userId = -1;
      String username = '';
      String gender = '';
      String userProfileUrl = '';
      final DateTime now = DateTime.now();
      String date = now.toString();

      if (details != null) {
        userId = int.parse(details[0]);
        username = details[1].toString();
      }

      UsersRepo usersRepo = UsersRepo();
      List<Map<String, dynamic>> data = await usersRepo.getUserCredentials();

      for (var user in data) {
        if (user['userid'] == userId) {
          userProfileUrl = user['profileurl'];
          gender = user['gender'];
        }
      }

      // Upload Image
      String imageUrl = imageSelected == null ? 'null' : await _uploadFile(postId, imageSelected);

      uploadReviewModel.date = date;
      uploadReviewModel.mediaUrl = imageUrl;
      uploadReviewModel.userProfileUrl = userProfileUrl;
      uploadReviewModel.gender = gender;
      uploadReviewModel.postId = postId;
      uploadReviewModel.userId = userId;
      uploadReviewModel.username = username;

      final snapshot = reference.doc(postId);
      await snapshot.set(uploadReviewModel.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String> _uploadFile(String postId, File mediaFile) async {
    try {
      final storage = FirebaseStorage.instance;
      // add this the get the extension
      final fileExtension = p.extension(mediaFile.path);

      // append the extension to the child name
      final ref = storage.ref().child("post_medias").child("$postId$fileExtension");
      final uploadTask = ref.putFile(mediaFile);

      final snapshot = await uploadTask.whenComplete(() {});

      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return 'null';
    }
  }
}
