import 'dart:io';

import 'package:flutter/material.dart';

Future<void> showUploadPhotoConfirmationDialog(BuildContext context, File pickedImage, Function confirmAction) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(children: [
          Icon(Icons.add_a_photo),
          SizedBox(width: 10),
          Text('Confirmation')
        ]),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Container(
                height: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    image: DecorationImage(
                        fit: BoxFit.fitWidth, image: FileImage(pickedImage))),
              ),
              SizedBox(height: 20),
              Center(child: Text('Voulez-vous envoyer cette image ?')),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('ANNULER'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('CONFIRMER'),
            onPressed: confirmAction,
          ),
        ],
      );
    },
  );
}