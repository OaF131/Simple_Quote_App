class Quote {
  final String text;
  final String author;

  Quote({required this.text, required this.author});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      text: json['quoteText'] ?? "No quote found",
      author: json['quoteAuthor'] ?? "Unknown",
    );
  }
}