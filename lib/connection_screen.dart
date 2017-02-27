
import 'package:flutter/material.dart';

class ConnectionScreen extends StatefulWidget {
  ConnectionScreen({Key key, this.wifies, this.proxies}) : super(key: key);

  final List<Proxy> wifies;
  final List<Proxy> proxies;

  // The framework calls createState the first time a widget appears at a given
  // location in the tree. If the parent rebuilds and uses the same type of
  // widget (with the same key), the framework will re-use the State object
  // instead of creating a new State object.

  //@override
  //_ProxyListState createState() => new _ProxyListState();
  @override
  _TabsDemoState createState() => new _TabsDemoState();
}

class Page {
  Page({ this.name });
  final String name;
  final GlobalKey<ScrollableState> scrollableKey = new GlobalKey<ScrollableState>();
}


class _TabsDemoState extends State<ConnectionScreen> {
  Page _selectedPage;
  Page first = new Page(name: 'Wifi');
  Page second = new Page(name: 'Proxy');

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
    _selectedPage = first;
  }

  @override
  Widget build(BuildContext context) {
    return new TabBarSelection<Page>(
        values: [first, second].toList(),
        onChanged: (Page value) {
          setState(() {
            _selectedPage = value;
          });
        },
        child: new Scaffold(
            scrollableKey: _selectedPage.scrollableKey,
            body: new TabBarView<Page>(
                children: [first, second].map((Page page) {
                  /*return new ScrollableList(
                      scrollableKey: page.scrollableKey,
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      itemExtent: 272.0,

                      children: _allPages[page].map((_CardData data) {
                        return new Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: new _CardDataItem(page: page, data: data)
                        );
                      }).toList()
                  );*/
                  return new MaterialList(
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


// Proxy
class _ProxyListState extends State<ConnectionScreen> {
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
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new MaterialList(
            type: MaterialListType.oneLineWithAvatar,
            children: config.proxies.map((Proxy proxy) {
              return new ProxyListItem(
                  proxy: proxy,
                  inCart: _proxyCart.name == proxy.name,
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