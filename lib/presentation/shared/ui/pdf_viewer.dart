import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_win_floating/webview.dart';
import 'package:path/path.dart' as path;

import '../../../core/theming/color_manager.dart';

class PdfWebView extends StatefulWidget {
  final PlatformFile pdf;
  final int index;
  const PdfWebView({Key? key, required this.pdf,required this.index}) : super(key: key);

  @override
  State<PdfWebView> createState() => _PdfWebViewState();
}

class _PdfWebViewState extends State<PdfWebView> {
  final controller = WinWebViewController('c:\\test');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    controller.setBackgroundColor(ColorManager.darkColor);
    controller.setNavigationDelegate(WinNavigationDelegate(
      onPageStarted: (url) => debugPrint("onPageStarted: $url"),
      onPageFinished: (url) => debugPrint("onPageFinished: $url"),
      onWebResourceError: (error) {
        debugPrint("onWebResourceError: ${error.description}");
        showToast("error in webview : \n${error.description}",duration: const Duration(seconds: 3));
      }

    ));
    debugPrint(widget.pdf.path);
    try{
      debugPrint("URL : ${widget.pdf.path}");
      debugPrint("URL : ${utf8.encode(widget.pdf.path!)}");
      //copyAndRenameFile(widget.pdf.path!, widget.pdf.path!, '${widget.pdf.bytes?.length}-temp.pdf');
      String newPath = widget.pdf.path!;
      getTempFile(widget.pdf.path!).then((value){
        newPath = value;
        debugPrint("NEW PATH : $newPath");
        controller.loadRequest_(newPath).onError((error, stackTrace){
          showToast("error in file : \n${error.toString()}",duration: const Duration(seconds: 3));
        });
      });

    }catch (e){
      debugPrint("ERROR HAPPENED : ${e.toString()}");
    }
    //controller.loadRequest(Uri.parse(widget.pdf.path!));
  }
  String copyAndRenameFile(String sourcePath, String destinationPath, String newName) {
    final sourceFile = File(sourcePath);
    final destinationFile = File(destinationPath);

    // Copy the file
    sourceFile.copySync(destinationPath);

    // Rename the copied file
    final newDirectory = path.dirname(destinationFile.path);
    final newPath = path.join(newDirectory, newName);
    destinationFile.renameSync(newPath);

    debugPrint('File copied and renamed successfully!\n $newPath');
    return newPath;
  }
  Future<String> getTempFile(String sourcePath)async {
    // Get the temporary directory for renaming the file
    Directory tempDir = await getTemporaryDirectory();
    String tempFilePath = '${tempDir.path}\\${widget.index}-temp_file.pdf';
    debugPrint("TEMP : $tempFilePath");
    // Rename the file temporarily
    File originalFile = File(sourcePath);
    originalFile.copySync(tempFilePath);

    return tempFilePath;
  }
  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColorDark),
        title: Text(widget.pdf.name),
      ),
      body: WinWebViewWidget(controller: controller),
    );
  }
/*
  Future<WebviewPermissionDecision> _onPermissionRequested(
      String url, WebviewPermissionKind kind, bool isUserInitiated) async {
    final decision = await showDialog<WebviewPermissionDecision>(
      context: MyApp.navigatorKey.currentContext!,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('WebView permission requested'),
        content: Text('WebView has requested permission \'$kind\''),
        actions: <Widget>[
          TextButton(
            onPressed: () =>
                Navigator.pop(context, WebviewPermissionDecision.deny),
            child: const Text('Deny'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, WebviewPermissionDecision.allow),
            child: const Text('Allow'),
          ),
        ],
      ),
    );

    return decision ?? WebviewPermissionDecision.none;
  }
*/
/*
  Future<void> initPlatformState() async {
    // Optionally initialize the webview environment using
    // a custom user data directory
    // and/or a custom browser executable directory
    // and/or custom chromium command line flags
    //await WebviewController.initializeEnvironment(
    //    additionalArguments: '--show-fps-counter');

    try {
      await widget._controller.initialize();
      await widget._controller.setBackgroundColor(Colors.transparent);
      await widget._controller.setPopupWindowPolicy(WebviewPopupWindowPolicy.deny);
      await widget._controller.loadStringContent(widget.pdfUrl);

      if (!mounted) return;
      setState(() {});
    } on PlatformException catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('Error'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Code: ${e.code}'),
                  Text('Message: ${e.message}'),
                ],
              ),
              actions: [
                TextButton(
                  child: Text('Continue'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
      });
    }
  }
*/

}

