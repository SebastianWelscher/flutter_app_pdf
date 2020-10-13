import 'package:flutter/material.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String status;

  requestPermission() async{
    var res = await Permission.storage.status;

    if(res.isUndetermined){
      await Permission.storage.request();
    }

    setState(() {
      status = '${res.toString()}';
    });

  }

  FToast ftoast;

  showToast(){
   Widget toast = Container(
     padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
     decoration: BoxDecoration(
       borderRadius: BorderRadius.circular(25),
       color: Colors.greenAccent,
     ),
     child: Row(
       children: [
         Icon(Icons.check),
         SizedBox(width: 12),
         Text('Datei gespeichert'),
       ],
     ),
   );

   ftoast.showToast(
       child: toast,
       gravity: ToastGravity.BOTTOM,
       toastDuration: Duration(seconds: 2),
   );

  }


  final pdf = pw.Document();

  writeOnPdf() {
/*
    final PdfImage image = PdfImage.file(
      pdf.document,
      bytes: (await rootBundle.load('assets/rastergrafik.png')).buffer.asUint8List(),
    );


 */
    pdf.addPage(
        pw.Page(
          build: (pw.Context context) =>
            pw.Column(
            children:[
            pw.Row(
              children: [
                pw.Expanded(
                  flex: 1,
                  child: pw.Container(),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Container(
                    child: pw.Center(
                      child: pw.Text('PDF - Datei',
                        style: pw.TextStyle(
                          fontSize: 15,
                        )
                      )
                    ),
                  ),
                ),
                pw.Expanded(
                  flex: 1,
                  child: pw.Container(),
                ),
              ]
            ),
              pw.SizedBox(
                height: 100,
              ),
              pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Paragraph(
                      text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Malesuada fames ac turpis egestas sed tempus urna. Quisque sagittis purus sit amet. A arcu cursus vitae congue mauris rhoncus aenean vel elit. Ipsum dolor sit amet consectetur adipiscing elit pellentesque. Viverra justo nec ultrices dui sapien eget mi proin sed."
                  ),
                ]
              )
          ],
          ),
        ),
    );
  }

  Future savePdf() async{

    /*
    Directory documentDirectory = await getExternalStorageDirectory();

    String documentPath = documentDirectory.path;
    print(documentPath);

     */
    File file = File("/storage/emulated/0/example2.pdf");
    file.writeAsBytesSync(pdf.save());
    showToast();
  }

  @override
  void initState() {
    super.initState();
    ftoast = FToast();
    ftoast.init(context);
    status = '';
    requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Flutter - PDF'),
      ),
      body: Center(
        child: Text(status),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.print_outlined),
        onPressed: ()async{
          writeOnPdf();
          await savePdf();
        },
      ),
    );
  }
}