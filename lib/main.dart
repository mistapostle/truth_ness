import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'dart:math' show Random;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Welcome to Flutter',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: MainPage());
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title:  Text("真实新闻",textAlign: TextAlign.center),
          bottom: TabBar(tabs: [
            Tab(
              text: "新闻",
            ),
            Tab(text: "社论"),
            Tab(text: "视频"),
          ]),
        ),
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the Drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text('Drawer Header'),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text('Item 1'),
                onTap: () {
                  // Update the state of the app
                  // ...
                },
              ),
              ListTile(
                title: Text('Item 2'),
                onTap: () {
                  // Update the state of the app
                  // ...
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
            children: [NewsPage( header: "新闻"), NewsPage(header:"社论"), NewsPage(header:"视频")]),
      ),
    );
  }
}

class News {
  String title;
  News(this.title) ;

}


class NewsDetail {
  final News news ;
  final String content ;

  NewsDetail(this.news, this.content);



}

class NewsPage extends StatefulWidget {
  final String header;

  const NewsPage({Key key, this.header}) : super(key: key);


  @override
  NesPageState createState() => new NesPageState();
}

class NesPageState extends State<NewsPage> {
  final _newsList = <News>[
    News("N1"),
    News("N2"),
    News("N2"),
    News("N2"),
    News("N2"),
    News("N2"),
    News("N2"),
    News("N2"),
    News("N2"),
    News("N2"),
    News("N2"),
    News("N2"),
    News("N2"),
    News("N2"),
    News("N2"),
    News("N2"),
    News("N2"),
    News("N2"),
    News("N2"),
    News("N2"),
    News("N2"),
    News("N2"),
    News("N2"),
    News("N2"),
    News("N2")
  ];
  static final Random random = Random();

  ScrollController _scrollController = ScrollController();
  final ScrollPhysics physics = ClampingScrollPhysics();

  bool isPerformingRequest = false;

  @override
  void initState() {
    super.initState();
    //ScrollMetrics position = ;
    //physics.shouldAcceptUserOffset(position);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _getMoreData() async {
    if (!isPerformingRequest) {
      setState(() => isPerformingRequest = true);
      List<News> newEntries =
          await fakeRequest(_newsList.length, _newsList.length + 10);
      if (newEntries.isEmpty) {
        double edge = 50.0;
        double offsetFromBottom = _scrollController.position.maxScrollExtent -
            _scrollController.position.pixels;
        if (offsetFromBottom < edge) {
          _scrollController.animateTo(
              _scrollController.offset - (edge - offsetFromBottom),
              duration: new Duration(milliseconds: 500),
              curve: Curves.easeOut);
        }
      }
      setState(() {
        _newsList.addAll(newEntries);
        isPerformingRequest = false;
      });
    }
  }

  Future<List<News>> fakeRequest(int from, int to) async {
    return Future.delayed(Duration(seconds: 2), () {
      return List.generate(to - from, (i) => News("N ${i + from}"));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: EdgeInsets.all(2.0),
          child: RefreshIndicator(
            onRefresh: _refresh,
           // backgroundColor: Colors.blue,
            child: ListView.builder(
              physics: physics,
              // shrinkWrap:true,
              padding: EdgeInsets.all(8.0),
              // itemExtent: 20.0,
              itemCount: _newsList.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == _newsList.length) {
                  return _buildProgressIndicator();
                } else {
                  return ListTile(
                      title: Text(
                          '${this.widget.header} $index : ${_newsList[index].title}'),
                      onTap: () {
                        Navigator.of(context).push( MaterialPageRoute(builder:
                        (context)=> NewsDetailPage(newsDetail: NewsDetail(_newsList[index], "Summary"),)
                        ) ) ;
                      }// onTab
                  );
                }
              },

              controller: _scrollController,
            ),
          ),
        );
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isPerformingRequest ? 1.0 : 0.0,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  Future<Null> _refresh() async {
    _newsList.clear();
    await _loadFirstListData();

    return;
  }

  Future _loadFirstListData() {
    return new Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        int len = random.nextInt(20) + 10;
        for (var i = 0; i < len; i++) {
          _newsList.add(News("N $i"));
        }
      });
    });
  }
}


class NewsDetailPage extends StatelessWidget{
  final NewsDetail newsDetail;

  const NewsDetailPage({Key key, this.newsDetail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar( title: Text(newsDetail.news.title),)  ,
       body: Text(
          newsDetail.content
       ),
     );
  }

}