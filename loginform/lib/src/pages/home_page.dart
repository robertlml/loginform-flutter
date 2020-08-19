import 'package:flutter/material.dart';
import 'package:loginform/src/blocs/provider.dart';
import 'package:loginform/src/model/producto_model.dart';
import 'package:loginform/src/providers/productos_provider.dart';

class HomePage extends StatefulWidget {
  //final productosProvider = new ProductoProvider();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {

    final productosBloc = Provider.productosBloc(context);
    productosBloc.cargarProductos();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: _crearListado(productosBloc),
      floatingActionButton: _crearBoton(context),
    );
  }

  _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: () => Navigator.pushNamed(context, 'producto').then((value) => setState((){})),
    );
  }

  Widget _crearListado(ProductosBloc productosBloc) {

    return StreamBuilder(
      stream: productosBloc.productosStream,
      builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot){
         if (snapshot.hasData) {
          final productos = snapshot.data;

          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, i) => _crearItem(productos[i],productosBloc ,context),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      });
   /*  return FutureBuilder(
      future: productosProvider.cargarProducto(),
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if (snapshot.hasData) {
          final productos = snapshot.data;

          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, i) => _crearItem(productos[i], context),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    ); */
  }

  Widget _crearItem(ProductoModel producto,ProductosBloc productosBloc, BuildContext context) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (direccion) {
          // Borrar producto
          //productoProvider.borrarProducto(producto.id);
          productosBloc.borrarProducto(producto.id);
        },
        child: Card(
          child: Column(
            children: <Widget>[
              (producto.fotoUrl == null)
                  ? Image(image: AssetImage('assets/no-image.png'))
                  : FadeInImage(
                      placeholder: AssetImage('assets/loading.gif'),
                      image: NetworkImage(producto.fotoUrl),
                      height: 300.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),

              ListTile(
                title: Text('${producto.titulo} - ${producto.valor}'),
                subtitle: Text(producto.id),
                onTap: () => Navigator.pushNamed(context, 'producto',
                    arguments: producto).then((value) => setState((){})),
              ),
              
            ],
          ),
        ));
  }
}
