import 'dart:io';

import 'package:loginform/src/model/producto_model.dart';
import 'package:loginform/src/providers/productos_provider.dart';
import 'package:rxdart/rxdart.dart';

class ProductosBloc {
  final _productosController = new BehaviorSubject<List<ProductoModel>>();
  final _cargandoController = new BehaviorSubject<bool>();
  final _productosProvider = new ProductoProvider();

  Stream<List<ProductoModel>> get productosStream => _productosController;
  Stream<bool> get cargando => _cargandoController;

  void cargarProductos() async {
    final productos = await _productosProvider.cargarProducto();
    _productosController.sink.add(productos);
  }

  void agregarProducto(ProductoModel producto) async {
    _cargandoController.sink.add(true);
    await _productosProvider.crearProducto(producto);
    _cargandoController.sink.add(true);
  }

  Future<String> subirFoto(File foto) async {
    _cargandoController.add(true);
    final fotoUrl = await _productosProvider.subirImagen(foto);
    _cargandoController.sink.add(false);
    return fotoUrl;
  }

  void editarProducto(ProductoModel producto) async {
    _cargandoController.add(true);
    await _productosProvider.editarProducto(producto);
    _cargandoController.add(false);
  }

  void borrarProducto(String id) async {
    
    await _productosProvider.borrarProducto(id);
    
  }

  dispose() {
    _productosController?.close();
    _cargandoController?.close();
  }
}
