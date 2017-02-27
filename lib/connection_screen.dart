
import 'package:flutter/material.dart';

class ConnectionScreen extends StatefulWidget {
  ConnectionScreen({Key key, this.wifies, this.proxies}) : super(key: key);

  final Page firstPage = new Page(name: 'Wifi');
  final Page secondPage = new Page(name: 'Proxy');

  final List<Proxy> wifies;
  final List<Proxy> proxies;

  @override
  _TabsDemoState createState() => new _TabsDemoState();
}

class _TabsDemoState extends State<ConnectionScreen> {
  Page _selectedPage;

  Proxy _proxyCart = new Proxy(name: "Nenhum");

  void _handleCartChanged(Proxy proxy, bool inCart) {
    setState(() {
      // When user changes what is in the cart, we need to change _proxyCart
      // inside a setState call to trigger a rebuild. The framework then calls
      // build, below, which updates the visual appearance of the app.

      if (!inCart)
        _proxyCart = proxy;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedPage = config.firstPage;
  }

  @override
  Widget build(BuildContext context) {
    final pagesList = [config.firstPage, config.secondPage].toList();
    return new TabBarSelection<Page>(
        values: pagesList,
        onChanged: (Page value) {
          setState(() {
            _selectedPage = value;
          });
        },
        child: new Scaffold(
            scrollableKey: _selectedPage.scrollableKey,
            appBar: new AppBar(
                title: new Text('Juran'),
                bottom: new TabBar<Page>(
                    labels: new Map<Page, TabLabel>.fromIterable(
                        pagesList,
                        value: (Page page) {
                          return new TabLabel(text: page.name);
                        }),
                ),
            ),
            body: new TabBarView<Page>(
                children: [config.firstPage, config.secondPage].map((Page page) {
                  return new MaterialList(
                      scrollableKey: page.scrollableKey,
                      type: MaterialListType.oneLineWithAvatar,
                      children: config.proxies.map((Proxy proxy) {
                        return new ProxyListItem(
                            proxy: proxy,
                            inCart: _proxyCart.name == proxy.name,
                            onCartChanged: _handleCartChanged,
                            );
                      }),
                  );
                }).toList()
            )
        )
    );
  }
}

class Page {
  Page({ this.name });
  final String name;
  final GlobalKey<ScrollableState> scrollableKey = new GlobalKey<ScrollableState>();
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

    return !inCart ? Colors.black54 : Theme.of(context).primaryColor;
  }

  TextStyle _getTextStyle(BuildContext context) {
    if (inCart) return null;

    return new TextStyle(
        color: Colors.black54,
        decoration: TextDecoration.lineThrough,
        );
  }

  @override
  Widget build(BuildContext context) {
    return new ListItem(
        onTap: () {
          onCartChanged(proxy, inCart);
        },
        leading: new CircleAvatar(
            backgroundColor: _getColor(context),
            child: new Text(proxy.name[0]),
            ),
        title: new Text(proxy.name, style: _getTextStyle(context)),
        );
  }
}