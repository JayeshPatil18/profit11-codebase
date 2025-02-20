class News {
  final String headline;
  final String summary;
  final String source;
  final String url;
  final String image;
  final DateTime datetime;

  News({
    required this.headline,
    required this.summary,
    required this.source,
    required this.url,
    required this.image,
    required this.datetime,
  });

  /// Factory method to create a `News` object from JSON
  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      headline: json['headline'] ?? '',
      summary: json['summary'] ?? '',
      source: json['source'] ?? '',
      url: json['url'] ?? '',
      image: json['image'] ?? '',
      datetime: DateTime.fromMillisecondsSinceEpoch(json['datetime'] * 1000),
    );
  }
}
