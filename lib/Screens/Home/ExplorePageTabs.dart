import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gp/Screens/Profile/FreelancerProfilePage.dart';
import 'package:http/http.dart' as http;

class ExplorePageTabs extends StatefulWidget {
  const ExplorePageTabs({Key? key}) : super(key: key);

  @override
  State<ExplorePageTabs> createState() => _profileTabsMenuState();
}

class _profileTabsMenuState extends State<ExplorePageTabs>
    with TickerProviderStateMixin {

  late TabController _tabController;
  int _selectedTab = 0;
  List<Map<String, dynamic>> exploreResponseMaps = [];
  List<Map<String, dynamic>> topPicksResponseMaps = [];
  final storage = const FlutterSecureStorage();


  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _selectedTab = _tabController.index;
        });
      }
    });
  }

  fetchData() async {
    await fetchExplorePics();
    await fetchTopPicksPics();
  }

  fetchExplorePics() async {
    var url = Uri.parse('http://10.0.2.2:8080/api/v1/home/explore');
    var token = await storage.read(key: 'token');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token!}",
      },
    );
    List<dynamic> responseList = jsonDecode(response.body);

    for (var obj in responseList) {
      exploreResponseMaps.add(Map<String, dynamic>.from(obj));
    }
  }

   fetchTopPicksPics() async {
    var url = Uri.parse('http://10.0.2.2:8080/api/v1/home/top-picks');
    var token = await storage.read(key: 'token');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token!}",

      },
    );
    topPicksResponseMaps = [];
    List<dynamic> responseList = jsonDecode(response.body);

    for (var obj in responseList) {
      topPicksResponseMaps.add(Map<String, dynamic>.from(obj));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {

            if (exploreResponseMaps.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              );
            } else {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                child: DefaultTabController(
                    length: 2,
                    child: Container(
                      color: Colors.grey[200],
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15.0),
                              ),
                            ),
                            child: TabBar(
                              indicatorColor: Colors.grey.withOpacity(0),
                              padding: const EdgeInsets.all(10.0),
                              unselectedLabelColor: Colors.blue,
                              labelColor: Colors.blue,
                              controller: _tabController,
                              labelPadding: const EdgeInsets.all(0.0),
                              tabs: [
                                _getTab(
                                  0,
                                  const Center(
                                    child: Text(
                                      "Explore",
                                      style: TextStyle(
                                        fontFamily: 'OpenSans',
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                _getTab(
                                    1,
                                    const Center(
                                      child: Text(
                                        "Top Picks",
                                        style: TextStyle(
                                          fontFamily: 'OpenSans',
                                          color: Colors.black,
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              controller: _tabController,
                              children: [
                                SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: GridView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: exploreResponseMaps.length,
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return InkWell(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: Image.network(
                                                  exploreResponseMaps[index]
                                                      ['url'],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          FreelancerProfilePage(
                                                        myProfile: false,
                                                        id: exploreResponseMaps[
                                                            index]['owner'],
                                                      ),
                                                    ));
                                              },
                                            );
                                          },
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  childAspectRatio: 0.8,
                                                  crossAxisCount: 2,
                                                  crossAxisSpacing: 10,
                                                  mainAxisSpacing: 10),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: topPicksResponseMaps.isNotEmpty
                                              ? GridView.builder(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount:
                                                      topPicksResponseMaps
                                                          .length,
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      child: Image.network(
                                                        topPicksResponseMaps[
                                                            index]['url'],
                                                        fit: BoxFit.cover,
                                                      ),
                                                    );
                                                  },
                                                  gridDelegate:
                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                          childAspectRatio: 0.8,
                                                          crossAxisCount: 2,
                                                          crossAxisSpacing: 10,
                                                          mainAxisSpacing: 10),
                                                )
                                              : Align(
                                                  alignment: Alignment.center,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Image(
                                                        height: 250,
                                                        width: 250,
                                                        image: AssetImage(
                                                            'assets/images/EmptyList.png'),
                                                      ),
                                                      Text(
                                                        textAlign:
                                                            TextAlign.center,
                                                        "Can't find picks for you",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Schyler',
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.8),
                                                            fontSize: 20,
                                                            letterSpacing: 0.2),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        textAlign:
                                                            TextAlign.center,
                                                        "Your favourite list is empty!",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Schyler',
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.8),
                                                            fontSize: 20,
                                                            letterSpacing: 0.2),
                                                      ),
                                                    ],
                                                  ),
                                                ))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
              );
            }
          }),
    );
  }

  _getTab(index, child) {
    return Tab(
      child: SizedBox.expand(
        child: Container(
          margin: const EdgeInsets.only(left: 5.0),
          child: child,
          decoration: BoxDecoration(
              color:
                  (_selectedTab == index ? Colors.white : Colors.grey.shade300),
              borderRadius: _generateBorderRadius(index)),
        ),
      ),
    );
  }

  _generateBorderRadius(index) {
    if ((index + 1) == _selectedTab) {
      return const BorderRadius.only(
        bottomRight: Radius.circular(10.0),
        bottomLeft: Radius.circular(5.0),
        topRight: Radius.circular(5.0),
        topLeft: Radius.circular(5.0),
      );
    } else if ((index - 1) == _selectedTab) {
      return const BorderRadius.only(
        bottomRight: Radius.circular(5.0),
        bottomLeft: Radius.circular(10.0),
        topRight: Radius.circular(5.0),
        topLeft: Radius.circular(5.0),
      );
    } else {
      return const BorderRadius.all(Radius.circular(10.0));
    }
  }
}
