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

The easiest way to make a user-expandable widget is to use `ExpandablePanel`:

```dart
/// Shows a header along with an indicator icon, and expandable text below it: 
class Widget1 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      header: Text("My Header",
        style: Theme.of(context).textTheme.body2,
      ),
      expanded: Text("Long long text", softWrap: true, ),
      tapHeaderToExpand: true,
      hasIcon: true,
    );
  }
}
```

You can implement complex expandable widgets by controlling the state of `Expandable` widgets 
using `ExpandableController`. The controller can be provided to `Expandable` widgets explicitly 
or by the means of `ExpandableNotifier`, which uses `InheritedWidget` under the covers. 
The following example demonstrates this usage pattern:

```dart
/// This widget has three sections: title, pictures, and description, which all expand
/// then the user clicks on the EXPAND button at the bottom.
class Widget2 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      controller: ExpandableController(animationDuration: Duration(milliseconds: 500)),
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
              Builder(
                builder: (context) {
                  var exp = ExpandableController.of(context);
                  return MaterialButton(
                    child: Text(exp.expanded ? "COLLAPSE": "EXPAND",
                      style: Theme.of(context).textTheme.button.copyWith(
                        color: Colors.deepPurple
                      ),
                    ),
                    onPressed: () {
                      exp.toggle();
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

## Automatic Scrolling

Expandable widgets are often used within a scroll view. When the user expands a widget, be it
an `ExpandablePanel` or an `Expandable` with a custom control, they expect the expanded
widget to fit within the viewable area (if possible). For example, if you show a list of 
articles with a summary of each article, and the user expands an article to read it, they
expect the expanded article to occupy as much screen space as possible. The **Expandable** 
package contains a widget to help implement this behavior, `ScrollOnExpand`. 
Here's how to use it:

```dart
   ExpandableNotifier(      // <-- This is where your controller lives
     //...
     ScrollOnExpand(        // <-- Wraps the widget to scroll
      //...
        ExpandablePanel(    // <-- Your Expandable or ExpandablePanel
          //...
        )
     )
  )
```

Why a separate widget, you might ask? Because generally you might want to to show not just 
the expanded widget but its container, for example a `Card` that contains it.
See the example app for more details on the usage of `ScrollOnExpand`.

## Migration

If you have migration issues from a previous version, read the [Migration Guide](doc/migration.md).