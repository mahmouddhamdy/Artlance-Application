import 'package:flutter/material.dart';

import '../Profile/FreelancerProfilePage.dart';

class SearchResults extends StatefulWidget {
  final List<Map<String, dynamic>> searchResults;

  const SearchResults({Key? key, required this.searchResults})
      : super(key: key);

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.blueGrey.withOpacity(0),
        backgroundColor: Colors.black.withOpacity(0.05),
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "Search Results",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: widget.searchResults.length == 0
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
                    "No freelancers found",
                    style: TextStyle(
                        fontFamily: 'Schyler',
                        color: Colors.black.withOpacity(0.8),
                        fontSize: 25,
                        letterSpacing: 0.2),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.searchResults.length,
                itemBuilder: (context, index) => inkwellBuilder(
                    widget.searchResults[index]['id'],
                    widget.searchResults[index]['name'],
                    "",
                    widget.searchResults[index]['type'],
                    widget.searchResults[index]['username'],
                    context),
              ),
            ),
    );
  }
}

Widget inkwellBuilder(String id, String name, String imgPath, String type,
    String username, BuildContext ctx) {
  return Column(
    children: [
      InkWell(
        onTap: () {
          Future.delayed(const Duration(seconds: 1)).then(
                (_) {
              Navigator.push(
                ctx,
                MaterialPageRoute(
                  builder: (ctx) => FreelancerProfilePage(
                    myProfile: false,
                    id: id,
                  ),
                ),
              );
            },
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(ctx).size.width / 2 - 30,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(ctx).size.width / 2 - 30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 100),
                    child: Text(
                      textAlign: TextAlign.center,
                      name,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 100,minWidth: 50),
                    child: Text(
                      '@$username',
                      style: Theme.of(ctx).textTheme.displaySmall,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 100,minWidth: 50),
                    child: Text(
                      type,
                      style: Theme.of(ctx).textTheme.displaySmall,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
        child: Divider(
          color: Colors.black.withOpacity(0.8),
          height: 50,
        ),
      ),
    ],
  );
}
