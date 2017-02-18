import 'package:flutter/material.dart';

void main() {
  runApp(new MyApp());

}

final List<Proxy> _kProxies = <Proxy>[
  new Proxy(name: 'Charles'),
  new Proxy(name: 'Squid'),
  new Proxy(name: 'Mitm'),
];

class MyApp extends StatelessWidget {
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
      home: new ProxyList(proxies: _kProxies),

    );
  }
}

class ProxyList extends StatefulWidget {
  ProxyList({Key key, this.proxies}) : super(key: key);

  final List<Proxy> proxies;

  // The framework calls createState the first time a widget appears at a given
  // location in the tree. If the parent rebuilds and uses the same type of
  // widget (with the same key), the framework will re-use the State object
  // instead of creating a new State object.

  @override
  _ProxyListState createState() => new _ProxyListState();
}

class _ProxyListState extends State<ProxyList> {
  Set<Proxy> _proxyCart = new Set<Proxy>();

  void _handleCartChanged(Proxy proxy, bool inCart) {
    setState(() {
      // When user changes what is in the cart, we need to change _proxyCart
      // inside a setState call to trigger a rebuild. The framework then calls
      // build, below, which updates the visual appearance of the app.

      if (inCart)
        _proxyCart.add(proxy);
      else
        _proxyCart.remove(proxy);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            title: new Text('Juran'),
            ),
        body: new MaterialList(
            type: MaterialListType.oneLineWithAvatar,
            children: config.proxies.map((Proxy proxy) {
              return new ProxyListItem(
                  proxy: proxy,
                  inCart: _proxyCart.contains(proxy),
                  onCartChanged: _handleCartChanged,
                  );
            }),
            ),
        );
  }
}

class Proxy {
  const Proxy({this.name});
  final String name;
}

typedef void CartChangedCallback(Proxy proxy, bool inCart);

class ProxyListItem extends StatelessWidget {
  ProxyListItem({Proxy proxy, this.inCart, this.onCartChanged})
      : proxy = proxy,
        super(key: new ObjectKey(proxy));

  final Proxy proxy;
  final bool inCart;
  final CartChangedCallback onCartChanged;

  Color _getColor(BuildContext context) {
    // The theme depends on the BuildContext because different parts of the tree
    // can have different themes.  The BuildContext indicates where the build is
    // taking place and therefore which theme to use.

    return inCart ? Colors.black54 : Theme.of(context).primaryColor;
  }

  TextStyle _getTextStyle(BuildContext context) {
    if (!inCart) return null;

    return new TextStyle(
        color: Colors.black54,
        decoration: TextDecoration.lineThrough,
        );
  }

  @override
  Widget build(BuildContext context) {
    return new ListItem(
        onTap: () {
          onCartChanged(proxy, !inCart);
        },
        leading: new CircleAvatar(
            backgroundColor: _getColor(context),
            child: new Text(proxy.name[0]),
            ),
        title: new Text(proxy.name, style: _getTextStyle(context)),
        );
  }
}

