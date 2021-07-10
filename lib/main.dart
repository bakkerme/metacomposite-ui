import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

import 'package:metacomposite_ui/types.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // late Future<List<Group>> futureGroups;
  // late Future<List<Feed>> futureFeeds;
  late Future<List<Post>> futurePosts;

  @override
  void initState() {
    super.initState();
    // futureGroups = fetchGroups();
    // futureFeeds = fetchFeeds();
    futurePosts = fetchAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(),
      body: Center(
        child: FutureBuilder<List<Post>>(
          future: futurePosts,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              var cards = <Widget>[];
              for (var post in snapshot.data!) {
                cards.add(buildPostCards(post));
              }

              return GridView.extent(
                maxCrossAxisExtent: 344,
                children: cards,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: .8,
                padding: const EdgeInsets.all(15),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Widget buildPostCards(Post post) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text(post.title),
            subtitle: Text(post.feedID),
          ),
          Flexible(
            child: Image(
              image: NetworkImage(post.imageURL),
              width: 344,
              height: 194,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                post.description,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                ),
              ))
        ],
      ),
    );
  }
}

Future<List<Group>> fetchGroups() async {
  final response = await http.get(Uri.parse('http://localhost:3030/groups'));

  if (response.statusCode == 200) {
    List decoded = jsonDecode(response.body);
    List<Group> groups = <Group>[];
    for (var group in decoded) {
      groups.add(Group.fromJson(group));
    }

    return groups;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load groups');
  }
}

Future<List<Feed>> fetchFeeds() async {
  final response = await http.get(Uri.parse('http://localhost:3030/feeds'));

  if (response.statusCode == 200) {
    List decoded = jsonDecode(response.body);
    List<Feed> feeds = <Feed>[];
    for (var feed in decoded) {
      feeds.add(Feed.fromJson(feed));
    }

    return feeds;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load feeds');
  }
}

Future<List<Post>> fetchAllPosts() async {
  final response =
      await http.get(Uri.parse('http://localhost:3030/feeds/posts'));

  if (response.statusCode == 200) {
    Map<String, dynamic> decoded = jsonDecode(response.body);

    if (decoded['posts'] == Null) {
      throw Exception('Failed to load feeds');
    }

    List postList = decoded['posts'];
    List<Post> posts = <Post>[];
    for (var post in postList) {
      posts.add(Post.fromJson(post));
    }

    return posts;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load feeds');
  }
}
