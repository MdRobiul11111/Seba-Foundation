import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LinkOpener {
  // Create a method channel
  static const platform = MethodChannel('com.yourapp/link_opener');

  static Future<void> _checkLoginAndNavigate(BuildContext context) async {
    try {
      // Fetch the document from Firestore
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("Links")
          .doc("aboutUs")
          .get();

      // Check if the document exists and contains data
      if (snapshot.exists && snapshot.data() != null) {
        // Safely extract the link using null-aware operator
        final String? link = snapshot.get("link");

        // Validate the link
        if (link != null && link.isNotEmpty) {
          try {
            // Use method channel to open link in native browser
            final bool? result = await platform.invokeMethod('openLink', link);

            if (result != true) {
              if (context.mounted) {
                _showErrorSnackBar(context, "Could not launch the link");
              }
            }
          } on PlatformException catch (e) {
            // Handle platform-specific errors
            if (context.mounted) {
              _showErrorSnackBar(context, "Error opening link: ${e.message}");
            }
          }
        } else {
          if (context.mounted) {
            _showErrorSnackBar(context, "No link available");
          }
        }
      } else {
        if (context.mounted) {
          _showErrorSnackBar(context, "No link found in database");
        }
      }
    } catch (e) {
      // Handle any unexpected errors
      if (context.mounted) {
        _showErrorSnackBar(
            context, "An error occurred while fetching the link");
      }
    }
  }

  // Helper method to show error snackbar
  static void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
