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

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    debugPrint("Fetching data...");
    const url = 'https://pixabay.com/api/?key=20212026-534ffc9d2c7c7400c6364783a&image_type=photo';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final body = response.body;
      final json = jsonDecode(body);
      setState(() {
        data = json['hits']; 
      });
      debugPrint("Fetch complete");
    } else {
      debugPrint("Failed to fetch data: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: App_Bar(),
      body: body_data(),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        color: Colors.blue,
        height: 50,
        items: const [
        Icon(
          Icons.home
        ),
        Icon(
          Icons.search
        ),
        Icon(
          Icons.person
        ),
        
      ]),
    );
  }


  Column body_data() {
    return Column(
      children: [
        const Divider(
            height: 1,
            color: Color.fromARGB(220, 0, 0, 0),
            indent: 15,
            endIndent: 100,
          ),
        Expanded(
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
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  AppBar App_Bar() {
    return AppBar(
      // backgroundColor: Colors.blue,
      toolbarHeight: 90,
      title: const Padding(
        padding: EdgeInsets.only(left: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'FrameIt',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Frame The World Through Lens',
              style: TextStyle(
                fontSize: 15,
                color: Color.fromARGB(150, 0, 0, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}