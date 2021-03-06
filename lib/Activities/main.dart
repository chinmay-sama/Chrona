import 'dart:collection';

import 'package:chrona_1/Activities/account.dart';
import 'package:chrona_1/Activities/article.dart';
import 'package:chrona_1/Activities/question.dart';
import 'package:chrona_1/UserInfo/state.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../news/categories.dart';
import '../news/news_list.dart';

class NewsMain extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'chrona',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex=0;
  List<Categories> categoriesList;
  DatabaseReference databaseReference;
  FirebaseDatabase firebaseDatabase;
  HashMap<String,int> selectedItems=new HashMap(); 
  bool loading=true;
  @override
  void initState() {
    super.initState();
    
    firebaseDatabase = FirebaseDatabase.instance;
    databaseReference=firebaseDatabase.reference().child("Users");
    categoriesList = new List<Categories>();
    
  }

  Future<List<Categories>> loadCategories() async{
    var categories = <Categories>[
      //adding all the categories of news in the list
      new Categories('images/top_news.png', "Top Headlines", "top_news"),
      new Categories('images/global_news.png', "Global", "global"),
      new Categories('images/health_news.png', "Health", "health"),
      new Categories('images/entertainment_news.png', "Entertainment", "entertainment"),
      new Categories('images/sports_news.png', "Sports", "sports"),
      new Categories('images/business_news.png', "Business", "business"),
      new Categories('images/tech_news.png', "Technology", "technology"),
      new Categories('images/science_news.png', "Science", "science"),
      new Categories('images/politics_news.png', "Politics", "politics"),
      new Categories('images/automobile_news.png', "Automobile", "automobiles"),
      new Categories('images/gaming_news.png', "Gaming", "gaming")
    ];
    String s=StaticState.user.email;
    s=s.substring(0,s.indexOf("@"));
    // databaseReference.child(s).child("topicsofinterest").child("toi").once().then((DataSnapshot snapshot) {
    //   List<dynamic> values=snapshot.value;
    //   print(values);
    //   values.forEach((value) {
    //     selectedItems[value]=1;
    //   });
    // });
    DataSnapshot snapshot=await databaseReference.child(s).child("topicsofinterest").child("toi").once();
    List<dynamic> values=snapshot.value;
    values.forEach((element) {
      selectedItems[element]=1;
    });
    List<Categories> selectedCategories=[];
    selectedCategories.add(categories[0]);
    categories.forEach((element) {
      if(selectedItems.containsKey(element.title))
      selectedCategories.add(element);
    });
    
    return selectedCategories;
  }

  @override
  Widget build(BuildContext context) {
    final title = 'Chrona';
    loadCategories().then((value) {
      setState(() {
        categoriesList=value;
      loading=false;
      });
      });
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          IconButton(
            icon: CircleAvatar(
              radius: 18.0,
              backgroundImage: NetworkImage(StaticState.user.photoUrl),
              backgroundColor: Colors.transparent,
            ),
          )

        ],

        backgroundColor: Colors.black,
      ),
      body:loading?Center(child: CircularProgressIndicator()):GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this would produce 2 rows.
        crossAxisCount: 2,
        // Generate 100 Widgets that display their index in the List
        children: List.generate(categoriesList.length, (index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0)),
              child: Column(
                children: <Widget>[
                  Image(
                    image: AssetImage(categoriesList[index].image),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      categoriesList[index].title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => NewsListPage(
                        categoriesList[index].title,
                        categoriesList[index].newsType)));
              },
            ),
          );
        }),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: new Text("Home"),backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer),
            title: new Text("Q/A")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            title: Text("Article"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: new Text("Account")
          )
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.red,
        onTap: _ontappeditem,

      )
    );
  }

  void _ontappeditem(int value) {
    if(value==1)
      {
        Navigator.of(context).pushReplacement( MaterialPageRoute(builder: (context)=>Question_Route()));
        //selectedIndex=1;
      }
    if(value==2)
      {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Article()));
      }
    if(value==3)
      {
        Navigator.of(context).pushReplacement( MaterialPageRoute(builder: (context)=>Account()));
       // selectedIndex=2;
      }
  }
}
