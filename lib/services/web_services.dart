import 'package:newsapp/constant.dart';
import 'package:newsapp/model/newsarticle.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<NewsArticle>> fetchNewsArticles({String query = ''}) async {
  late http.Response response;
  if (query.isEmpty) {
    response = await http.get(
      Uri.parse(Constants.TOP_HEADLINES_URL),
    );
  } else {
    response = await http.get(
      Uri.parse(Constants.headlinesFor(query)),
    );
  }

  if (response.statusCode == 200) {
    List articlesJson = json.decode(response.body)['articles'];
    return articlesJson.map((article) => NewsArticle.fromMap(article)).toList();
  } else {
    throw Exception('Failed to load news articles');
  }
}
