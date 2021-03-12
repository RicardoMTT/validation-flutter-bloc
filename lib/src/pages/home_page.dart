import 'package:flutter/material.dart';
import 'package:fluttervalidation/src/blocs/provider.dart';
import 'package:fluttervalidation/src/models/producto_model.dart';
import 'package:fluttervalidation/src/providers/productos_provider.dart';

class HomePage extends StatelessWidget {
  final productosProvider = new ProductosProvider();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.deepPurple,
      ),
      body: _crearListado(),
      floatingActionButton: _crearBoton(context),
    );
  }

  _crearBoton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, 'producto');
      },
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
    );
  }

  Widget _crearListado() {
    return FutureBuilder(
      future: productosProvider.cargarProductos(),
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if (snapshot.hasData) {
          final productos = snapshot.data;
          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (BuildContext context, index) =>
                _crearItem(context, productos[index]),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _crearItem(BuildContext context, ProductoModel producto) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(color: Colors.red),
      onDismissed: (direccion) {
        productosProvider.borrarProducto(producto.id);
      },
      child: Card(
        child: Column(
          children: [
            (producto.fotoUrl == null)
                ? Image(image: AssetImage('assets/no-image.png'))
                : FadeInImage(
                    placeholder: AssetImage('assets/loading.gif'),
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    image: NetworkImage(producto.fotoUrl)),
            ListTile(
              title: Text('${producto.titulo}-${producto.valor}'),
              subtitle: Text('${producto.id}'),
              onTap: () {
                Navigator.pushNamed(context, 'producto', arguments: producto);
              },
            )
          ],
        ),
      ),
    );
  }
}

/*

Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('email ${bloc.email}'),
          Divider(
            thickness: 2,
          ),
          Text('password ${bloc.password}'),
        ],
      ),
 */
