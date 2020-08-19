import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loginform/src/blocs/provider.dart';
import 'package:loginform/src/model/producto_model.dart';

import 'package:loginform/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProductoPage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formkey = GlobalKey<FormState>();
  final scafoldkey = GlobalKey<ScaffoldState>();
  ProductoModel producto = new ProductoModel();

  ProductosBloc productosBloc;
/*   final productoProvider = new ProductoProvider(); */

  bool _guardando = false;
  File foto;

  @override
  Widget build(BuildContext context) {

    productosBloc = Provider.productosBloc(context);

    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;
    if (prodData != null) {
      producto = prodData;
    }

    return Scaffold(
      key: scafoldkey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _tomarFoto,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formkey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                _crearBoton(),
                _crearDisponible(),
              
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Producto'),
      onSaved: (value) => producto.titulo = value,
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese el nombre del producto';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Precio',
      ),
      onSaved: (value) => producto.valor = double.parse(value),
      validator: (value) {
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return 'solo numeros';
        }
      },
    );
  }

  _crearBoton() {
    return RaisedButton.icon(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        color: Colors.deepPurple,
        textColor: Colors.white,
        onPressed: (_guardando) ? null : _submit,
        icon: Icon(Icons.save),
        label: Text('Guardar'));
  }

  Widget _crearDisponible() {
    return SwitchListTile(
      value: producto.disponible,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState(() {
        producto.disponible = value;
      }),
    );
  }

  void _submit() async{
    if (!formkey.currentState.validate()) return;

    formkey.currentState.save();

    setState(() {
      _guardando = true;
    });

    if(foto!= null) {
      producto.fotoUrl  = await productosBloc.subirFoto(foto);
    }

    if (producto.id == null) {
      productosBloc.agregarProducto(producto);
    } else {
      productosBloc.editarProducto(producto);
    }

    setState(() {
      _guardando = false;
    });

    mostrarSnackBar('Registro guardado');

    Navigator.pop(context);
  }

  void mostrarSnackBar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );
    scafoldkey.currentState.showSnackBar(snackbar);
  }

  Widget _mostrarFoto(){

      if (producto.fotoUrl != null) {
 
      return FadeInImage(
        image: NetworkImage(producto.fotoUrl),
        placeholder: AssetImage('assets/loading.gif'),
        height: 300.0,
        fit: BoxFit.cover,        
      );
 
    } else {
 
      if( foto != null ){
        return Image.file(
          foto,
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset('assets/no-image.png');
    }
  }

  void _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  }


  void _tomarFoto() async {

    _procesarImagen(ImageSource.camera);

  }

  _procesarImagen (ImageSource origen) async {

    foto = await ImagePicker.pickImage(
      source: origen
      );
      if( foto != null) {
        producto.fotoUrl = null;
      }

      setState(() {
        
      });
  }


}
