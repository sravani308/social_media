import 'package:flutter/material.dart';

void main() {
  runApp(const SocialMediaApp());
}

class SocialMediaApp extends StatelessWidget {
  const SocialMediaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Social Media App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class Post {
  String userName;
  String content;
  int likes;
  bool liked;

  Post({
    required this.userName,
    required this.content,
    this.likes = 0,
    this.liked = false,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController postController = TextEditingController();

  final List<Post> posts = [
    Post(
      userName: 'Sravani',
      content: 'Hello everyone! Welcome to my Social Media App.',
      likes: 5,
    ),
    Post(
      userName: 'Anusha',
      content: 'Learning Flutter is interesting and fun!',
      likes: 3,
    ),
  ];

  final Set<String> followingUsers = {};

  void addPost() {
    if (postController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      posts.insert(
        0,
        Post(
          userName: 'Sravani',
          content: postController.text.trim(),
        ),
      );

      postController.clear();
    });

    Navigator.pop(context);
  }

  void showAddPostDialog() {
    postController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create New Post'),
          content: TextField(
            controller: postController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'What is on your mind?',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: addPost,
              child: const Text('Post'),
            ),
          ],
        );
      },
    );
  }

  void toggleLike(Post post) {
    setState(() {
      if (post.liked) {
        post.likes--;
        post.liked = false;
      } else {
        post.likes++;
        post.liked = true;
      }
    });
  }

  void toggleFollow(String userName) {
    setState(() {
      if (followingUsers.contains(userName)) {
        followingUsers.remove(userName);
      } else {
        followingUsers.add(userName);
      }
    });
  }

  @override
  void dispose() {
    postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Media App'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notifications opened'),
                ),
              );
            },
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    child: Icon(Icons.person),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome, Sravani',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${followingUsers.length} Following',
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: showAddPostDialog,
                    child: const Text('Post'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Latest Posts',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...posts.map(
            (post) {
              final bool isFollowing =
                  followingUsers.contains(post.userName);

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              post.userName,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              toggleFollow(post.userName);
                            },
                            child: Text(
                              isFollowing ? 'Following' : 'Follow',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        post.content,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Divider(),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              toggleLike(post);
                            },
                            icon: Icon(
                              post.liked
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: post.liked
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                          ),
                          Text('${post.likes} Likes'),
                          const SizedBox(width: 20),
                          IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Comment section opened'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.comment),
                          ),
                          const Text('Comment'),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Post shared'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.share),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddPostDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}