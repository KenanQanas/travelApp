import 'package:flutter/material.dart';
import 'package:fourth_year/network/response/dio_helpers.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileSettings extends StatefulWidget {
  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  late SharedPreferences profileData;
  String userName = '', email = '';
  bool isLoading = true;

  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    loadProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(25),
                child: TextField(
                  controller: userNameController,
                  decoration: InputDecoration(
                    hintText: userName,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    label: const Text(
                      "My UserName",
                      style: TextStyle(fontSize: 20),
                    ),
                    enabled: true,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 25,
                  right: 25,
                ),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: email,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    label: const Text(
                      "My Email",
                      style: TextStyle(fontSize: 20),
                    ),
                    enabled: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextButton(
                  onPressed: () async {
                    if (emailController.text.isEmpty) {
                      showToast("please fill all fields");
                    } else {
                      setState(() {
                        isLoading = true;
                      });
                      String _id = profileData.get('id').toString();
                      String url = '/userinfo/$_id';
                      Map<String, dynamic> data = {
                        'email': emailController.text
                      };
                      String _token = profileData.get('t').toString();
                      await DioHelpers.saveProfileInfo(
                        token: _token,
                        url: url,
                        data: data,
                      ).then((value) {
                        setState(() {
                          isLoading = false;
                        });
                        print(value.data);
                        setState(() {
                          email = value.data['user']['email'];
                        });
                        showToast("email saved successfully");
                        profileData.setString('e', email);
                      }).catchError((error) {
                        isLoading = false;
                        print(error.toString());
                      });
                    }
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.blue, fontSize: 25),
                  ),
                ),
              )
            ],
          );
  }

  void loadProfileData() async {
    try {
      setState(() {
        isLoading = true;
      });
      profileData = await SharedPreferences.getInstance();
      print(profileData.getString('e'));
      setState(() {
        userName = profileData.getString('u')!;
        email = profileData.getString('e')!;
      });
    } catch (error) {
      print(error);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
