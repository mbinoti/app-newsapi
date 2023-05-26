class Constants {
  static String TOP_HEADLINES_URL =
      "https://newsapi.org/v2/top-headlines?country=us&apiKey=0cf790498275413a9247f8b94b3843fd";

  static String headlinesFor(String keyword) {
    return "https://newsapi.org/v2/everything?q=$keyword&apiKey=0cf790498275413a9247f8b94b3843fd";
  }
}
