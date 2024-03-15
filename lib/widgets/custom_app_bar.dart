import 'package:flutter/material.dart';
import 'package:parkwizflutter/user/LoginScreen.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final double customHeight; // Specify the desired height

  const CustomAppBar({super.key, required this.customHeight});

  @override
  // ignore: library_private_types_in_public_api
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(customHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 55, 16, 132),
      elevation: 40.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Set the border radius
      ),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          "assets/logo.png",
          fit: BoxFit.contain,
          width: 36.0, // Adjust the width as needed
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '',
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            '',
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                color: Colors.yellow,
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        GestureDetector(
          onTap: () => logout(context),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.exit_to_app,
              size: 36.0,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  // the logout function
  Future<void> logout(BuildContext context) async {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const UserLoginScreen()),
    );
  }
}
