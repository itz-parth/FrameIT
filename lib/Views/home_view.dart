import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<dynamic> data = [];
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    debugPrint("Fetching data...");
    const url = 'https://pixabay.com/api/?key=20212026-534ffc9d2c7c7400c6364783a&image_type=photo';
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        setState(() {
          data = json['hits'];
          isLoading = false; // Set loading to false after data is fetched
        });
        debugPrint("Fetch complete");
      } else {
        setState(() {
          isLoading = false; // Stop loading even if the fetch fails
        });
        debugPrint("Failed to fetch data: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return _home_view();
  }

  Scaffold _home_view() {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'FrameIt',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold
                ),
              ),
            Text(
              'Frame The World Of Lens',
              style: TextStyle(
                fontSize: 13,
                color: Color.fromARGB(135, 0, 0, 0),
              ),
            )    
          ],
        ),
      ),
      body: Column(
        children: [
          Divider(
            thickness: 3,
            height: 2,
            indent: 15,
            endIndent: 15,
          ),
          _buildImageGrid(),
        ],
      ),
      bottomNavigationBar: _buildNavbar(),
    );
  }

  Scaffold _search_view() {
    return Scaffold(
    appBar: AppBar(
      toolbarHeight: 40,
      title: Center(
        child: Text(
          'SearchIT',
          style: TextStyle(
            fontSize: 20
          ),
          )
        ),
    ),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Divider(
          height: 2,
          thickness: 3,
          indent: 15,
          endIndent: 15,
        ),
        _buildSearchField(),
        isLoading ? _buildLoadingIndicator() : _buildImageGrid(),
      ],
    ),
    bottomNavigationBar: _buildNavbar(),
  );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
          ),
          prefixIcon: Icon(Icons.search),
          hintText: 'Search for photos...',
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Expanded(
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildImageGrid() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          children: List.generate(data.length, (index) {
            String imgUrl = data[index]['webformatURL'];
            return Padding(
              padding: const EdgeInsets.all(6),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imgUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(child: Icon(Icons.error)); // Show error icon
                  },
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildNavbar() {
    return CurvedNavigationBar(
      backgroundColor: const Color.fromARGB(0, 0, 0, 0),
      color: Colors.blue,
      height: 50,
      items: const [
        Icon(Icons.home),
        Icon(Icons.search),
        Icon(Icons.person),
      ],
    );
  }
}