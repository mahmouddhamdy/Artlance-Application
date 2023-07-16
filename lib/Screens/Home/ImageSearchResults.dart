import 'package:flutter/material.dart';

import '../Profile/FreelancerProfilePage.dart';

class imageSearchResults extends StatelessWidget {
  List<Map<String, dynamic>> results = [];

  imageSearchResults({Key? key, required this.results}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Search Results'),
          titleTextStyle: const TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
          shadowColor: Colors.blueGrey.withOpacity(0),
          backgroundColor: Colors.blueGrey.withOpacity(0),
          leading: const BackButton(color: Colors.black),
        ),
        body: results.isEmpty
            ? Align(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Image(
                      image: AssetImage('assets/images/EmptyList.png'),
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      "No results found",
                      style: TextStyle(
                          fontFamily: 'Schyler',
                          color: Colors.black.withOpacity(0.8),
                          fontSize: 25,
                          letterSpacing: 0.2),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [

                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: results.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                results[index]['url'],
                                fit: BoxFit.cover,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FreelancerProfilePage(
                                      myProfile: false,
                                      id: results[index]['owner'],
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
      ),
    );
  }
}
