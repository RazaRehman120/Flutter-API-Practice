import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_api_practice/Models/PostsModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<PostsModel>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = getPostApi();
  }

  Future<List<PostsModel>> getPostApi() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((i) => PostsModel.fromJson(i as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('Api course'))),
      body: FutureBuilder<List<PostsModel>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final postList = snapshot.data!;
          return ListView.builder(
            itemCount: postList.length,
            itemBuilder: (context, index) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Title',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      Text(postList[index].title),
                      const SizedBox(height: 5),
                      const Text('Description',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      Text(postList[index].body),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
