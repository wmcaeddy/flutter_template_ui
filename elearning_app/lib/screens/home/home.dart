import 'package:elearning_app/constants/colors.dart';
import 'package:elearning_app/screens/home/widgets/active_course.dart';
import 'package:elearning_app/screens/home/widgets/emoji_text.dart';
import 'package:elearning_app/screens/home/widgets/features_course.dart';
import 'package:elearning_app/screens/home/widgets/search_input.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:dio/dio.dart';

final String host = Platform.environment['SERVER_URL'] ?? '192.168.2.152';
final String port = Platform.environment['PORT'] ?? '8080';
final String scheme = Platform.environment['SERVER_SCHEME'] ?? 'http';

final Dio _dio = Dio(BaseOptions(baseUrl: 'http://192.168.2.152:8080/'));

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<int>? _codeFuture;

  @override
  void initState() {
    super.initState();
    _codeFuture = _fetchCode();
  }

  Future<int> _fetchCode() async {
    try {
      final response = await _dio.get('getcode');
      return response.data['code'];
    } catch (e) {
      // Handle API call errors.
      print('Error fetching code: $e');
      return -1;
    }
  }

  // Function to trigger the API call when search is performed
  void _performSearch(String searchText) {
    // Make the API call here with the provided search text.
    // For now, let's print the searched text to the console.
    print('Searched text: $searchText');

    // Trigger the API call by setting _codeFuture to a new Future.
    setState(() {
      _codeFuture = _fetchCode();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBarWidget(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const EmojiText(),
            SearchInput(onSearch: _performSearch), // Pass the callback to SearchInput.
            FeaturesCourse(),
            //const ActiveCourse(),
            SizedBox(height: 20),
            FutureBuilder<int>(
              future: _codeFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show a loading indicator while fetching data.
                  return CircularProgressIndicator();
                } else if (snapshot.hasError || !snapshot.hasData) {
                  // Handle error or no data case.
                  return Text('Error fetching code.');
                } else {
                  // Display the fetched code in the bottom text box.
                  return Container(
                    padding: EdgeInsets.all(16),
                    color: Colors.grey[200],
                    child: Text(
                      'Fetched code: ${snapshot.data}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: ccBackground,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(
          label: "home",
          icon: Container(
            padding: const EdgeInsets.only(bottom: 5),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: ccAccent,
                  width: 2,
                ),
              ),
            ),
            child: const Text(
              "Home",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        BottomNavigationBarItem(
          label: "calendar",
          icon: Image.asset(
            "assets/icons/calendar.png",
            width: 20,
          ),
        ),
        BottomNavigationBarItem(
          label: "bookmark",
          icon: Image.asset(
            "assets/icons/bookmark.png",
            width: 20,
          ),
        ),
        BottomNavigationBarItem(
          label: "user",
          icon: Image.asset(
            "assets/icons/user.png",
            width: 20,
          ),
        ),
      ],
    );
  }

  AppBar _buildAppBarWidget() {
    return AppBar(
      backgroundColor: ccBackground,
      elevation: 0,
      centerTitle: false,
      title: const Padding(
        padding: EdgeInsets.only(left: 10),
        child: Text("Hello Frelly!"),
      ),
      titleTextStyle: const TextStyle(color: ccFontLight, fontSize: 16),
      actions: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(right: 20, top: 10),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: ccFontLight.withOpacity(0.3),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(15)),
              child: Image.asset(
                'assets/icons/notification.png',
                width: 30,
              ),
            ),
            Positioned(
              top: 15,
              right: 30,
              child: Container(
                height: 8,
                width: 8,
                decoration: const BoxDecoration(
                  color: ccAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
