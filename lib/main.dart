import 'package:flutter/material.dart';
import 'package:newsapp/services/web_services.dart';

import 'model/newsarticle.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<NewsArticle>> futureArticles;
  ValueNotifier<String> searchQueryNotifier = ValueNotifier<String>('');
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureArticles = fetchNewsArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              onSubmitted: (value) {
                searchQueryNotifier.value = value;
              },
              decoration: InputDecoration(
                labelText: "Search",
                // icon: const Padding(
                //   padding: EdgeInsets.all(8.0),
                //   child: Icon(Icons.search),
                // ),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                    onPressed: () {
                      searchQueryNotifier.value = '';
                      _controller.clear();
                    },
                    icon: const Icon(Icons.clear)),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: searchQueryNotifier,
              builder: (context, String value, _) {
                return FutureBuilder<List<NewsArticle>>(
                  future: fetchNewsArticles(query: value),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        return const Text('No results found');
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: SizedBox(
                                width: 100,
                                height: 100,
                                child: snapshot.data![index].urlToImage == ''
                                    ? Image.asset(
                                        "images/news-placeholder.jpeg")
                                    : Image.network(
                                        snapshot.data![index].urlToImage),
                              ),
                              title: Text(snapshot.data![index].title),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return DetailScreen(
                                          article: snapshot.data![index]);
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return const Center(
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final NewsArticle article;

  DetailScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            if (article.urlToImage != '') Image.network(article.urlToImage),
            Text(article.title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(article.content ?? ''),
          ],
        ),
      ),
    );
  }
}
