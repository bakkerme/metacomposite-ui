import 'package:metacomposite_ui/types.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

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
