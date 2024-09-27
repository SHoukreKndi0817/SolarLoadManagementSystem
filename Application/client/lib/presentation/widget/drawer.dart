
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screen/login_screen.dart';



class AppDrawer extends StatefulWidget {

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final Uri botUrl = Uri.parse("https://t.me/VoltAsupport_bot");
  Future<void> _launchInBrowser() async {
    if (!await launchUrl(
      botUrl,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $botUrl');
    }
  }

  Future<void> _launchInBrowserView() async {
    if (!await launchUrl(botUrl, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $botUrl');
    }
  }

  Future<void> _launchInWebView() async {
    if (!await launchUrl(botUrl, mode: LaunchMode.inAppWebView)) {
      throw Exception('Could not launch $botUrl');
    }
  }

  Future<void> _launchInAppWithBrowserOptions(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppBrowserView,
      browserConfiguration: const BrowserConfiguration(showTitle: true),
    )) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _launchAsInAppWebViewWithCustomHeaders(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(
          headers: <String, String>{'my_header_key': 'my_header_value'}),
    )) {
      throw Exception('Could not launch $url');
    }
  }

  // Future<void> _launchTelegramBot() async {
  //   if (await canLaunchUrl(botUrl)) {
  //     await launchUrl(botUrl);
  //   } else {
  //     throw 'Could not launch $botUrl';
  //   }
  // }
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('clientId');
    await prefs.remove('token');
    await prefs.setBool('user', false);
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.contact_support_outlined),
            title: Text('Contact'),
            onTap: () {
              _launchInBrowser();

            },
          ),

          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () async {
              await logout();  // استدعاء دالة تسجيل الخروج
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignInScreen()),
              );  // توجيه المستخدم إلى صفحة تسجيل الدخول
            },
          ),
        ],
      ),
    );
  }
}