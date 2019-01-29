import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expandable Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  State createState() {
    return MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expandable Demo"),
      ),
      body: ListView(
        children: <Widget>[
          Card1(),
          Card2(),
        ].map((w) {
          return Padding(
            padding: EdgeInsets.only(top: 15, left: 15, right: 15,),
            child: w,
          );
        }).toList(),
      ),
    );
  }
}

const loremIpsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

class Card1 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ScopedModel<ExpandableModel>(
        model: ExpandableModel(),
        child: Column(
          children: <Widget>[
              SizedBox(
              height: 150.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.rectangle,
                  image: DecorationImage(image: AssetImage('images/IMG_4164.JPG'), fit: BoxFit.cover),
                ),
              ),
            ),
            ExpandableHeader(
              child: Padding(
                padding: EdgeInsets.only(top: 5.0, left: 10.0, right: 0.0),
                child: Text("Lorem ipsum",
                  style: Theme.of(context).textTheme.body2,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
              child: Expandable(
                collapsed: Text(loremIpsum, softWrap: false, overflow: TextOverflow.ellipsis,),
                expanded: Text(loremIpsum, softWrap: true, overflow: TextOverflow.fade,),
              ),
            ),
          ],
        ),
      )
    );
  }
}

class Card2 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    buildImg(String path, double height) {
      return SizedBox(
        height: height,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.rectangle,
            image: DecorationImage(image: AssetImage(path), fit: BoxFit.cover),
          ),
        )
      );
    }

    buildCollapsedHeader() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Lorem Ipsum",
                  style: Theme.of(context).textTheme.body1,
                ),
              ],
            ),
          ),
        ]
      );
    }

    buildCollapsedPictures() {
      return buildImg('images/IMG_3897.JPG', 150.0);
    }

    buildCollapsedDescription() {
      return Container();
    }

    buildExpandedHeader() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Lorem Ipsum",
                  style: Theme.of(context).textTheme.body1,
                ),
                Text("Lorem Ipsum",
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
        ]
      );
    }

    buildExpandedPictures() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: buildImg('images/IMG_4164.JPG', 100.0)
              ),
              Expanded(
                child: buildImg('images/IMG_2840.JPG', 100.0)
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: buildImg('images/IMG_4163.JPG', 100.0)
              ),
              Expanded(
                child: buildImg('images/IMG_4203.JPG', 100.0)
              ),
            ],
          ),
        ],
      );
    }

    buildExpandedDescription() {
      return Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod", softWrap: true,),
          ],
        ),
      );
    }


    return Card(
      clipBehavior: Clip.antiAlias,
      child: ScopedModel<ExpandableModel>(
        model: ExpandableModel(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expandable(
              collapsed: buildCollapsedHeader(),
              expanded: buildExpandedHeader(),
            ),
            Expandable(
              collapsed: buildCollapsedPictures(),
              expanded: buildExpandedPictures(),
            ),
            Expandable(
              collapsed: buildCollapsedDescription(),
              expanded: buildExpandedDescription(),
            ),
            Divider(height: 0.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ScopedModelDescendant<ExpandableModel>(
                  builder: (_, __, model) {
                    return MaterialButton(
                      child: Text(model.expanded ? "COLLAPSE": "EXPAND",
                        style: Theme.of(context).textTheme.button.copyWith(
                          color: Colors.deepPurple
                        ),
                      ),
                      onPressed: () {
                        model.expanded = !model.expanded;
                      },
                    );
                  }
                )
              ],
            )
          ],
        ),
      )
    );
  }
}
