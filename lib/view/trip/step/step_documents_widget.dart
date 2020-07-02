import 'dart:core';
import 'package:backtrip/model/file.dart';
import 'package:backtrip/service/file_service.dart';
import 'package:backtrip/util/components.dart';
import 'package:backtrip/util/file_manager.dart';
import 'package:backtrip/view/common/empty_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:backtrip/model/step/step.dart' as step_model;
import 'package:intl/date_symbol_data_local.dart';

class StepDocumentsWidget extends StatefulWidget {
  final step_model.Step _step;

  StepDocumentsWidget(this._step);

  @override
  _StepDocumentsWidgetState createState() => _StepDocumentsWidgetState();
}

class _StepDocumentsWidgetState extends State<StepDocumentsWidget> {
  step_model.Step _step;

  @override
  void initState() {
    super.initState();
    _step = widget._step;
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(_step.name),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, _step),
            )),
        floatingActionButton: Builder(
          builder: (ctx) {
            return FloatingActionButton(
                onPressed: _pickDocument, child: Icon(Icons.add));
          },
        ),
        body: body());
  }

  Widget body() {
    return Container(
        padding: EdgeInsets.all(15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Documents",
            style: Theme.of(context).textTheme.headline,
          ),
          Divider(),
          Expanded(
              child: _step.getDocuments().length > 0
                  ? documentsList(_step.getDocuments())
                  : EmptyListWidget(
                      "Aucun document n'a été mis à disposition ici",
                      "Envoyez-en un !"))
        ]));
  }

  Widget documentsList(List<File> documents) {
    return Container(
        child: Builder(
            builder: (scaffoldContext) => ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(Icons.insert_drive_file),
                      title: Text(documents[index].getFileName()),
                      subtitle:
                          Text(documents[index].getFormattedCreationDate()),
                      onTap: () =>
                          _showDownloadConfirmation(documents[index], context),
                    );
                  },
                )));
  }

  Future<void> _showDownloadConfirmation(
      File file, BuildContext parentContext) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(children: [
            Icon(Icons.file_download),
            SizedBox(width: 10),
            Text('Téléchargement')
          ]),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(
                    child: Text(
                        'Voulez-vous télécharger le fichier ${file.getFileName()} ?')),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('NON'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('OUI'),
              onPressed: () => _downloadFile(file, parentContext),
            ),
          ],
        );
      },
    );
  }

  void _downloadFile(File file, BuildContext parentContext) {
    FileService.get(file.id).then((bytes) {
      FileManager.downloadToLocalDirectory(bytes, file.name, file.extension);
    }).then((value) {
      Components.snackBar(
          parentContext,
          'Le fichier ${file.getFileName()} est disponible dans vos téléchargements !',
          Colors.green);
    }).catchError((error) {
      Components.snackBar(parentContext, 'Une erreur est survenue',
          Theme.of(context).errorColor);
    });
    Navigator.of(context).pop();
  }

  void _pickDocument() {}
}
