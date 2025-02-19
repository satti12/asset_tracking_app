// ignore_for_file: file_names, must_be_immutable
import 'package:asset_tracking/Component/Save%20PopUp/Snackbar.dart';
import 'package:asset_tracking/Component/roundbutton.dart';
import 'package:asset_tracking/LocalDataBase/db_helper.dart';
import 'package:asset_tracking/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info/package_info.dart';

class NewProfilePage extends StatefulWidget {
  String? Userid;
  NewProfilePage({super.key, this.Userid});

  @override
  State<NewProfilePage> createState() => _NewProfilePageState();
}

class _NewProfilePageState extends State<NewProfilePage> {
  final TextEditingController _NameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  RxBool laoding = false.obs;
  String? avatar;
  Future<User> fetchuserinfo(String user_id) async {
    final data = await DatabaseHelper.instance.queryList('users', [
      ['user_id', '=', user_id]
    ], {});

    if (data != null && data.length > 0) {
      final List<User> response =
          data.map((json) => User.fromJson(json)).toList();

      // Populate the TextFormFields with user data
      _NameController.text = response[0].name.toString();
      _emailController.text = response[0].email.toString();
      _phoneController.text = response[0].phone.toString();
      avatar = response[0].avatar.toString();

      return response[0];
    } else {
      Utils.SnackBar('Error', 'User Not Found');
      throw Exception('User Not Found');
    }
  }

  String version = 'NA';

  onSetAppVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      version = packageInfo.version;
    } catch (e) {
      print('Error getting app version: $e');
      version = 'NA';
    }
    setState(() {
      version;
    });
  }

  Future<void> Update() async {
    // Assuming 'user' is your table name and 'name' is the column you want to update
    // Adjust these values based on your actual database structure.
    String tableName = 'users';
    String columnName = 'name';
    String columnValue = _NameController.text;

    // Update the database
    await DatabaseHelper.instance.update(tableName, columnName, columnValue, {
      // Pass other data you want to update
      // For example, if you have an 'email' column, you can update it like this:
      'email': _emailController.text,
      // Similarly, update other columns as needed
      'phone': _phoneController.text,
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      fetchuserinfo(widget.Userid.toString());
      onSetAppVersion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {},
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        // Add your image asset here
                        backgroundImage: NetworkImage(avatar.toString()),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 10, bottom: 10),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Color(0xFFA80303),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  _NameController.text,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.mulish(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.48,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width / 1.1,
                  height: 43,
                  decoration: ShapeDecoration(
                    color: Color(0xFFF6F6F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: TextFormField(
                      controller: _NameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          label: Text(
                            'Name',
                            style: GoogleFonts.mulish(
                              color: Color(0xFF5C96FD),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.20,
                            ),
                          ),
                          contentPadding:
                              EdgeInsets.only(left: 20, bottom: 15))),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width / 1.1,
                  height: 43,
                  decoration: ShapeDecoration(
                    color: Color(0xFFF6F6F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          label: Text(
                            'E-mail ',
                            style: GoogleFonts.mulish(
                              color: Color(0xFF5C96FD),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.20,
                            ),
                          ),
                          contentPadding:
                              EdgeInsets.only(left: 20, bottom: 15))),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width / 1.1,
                  height: 43,
                  decoration: ShapeDecoration(
                    color: Color(0xFFF6F6F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          label: Text(
                            'Phone',
                            style: GoogleFonts.mulish(
                              color: Color(0xFF5C96FD),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.20,
                            ),
                          ),
                          contentPadding:
                              EdgeInsets.only(left: 20, bottom: 15))),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 100, vertical: 40),
                  child: Obx(
                    () => RoundButton(
                        buttonColor: Color(0xFFA80303),
                        title: 'Save Changes',
                        loading: laoding.value,
                        onPress: () {
                          laoding.value = true;
                          Update().whenComplete(() {
                            laoding.value = false;
                            showSnackBar(context);
                          });
                        }),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 60,
            right: 0,
            child: SvgPicture.asset('images/svg/Graphic Right.svg'),
          ),
          Positioned(
            top: 550,
            left: 20,
            child: SvgPicture.asset('images/svg/Graphic Left.svg'),
          )
        ]),
      ),
      bottomSheet: Container(
          height: 20,
          color: Colors.white,
          child: Text('App Version : ${version}')),
    );
  }
}
