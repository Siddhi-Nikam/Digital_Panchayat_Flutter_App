import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../config.dart';
import 'admindrawer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class admindashboard extends StatefulWidget {
  const admindashboard({super.key, required token});

  @override
  State<StatefulWidget> createState() {
    return admindashboardState();
  }
}

class admindashboardState extends State<admindashboard> {
  final CarouselSliderController _controller = CarouselSliderController();
  int currentIndex = 0; // Track active index for indicators

  @override
  void initState() {
    super.initState();
    fetchIssues();
  }

  Future<List<Map<String, dynamic>>> fetchIssues() async {
    try {
      final response = await http.get(Uri.parse('$BaseUrl/fetchIssue'));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data is Map && data.containsKey('data')) {
          List<Map<String, dynamic>> issues =
              (data['data'] as List).cast<Map<String, dynamic>>();

          // Sort by date (if 'created_at' exists), then take the 5 most recent
          issues.sort((a, b) =>
              (b['created_at'] ?? '').compareTo(a['created_at'] ?? ''));
          return issues.take(5).toList(); // ✅ Keep only 5 latest items
        } else {
          throw Exception("Unexpected response format");
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'प्रशासक डॅशबोर्ड',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const AdminDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              const Text(
                'समस्या (Recent 5)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Use FutureBuilder for API Data
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: fetchIssues(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                            "Error loading data",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text(
                            "No recent issues found",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      } else {
                        return Column(
                          children: [
                            // Carousel Slider (Shows only 5 most recent)
                            CarouselSlider.builder(
                              carouselController: _controller,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index,
                                  int pageViewIndex) {
                                var issue = snapshot.data![index];
                                return Container(
                                  margin: const EdgeInsets.all(5.0),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    issue["title"] ?? "No title",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              },
                              options: CarouselOptions(
                                autoPlay: true,
                                enlargeCenterPage: true,
                                viewportFraction: 0.9,
                                aspectRatio: 2.0,
                                initialPage: 0,
                                // onPageChanged: (index, reason) {
                                //   setState(() {
                                //     currentIndex =
                                //         index; // ✅ Updates active dot
                                //   });
                                // },
                              ),
                            ),

                            // ✅ Dots Indicator
                            const SizedBox(height: 10),
                            AnimatedSmoothIndicator(
                              activeIndex: currentIndex,
                              count: snapshot
                                  .data!.length, // ✅ Syncs with displayed items
                              effect: const ExpandingDotsEffect(
                                activeDotColor: Colors.white,
                                dotHeight: 8,
                                dotWidth: 8,
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
