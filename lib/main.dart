import 'package:flutter/material.dart';
import 'connection_screen.dart';

void main() {
  runApp(new AppJuran());
}

class AppJuran extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Juran',
        theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting
        // the app, try changing the primarySwatch below to Colors.green
        // and press "r" in the console where you ran "flutter run".
        // We call this a "hot reload". Notice that the counter didn't
        // reset back to zero -- the application is not restarted.
            primarySwatch: Colors.blue,
            ),
        home: new BottomNavigationHomeScreen(),

        );
  }
}

class BottomNavigationHomeScreen extends StatefulWidget {
  static const String routeName = '/bottom_navigation';

  @override
  _BottomNavigationState createState() => new _BottomNavigationState();
}


class _BottomNavigationState extends State<BottomNavigationHomeScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  BottomNavigationBarType _type = BottomNavigationBarType.shifting;
  List<NavigationIconView> _navigationViews;

  @override
  void initState() {
    super.initState();
    _navigationViews = <NavigationIconView>[
      new NavigationIconView(
          icon: new Icon(Icons.wifi),
          title: new Text('Connection'),
          color: Colors.deepPurple[500],
          vsync: this,
          ),
      new NavigationIconView(
          icon: new Icon(Icons.apps),
          title: new Text('Betas'),
          color: Colors.teal[500],
          vsync: this,
          ),
      new NavigationIconView(
          icon: new Icon(Icons.bug_report),
          title: new Text('Test'),
          color: Colors.indigo[500],
          vsync: this,
          ),
      new NavigationIconView(
          icon: new Icon(Icons.markunread),
          title: new Text('Logs'),
          color: Colors.pink[500],
          vsync: this,
          )
    ];

    for (NavigationIconView view in _navigationViews)
      view.controller.addListener(_rebuild);

    _navigationViews[_currentIndex].controller.value = 1.0;
  }

  @override
  void dispose() {
    for (NavigationIconView view in _navigationViews)
      view.controller.dispose();
    super.dispose();
  }

  void _rebuild() {
    setState(() {
      // Rebuild in order to animate views.
    });
  }

  Widget _buildBody() {
    final List<FadeTransition> transitions = <FadeTransition>[];

    for (NavigationIconView view in _navigationViews)
      transitions.add(view.transition(_type, context));

    // We want to have the newly animating (fading in) views on top.
    transitions.sort((FadeTransition a, FadeTransition b) {
      double aValue = a.animation.value;
      double bValue = b.animation.value;
      return aValue.compareTo(bValue);
    });

    if (_currentIndex == 0)
      return new ConnectionScreen(
          wifies: _kWifies,
          proxies: _kProxies
      );
    else
      return new Stack(children: transitions);
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar botNavBar = new BottomNavigationBar(
        labels: _navigationViews
            .map((NavigationIconView navigationView) => navigationView.destinationLabel)
            .toList(),
        currentIndex: _currentIndex,
        type: _type,
        onTap: (int index) {
          setState(() {
            _navigationViews[_currentIndex].controller.reverse();
            _currentIndex = index;
            _navigationViews[_currentIndex].controller.forward();
          });
        },
        );

    return new Scaffold(
        body: _buildBody(),
        bottomNavigationBar: botNavBar,
        );
  }
}

class NavigationIconView {
  NavigationIconView({
  Icon icon,
  Widget title,
  Color color,
  TickerProvider vsync,
  }) : _icon = icon,
        _color = color,
        destinationLabel = new DestinationLabel(
            icon: icon,
            title: title,
            backgroundColor: color,
            ),
        controller = new AnimationController(
            duration: kThemeAnimationDuration,
            vsync: vsync,
            ) {
    _animation = new CurvedAnimation(
        parent: controller,
        curve: new Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
        );
  }

  final Icon _icon;
  final Color _color;
  final DestinationLabel destinationLabel;
  final AnimationController controller;
  CurvedAnimation _animation;

  FadeTransition transition(BottomNavigationBarType type, BuildContext context) {
    Color iconColor;
    if (type == BottomNavigationBarType.shifting) {
      iconColor = _color;
    } else {
      final ThemeData themeData = Theme.of(context);
      iconColor = themeData.brightness == Brightness.light
          ? themeData.primaryColor
          : themeData.accentColor;
    }

    return new FadeTransition(
        opacity: _animation,
        child: new SlideTransition(
            position: new Tween<FractionalOffset>(
                begin: const FractionalOffset(0.0, 0.02), // Small offset from the top.
                end: FractionalOffset.topLeft,
                ).animate(_animation),
            child: new Icon(_icon.icon, color: iconColor, size: 120.0),
            ),
        );
  }
}

final List<Proxy> _kProxies = <Proxy>[
  new Proxy(name: 'Nenhum'),
  new Proxy(name: 'Charles'),
  new Proxy(name: 'Squid'),
  new Proxy(name: 'Mitm'),
];

final List<Proxy> _kWifies = <Proxy>[
  new Proxy(name: 'Nenhum'),
  new Proxy(name: 'Jonny'),
  new Proxy(name: 'Venezia'),
  new Proxy(name: 'Orochimaru'),
];