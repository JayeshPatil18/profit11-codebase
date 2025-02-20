class UserRank {
  final String id;
  final String username;
  final String phoneNo;
  final double walletBalance;
  final List<String> joinedContests;
  final String createdAt;
  final String updatedAt;
  final int skillScore;
  final int rank;
  final String profileUrl;

  UserRank({
    required this.id,
    required this.username,
    required this.phoneNo,
    required this.walletBalance,
    required this.joinedContests,
    required this.createdAt,
    required this.updatedAt,
    required this.skillScore,
    required this.rank,
    required this.profileUrl,
  });

  factory UserRank.fromFirestore(Map<String, dynamic> json) {
    String id = json['id'] ?? '';

    return UserRank(
      id: id,
      username: json['username'] ?? 'Unknown',
      phoneNo: json['phoneNo'] ?? 'No PhoneNo',
      walletBalance: (json['walletBalance'] ?? 0.0).toDouble(),
      joinedContests: json['joinedContests'] != null
          ? List<String>.from(json['joinedContests'])
          : [],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      skillScore: json['skillScore'] ?? 0,
      rank: json['rank'] ?? 0,
      profileUrl: json['profileUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'phoneNo': phoneNo,
      'walletBalance': walletBalance,
      'joinedContests': joinedContests,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'skillScore': skillScore,
      'rank': rank,
      'profileUrl': profileUrl,
    };
  }

  // Add a copyWith method to update the ID or any other field
  UserRank copyWith({
    String? id,
    String? username,
    String? phoneNo,
    double? walletBalance,
    List<String>? joinedContests,
    String? createdAt,
    String? updatedAt,
    int? skillScore,
    int? rank,
    String? profileUrl,
  }) {
    return UserRank(
      id: id ?? this.id,
      username: username ?? this.username,
      phoneNo: phoneNo ?? this.phoneNo,
      walletBalance: walletBalance ?? this.walletBalance,
      joinedContests: joinedContests ?? this.joinedContests,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      skillScore: skillScore ?? this.skillScore,
      rank: rank ?? this.rank,
      profileUrl: profileUrl ?? this.profileUrl,
    );
  }
}
