import 'dart:convert';
import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_network/image_network.dart';
import 'package:provider/provider.dart';
import '../../Provider/myProvider.dart';
import 'ProfileReviews.dart';
import 'package:http/http.dart' as http;

class profileTabsMenu extends StatefulWidget {
  final String mail;
  final int hourlyRate;
  final String? id, description;
  final List<Map<String, dynamic>> images;

  const profileTabsMenu(
      {Key? key,
      required this.hourlyRate,
      required this.mail,
      required this.id,
      required this.images,
      this.description})
      : super(key: key);

  @override
  State<profileTabsMenu> createState() => _profileTabsMenuState();
}

class _profileTabsMenuState extends State<profileTabsMenu>
    with TickerProviderStateMixin {
  TextEditingController reviewText = TextEditingController();

  late TabController _tabController;
  int _selectedTab = 0;
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(
      () {
        if (!_tabController.indexIsChanging) {
          setState(() {
            _selectedTab = _tabController.index;
          });
        }
      },
    );
  }

  postReview() async {
    var url = Uri.parse('http://10.0.2.2:8080/api/v1/reviews/');
    var token = await storage.read(key: 'token');

    if (reviewText.text.isEmpty) {
      var snackBar = const SnackBar(
        content: Text('Your review is empty!'),
        duration: Duration(seconds: 1),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token!}",
      },
      body: jsonEncode(
        {
          'content': reviewText.text,
          'to': widget.id,
        },
      ),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 203 ||
        response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.4),
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
      ),
      child: DefaultTabController(
          animationDuration: const Duration(seconds: 2),
          length: 3,
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    borderRadius:
                        const BorderRadius.all(Radius.circular(15.0))),
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
                          "Portfolio",
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
                          "Info",
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    _getTab(
                      2,
                      const Center(
                        child: Text(
                          "Reviews",
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )
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
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: widget.images.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: ImageNetwork(
                                    image: widget.images[index]['url'],
                                    fitAndroidIos: BoxFit.cover,
                                    height: 70,
                                    width: 70,
                                  ),
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
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            _buildRow(const Icon(Icons.money_off_sharp),
                                "Description: ", "${widget.description}", 1),
                            const SizedBox(
                              height: 5,
                            ),
                            const Divider(
                              color: Colors.black,
                            ),
                            _buildRow(const Icon(Icons.money_off_sharp),
                                "Hourly Rate: ", "${widget.hourlyRate} EGP", 2),
                            const Divider(
                              color: Colors.black,
                            ),
                            _buildRow(
                              const Icon(Icons.email),
                              " Email: ",
                              widget.mail,
                              3,
                            ),
                            const Divider(
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Provider.of<myProvider>(context, listen: false)
                                    .isFreelancer!
                                ? Container()
                                : Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(
                                        color: Colors.black.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0, right: 10.0),
                                      child: TextField(
                                        maxLength: 75,
                                        controller: reviewText,
                                        style: const TextStyle(
                                            color: Colors.black),
                                        decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Write a review..'),
                                      ),
                                    ),
                                  ),
                            Provider.of<myProvider>(context, listen: false)
                                    .isFreelancer!
                                ? Container()
                                : Align(
                                    alignment: Alignment.center,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        minimumSize: MaterialStateProperty.all(
                                          const Size(50, 35),
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.black),
                                      ),
                                      onPressed: () async {
                                        var posted = await postReview();
                                        if (posted!) {
                                          var snackBar2 = const SnackBar(
                                            content: Text('Review submitted! '),
                                          );
                                          Future.delayed(
                                                  const Duration(seconds: 1))
                                              .then((_) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar2);
                                          });
                                        } else {
                                          var snackBar2 = const SnackBar(
                                            content: Text(
                                                "You're not allowed to review this freelancer!"),
                                          );
                                          Future.delayed(
                                                  const Duration(seconds: 2))
                                              .then(
                                            (_) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar2);
                                            },
                                          );
                                        }
                                      },
                                      child: const Text(
                                        "Post",
                                        style: TextStyle(
                                            fontFamily: 'Schyler',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: 0.7,
                                            fontSize: 15),
                                      ),
                                    ),
                                  ),
                            const SizedBox(
                              height: 25,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Center(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => reviewsPage(
                                          id: widget.id,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Row(
                                    children: [
                                      Text(
                                        "See what other people think",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'OpenSans',
                                          color: Colors.blue,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 3.0),
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 14,
                                          color: Colors.blue,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }

  _buildRow(Icon icon, text1, text2, int type) {
    return SizedBox(
      height: type == 1 || type == 3 ? 100 : null,
      child: ListTile(
        title: Row(
          children: [
            icon,
            const SizedBox(width: 5.0),
            Text(
              text1,
              style: const TextStyle(
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Text(
                text2,
                overflow: TextOverflow.visible,
                style: const TextStyle(
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
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
