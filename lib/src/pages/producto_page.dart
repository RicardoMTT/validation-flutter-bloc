import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttervalidation/src/models/producto_model.dart';
import 'package:fluttervalidation/src/providers/productos_provider.dart';
import 'package:fluttervalidation/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final productoProvider = new ProductosProvider();
  File foto;
  ProductoModel producto = new ProductoModel();
  bool _guardando = false;
  @override
  Widget build(BuildContext context) {
    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;

    if (prodData != null) {
      producto = prodData;
    }
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Product'),
        actions: [
          IconButton(
              icon: Icon(Icons.photo_size_select_actual),
              onPressed: () {
                seleccionarFoto();
              }),
          IconButton(
              icon: Icon(Icons.camera_alt_outlined),
              onPressed: () {
                tomarFoto();
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
              key: formKey,
              child: Column(
                children: [
                  _mostrarFoto(),
                  _crearNombre(),
                  _crearPrecio(),
                  _crearDisponible(),
                  _crearBoton(context)
                ],
              )),
        ),
      ),
    );
  }

  _crearNombre() {
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Producto'),
      onSaved: (value) => producto.titulo = value,
      validator: (value) {
        if (value.length < 3) {
          return "Ingrese el nombre del producto";
        } else {
          return null;
        }
      },
    );
  }

  _crearPrecio() {
    return TextFormField(
      keyboardType: TextInputType.number,
      onSaved: (value) => producto.valor = double.parse(value),
      initialValue: producto.valor.toString(),
      decoration: InputDecoration(labelText: 'Precio'),
      validator: (value) {
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return "Solo numeros";
        }
      },
    );
  }

  _crearBoton(BuildContext context) {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      color: Colors.deepPurple,
      textColor: Colors.white,
      label: Text('Guardar'),
      onPressed: _guardando == true
          ? null
          : () {
              _submit(context);
            },
      icon: Icon(Icons.save),
    );
  }

  void _submit(BuildContext context) async {
    if (!formKey.currentState.validate()) {
      return;
    }
    formKey.currentState.save();

    setState(() {
      _guardando = true;
    });

    if (foto != null) {
      producto.fotoUrl = await productoProvider.subirImagen(foto);
    }

    print('okokok');
    print(producto.valor);
    print(producto.titulo);
    print(producto.disponible);
    if (producto.id == null) {
      productoProvider.crearProducto(producto);
    } else {
      productoProvider.editarProducto(producto);
    }

    // setState(() {
    //   _guardando = false;
    // });
    mostrarSnackbar('Registro guardado');
    Navigator.pop(context);
  }

  _crearDisponible() {
    return SwitchListTile(
      value: producto.disponible,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState(() => {producto.disponible = value}),
    );
  }

  mostrarSnackbar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 2000),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  _mostrarFoto() {
    if (producto.fotoUrl != null) {
      return FadeInImage(
        placeholder: AssetImage('assets/loading.gig'),
        height: 300,
        fit: BoxFit.cover,
        image: NetworkImage(producto.fotoUrl),
      );
    } else {
      return Image(
        image: AssetImage(foto?.path ?? 'assets/no-image.png'),
        height: 300,
        fit: BoxFit.cover,
      );
    }
  }

  void seleccionarFoto() async {
    foto = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (foto != null) {
      //Limpieza
      producto.fotoUrl = null;
    }

    setState(() {});
  }

  void tomarFoto() {}
}
