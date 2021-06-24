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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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

  // void _incrementCounter() {
  // setState(() {
  // // This call to setState tells the Flutter framework that something has
  // // changed in this State, which causes it to rerun the build method below
  // // so that the display can reflect the updated values. If we changed
  // // _counter without calling setState(), then the build method would not be
  // // called again, and so nothing would appear to happen.
  // _counter++;
  // });
  // }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<List<Post>>(
              future: futurePosts,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  var cards = <Widget>[];
                  for (var posts in snapshot.data!) {
                    cards.add(buildPostCards(posts));
                  }

                  return Column(children: cards);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                // By default, show a loading spinner.
                return CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      // // onPressed: _incrementCounter,
      // tooltip: 'Increment',
      // child: Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget buildPostCards(Post posts) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const ListTile(
            leading: Icon(Icons.album),
            title: Text('The Enchanted Nightingale'),
            subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                child: const Text('BUY TICKETS'),
                onPressed: () {/* ... */},
              ),
              const SizedBox(width: 8),
              TextButton(
                child: const Text('LISTEN'),
                onPressed: () {/* ... */},
              ),
              const SizedBox(width: 8),
            ],
          ),
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
