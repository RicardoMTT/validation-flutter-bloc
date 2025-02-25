import 'dart:io';

import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';
import 'package:fluttervalidation/src/models/producto_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductosProvider {
  final String _url =
      'https://flutter-varios-360f8-default-rtdb.firebaseio.com';

  Future<bool> crearProducto(ProductoModel producto) async {
    final url = '$_url/productos.json';
    print(producto.toString());
    final resp = await http.post(url,
        body:
            productoModelToJson(producto)); // body debe ser el modelo en String
    final decodedData = json.decode(resp.body);
    print(decodedData);
    return true;
  }

  Future<bool> editarProducto(ProductoModel producto) async {
    final url = '$_url/productos/${producto.id}.json';
    print(producto.toString());
    final resp = await http.put(url,
        body:
            productoModelToJson(producto)); // body debe ser el modelo en String
    final decodedData = json.decode(resp.body);
    print(decodedData);
    return true;
  }

  Future<List<ProductoModel>> cargarProductos() async {
    final url = '$_url/productos.json';
    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<ProductoModel> productos = new List();
    if (decodedData == null) {
      return [];
    }
    decodedData.forEach((id, prod) {
      final prodtemp = ProductoModel.fromJson(prod);
      prodtemp.id = id;
      productos.add(prodtemp);
    });
    print(productos);

    return productos;
  }

  Future<int> borrarProducto(String id) async {
    final url = '$_url/productos/$id.json';
    final resp = await http.delete(url);
    print(json.decode(resp.body));
    return 1;
  }

  Future<String> subirImagen(File imagen) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dgjkpffot/image/upload?upload_preset=zp7hbzdh');

    final mimeType = mime(imagen.path);

    final imageUploadRequest = http.MultipartRequest('POST', url);
    final file = await http.MultipartFile.fromPath('file', imagen.path,
        contentType: MediaType(mimeType[0], mimeType[1]));

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();

    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      return null;
    }
    final respData = json.decode(resp.body);
    return respData['secure_url'];
  }
}
