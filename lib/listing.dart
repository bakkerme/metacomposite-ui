import 'package:flutter/material.dart';

import 'package:metacomposite_ui/types.dart';
import 'package:metacomposite_ui/api.dart';

class Listing extends StatefulWidget {
  Listing({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _ListingState createState() => _ListingState();
}

class _ListingState extends State<Listing> {
  late Future<List<Group>> futureGroups;
  // late Future<List<Feed>> futureFeeds;
  late Future<List<Post>> futurePosts;

  @override
  void initState() {
    super.initState();
    futureGroups = fetchGroups();
    // futureFeeds = fetchFeeds();
    futurePosts = fetchAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
          child: FutureBuilder<List<Group>>(
              future: futureGroups,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  var groups = <Widget>[];
                  for (var group in snapshot.data!) {
                    groups.add(_buildGroupListItem(group));
                  }

                  return ListView(
                    padding: const EdgeInsets.all(8),
                    children: groups,
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                // By default, show a loading spinner.
                return CircularProgressIndicator();
              })),
      body: Center(
        child: FutureBuilder<List<Post>>(
          future: futurePosts,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              var cards = <Widget>[];
              for (var post in snapshot.data!) {
                cards.add(_buildPostCards(post));
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

  Widget _buildPostCards(Post post) {
    var items = <Widget>[
      ListTile(
        title: Text(post.title),
        subtitle: Text(post.feedID),
      ),
    ];

    if (post.imageURL != null) {
      items.add(Flexible(
          child: Image(
        image: NetworkImage(post.imageURL!),
        width: 344,
        height: 194,
        fit: BoxFit.cover,
      )));
    }

    items.add(Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          post.description,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
          ),
        )));

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: items,
      ),
    );
  }

  Widget _buildGroupListItem(Group group) {
    return ListTile(
      title: Text(
        group.name,
      ),
    );
  }
}
