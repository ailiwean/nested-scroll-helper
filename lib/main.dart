import 'package:flutter/material.dart';
import 'package:nested_scroll_helper/nested_scroll_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
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
  PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return NestPageHelperParent(
        child: PageView.builder(
            itemCount: 5,
            controller: pageController,
            itemBuilder: (context, index) {
              //嵌套PageView
              if (index == 3)
                return NestPageHelperChild(
                    child: PageView.builder(
                        itemCount: 5,
                        itemBuilder: (_, index) {
                          return Center(
                            child: Text("内部" + index.toString()),
                          );
                        }));
              return Center(
                child: Text(index.toString()),
              );
            }),
        pageController: pageController);
  }
}
