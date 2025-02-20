class UserItem {
  final String userId;
  final String fullName;
  final String username;
  final String email;
  final String phoneNo;
  final String profileUrl;
  final double walletBalance;
  final double netWorth;
  final int rank;
  final double skillScore;
  final String gender;
  final List<Map<String, dynamic>> joinedContests;
  final List<String> achievements; // New field
  final String status;
  final String createdAt;
  final String updatedAt;

  UserItem({
    required this.userId,
    required this.fullName,
    required this.username,
    required this.email,
    required this.phoneNo,
    required this.profileUrl,
    required this.walletBalance,
    required this.netWorth,
    required this.rank,
    required this.skillScore,
    required this.gender,
    required this.joinedContests,
    required this.achievements, // New field in constructor
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserItem.fromFirestore(Map<String, dynamic> data) {
    return UserItem(
      userId: data['id'] ?? '',
      fullName: data['fullName'] ?? '',
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      phoneNo: data['phoneNo'] ?? '',
      profileUrl: data['profileUrl'] ?? '',
      walletBalance: (data['walletBalance'] ?? 0.0).toDouble(),
      netWorth: (data['netWorth'] ?? 0.0).toDouble(),
      rank: data['rank'] ?? 0,
      skillScore: (data['skillScore'] ?? 0.0).toDouble(),
      gender: data['gender'] ?? '',
      joinedContests: List<Map<String, dynamic>>.from(
        (data['joinedContests'] ?? []).map((contest) => {
          'leagueId': contest['leagueId'] ?? '',
          'prize': (contest['prize'] ?? 0.0).toDouble(),
          'rank': (contest['rank'] ?? 0.0).toDouble(),
        }),
      ),
      achievements: List<String>.from(data['achievements'] ?? []), // New field
      status: data['status'] ?? '',
      createdAt: data['createdAt'] ?? '',
      updatedAt: data['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': userId,
      'fullName': fullName,
      'username': username,
      'email': email,
      'phoneNo': phoneNo,
      'profileUrl': profileUrl,
      'walletBalance': walletBalance,
      'netWorth': netWorth,
      'rank': rank,
      'skillScore': skillScore,
      'gender': gender,
      'joinedContests': joinedContests.map((contest) => {
        'leagueId': contest['leagueId'],
        'prize': contest['prize'],
        'rank': contest['rank'],
      }).toList(),
      'achievements': achievements, // New field
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  UserItem copyWith({
    String? userId,
    String? fullName,
    String? username,
    String? email,
    String? phoneNo,
    String? profileUrl,
    double? walletBalance,
    double? netWorth,
    int? rank,
    double? skillScore,
    String? gender,
    List<Map<String, dynamic>>? joinedContests,
    List<String>? achievements, // New field
    String? status,
    String? createdAt,
    String? updatedAt,
  }) {
    return UserItem(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      email: email ?? this.email,
      phoneNo: phoneNo ?? this.phoneNo,
      profileUrl: profileUrl ?? this.profileUrl,
      walletBalance: walletBalance ?? this.walletBalance,
      netWorth: netWorth ?? this.netWorth,
      rank: rank ?? this.rank,
      skillScore: skillScore ?? this.skillScore,
      gender: gender ?? this.gender,
      joinedContests: joinedContests ?? this.joinedContests,
      achievements: achievements ?? this.achievements, // New field
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
