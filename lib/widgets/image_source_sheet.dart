/*import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageSourceSheet extends StatelessWidget {
  
  final Function(File) onImageSelected;

  void imageSelected(File image) {
    if(image != null){
    onImageSelected(image);
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      builder: (context) => Column(
        children: <Widget>[
          FlatButton(
            child: Text("Câmera"),
            onPressed: () async{
              File image = await ImagePicker.pickImage(source: ImageSource.camera);
              ImageSelected(image);
            }
          ),   

          FlatButton(
            child: Text("Galeria"),
            onPressed: () async {
              File image = await ImagePicker.pickImage(source: ImageSource.gallery);
              ImageSelected(image);

            }
          ),    
      ],
      ), onClosing: () {},
    );
  }
}

*/