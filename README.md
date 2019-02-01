# Expandable

A Flutter widget that can be expanded or collapsed by the user.

## Introduction

This library helps implement expandable behavior as prescribed by Material Design:

* [Motion > Choreography > Transformation](https://material.io/design/motion/choreography.html#transformation)
* [Components > Cards > Behavior](https://material.io/design/components/cards.html#behavior)

![animated image](https://github.com/aryzhov/flutter-expandable/blob/master/doc/expandable_demo_small.gif?raw=true)     

`Expandable` should not be confused with 
[ExpansionPanel](https://docs.flutter.io/flutter/material/ExpansionPanel-class.html). 
`ExpansionPanel`, which is a part of
Flutter material library, is designed to work only within `ExpansionPanelList` and cannot be used
for making other widgets, for example, expandable Card widgets.


## Usage

`Expandable` uses [Scoped Model](https://pub.dartlang.org/packages/scoped_model) plugin
for communicating model state changes.

The easiest way to make a user-expandable widget is to use `ExpandablePanel`:

```dart
/// Shows a header along with an indicator icon, and expandable text below it: 
class Widget1 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      header: Text("Lorem ipsum",
        style: Theme.of(context).textTheme.body2,
      ),
      expanded: Text(loremIpsum, softWrap: true, ),
      tapHeaderToExpand: true,
      hasIcon: true,
    );
  }
}
```

You can also implement complex expandable widgets as shown below.

```dart
/// This widget has three sections: title, pictures, and description, which all expand
/// then the user clicks on the EXPAND button at the bottom.
class Widget2 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ExpandableModel>(
      model: ExpandableModel(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expandable(
            collapsed: buildCollapsedTitle(),
            expanded: buildExpandedTitle(),
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
                builder: (context, _, model) {
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

