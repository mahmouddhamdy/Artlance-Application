import 'package:flutter/material.dart';
class updatePassword extends StatefulWidget {
  static const routeName = 'updatePassword';

  const updatePassword({Key? key}) : super(key: key);

  @override
  State<updatePassword> createState() => _updatePasswordState();
}

class _updatePasswordState extends State<updatePassword> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.blueGrey.withOpacity(0),
        backgroundColor: Colors.blueGrey.withOpacity(0),
        leading: const BackButton(color: Colors.black),
      ),
      body:CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(35.0),
                  topRight: Radius.circular(35.0),
                ),
              ),
              child: Column(children: [
                const SizedBox(height: 5,),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              style:
                              const TextStyle(color: Colors.black),
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Old Password'),
                              obscureText: !isPasswordVisible,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible =
                                  !isPasswordVisible;
                                });
                              },
                              icon: const Icon(
                                Icons.visibility,
                                size: 18,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              style:
                              const TextStyle(color: Colors.black),
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'New Password'),
                              obscureText: !isPasswordVisible,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible =
                                  !isPasswordVisible;
                                });
                              },
                              icon: const Icon(
                                Icons.visibility,
                                size: 18,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              style:
                              const TextStyle(color: Colors.black),
                              decoration: const InputDecoration(
                                labelText: "Confirm Your New Password",
                                border: InputBorder.none,
                              ),
                              obscureText: !isPasswordVisible,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible =
                                  !isPasswordVisible;
                                });
                              },
                              icon: const Icon(
                                Icons.visibility,
                                size: 18,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),

                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<
                        RoundedRectangleBorder>(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    )),
                    minimumSize:
                    MaterialStateProperty.all(const Size(300, 35)),
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  onPressed: () {

                  },
                  child: const Text(
                    "Update",
                    style: TextStyle(
                        fontFamily: 'Schyler',
                        letterSpacing: 1,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 21),
                  ),
                ),

              ]

              ),
            ),
          )
        ],

      ),
    );
  }
}
