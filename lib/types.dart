class Post {
  final String title;
  final String description;
  final String content;
  final String link;
  final String? imageURL;
  final String feedID;

  Post({
    required this.title,
    required this.description,
    required this.content,
    required this.link,
    required this.imageURL,
    required this.feedID,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        title: json['title'],
        description: json['description'],
        content: json['content'],
        link: json['link'],
        imageURL: json['imageURL'],
        feedID: json['feedID']);
  }
}

class Feed {
  final String id;
  final String name;
  final List<dynamic> groupID;
  final String description;
  final String uri;
  final String type;

  Feed({
    required this.id,
    required this.name,
    required this.groupID,
    required this.description,
    required this.uri,
    required this.type,
  });

  factory Feed.fromJson(Map<String, dynamic> json) {
    return Feed(
      id: json['ID'],
      name: json['name'],
      groupID: json['groupID'],
      description: json['description'],
      uri: json['URI'],
      type: json['type'],
    );
  }
}

class Group {
  final String id;
  final String name;

  Group({
    required this.id,
    required this.name,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['ID'],
      name: json['name'],
    );
  }
}
