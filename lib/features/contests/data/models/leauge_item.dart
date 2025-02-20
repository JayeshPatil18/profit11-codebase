class LeagueItem {
  final String leagueId;
  final String contestId;
  final double entryFee;
  final double totalPrizePool;
  final double firstPrize;
  final int maxParticipants;
  final int currentParticipants;
  final List<String> usersJoined;
  final List<Map<String, dynamic>> winnings;
  final String createdAt;
  final String updatedAt;
  final String startTime;
  final String endTime;
  final String logoUrl;
  final String stockListType;
  final int totalWeightage;
  final double totalCoinsGiven;
  final List<Map<String, dynamic>> leagueResult;

  LeagueItem({
    required this.leagueId,
    required this.contestId,
    required this.entryFee,
    required this.totalPrizePool,
    required this.firstPrize,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.usersJoined,
    required this.winnings,
    required this.createdAt,
    required this.updatedAt,
    required this.startTime,
    required this.endTime,
    required this.logoUrl,
    required this.stockListType,
    required this.totalWeightage,
    required this.totalCoinsGiven,
    required this.leagueResult,
  });

  factory LeagueItem.fromFirestore(Map<String, dynamic> json) {
    return LeagueItem(
      leagueId: json['id'] ?? '',
      contestId: json['contestid'] ?? '',
      entryFee: (json['fee'] ?? 0.0).toDouble(),
      totalPrizePool: (json['prizePool'] ?? 0.0).toDouble(),
      firstPrize: (json['prize'] ?? 0.0).toDouble(),
      maxParticipants: (json['participants'] ?? 0).toInt(),
      currentParticipants: json['usersJoined'] != null ? (json['usersJoined'] as List).length : 0,
      usersJoined: json['joined'] != null ? List<String>.from(json['usersJoined']) : [],
      winnings: json['winnings'] != null ? List<Map<String, dynamic>>.from(json['winnings']) : [],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      startTime: json['start'] ?? '',
      endTime: json['end'] ?? '',
      logoUrl: json['logoUrl'] ?? '',
      stockListType: json['stockType'] ?? '',
      totalWeightage: (json['weightage'] ?? 0).toInt(),
      totalCoinsGiven: (json['coinsGiven'] ?? 0.0).toDouble(),
      leagueResult: json['leagueResult'] != null ? List<Map<String, dynamic>>.from(json['leagueResult']) : [],
    );
  }
}

/// Method to calculate and return user rank and prize from input leagueResult
Map<String, dynamic> getUserResult(List<Map<String, dynamic>> leagueResult, String userId) {
  final userResult = leagueResult.firstWhere(
        (result) => result['userId'] == userId,
    orElse: () => {},
  );
}