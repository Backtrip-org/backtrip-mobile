import 'dart:core';
import 'dart:io';
import 'package:backtrip/model/user_stats.dart';
import 'package:backtrip/model/user.dart';
import 'package:backtrip/service/user_service.dart';
import 'package:backtrip/util/backtrip_api.dart';
import 'package:backtrip/util/components.dart';
import 'package:backtrip/view/common/confirm_picked_image_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileWidget extends StatefulWidget {
  final User _user;

  UserProfileWidget(this._user);

  @override
  _UserProfileWidgetState createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  _UserProfileWidgetState();

  final _picker = ImagePicker();
  User _user;
  Future<UserStats> _futureUserStats;
  Future<Widget> _futureCircleAvatar;

  @override
  void initState() {
    super.initState();
    _user = widget._user;
    getCircleAvatar();
    getStats();
  }

  void getCircleAvatar() {
    this.setState(() {
      _futureCircleAvatar =
          Components.getParticipantCircularAvatar(_user, initialsFontSize: 35);
    });
  }

  void getStats() {
    this.setState(() {
      _futureUserStats = UserService.getStats(_user.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page de profil'),
        leading: BackButton(onPressed: () => Navigator.pop(context, _user)),
      ),
      body: Column(
        children: [header(), SizedBox(height: 40), indicators()],
      ),
    );
  }

  Widget header() {
    return Container(
        height: 220,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 20.0, offset: Offset(0.0, 0.1))
        ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [avatar(), SizedBox(height: 20), name()],
        ));
  }

  Widget avatar() {
    return Container(
      height: 120,
      width: 160,
      child: FutureBuilder<Widget>(
          future: _futureCircleAvatar,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Stack(children: [
                Positioned(
                    left: 20,
                    child: Container(
                        width: 120, height: 120, child: snapshot.data)),
                Visibility(
                    visible: BacktripApi.currentUser.id == _user.id,
                    child: Positioned(
                        top: 84,
                        left: 120,
                        child: IconButton(
                            icon: Icon(Icons.edit,
                                color: Theme.of(context).accentColor),
                            onPressed: () => _updateProfilePicture(context))))
              ]);
            } else if (snapshot.hasError) {
              return Components.snackBar(context, 'Une erreur est survenue',
                  Theme.of(context).errorColor);
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  Widget name() {
    return Container(
      height: 30,
      alignment: Alignment.center,
      child: Text(
        _user.getFullName(),
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25),
      ),
    );
  }

  Widget indicators() {
    return Expanded(
        child: FutureBuilder<UserStats>(
            future: _futureUserStats,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Wrap(
                  spacing: 15,
                  runSpacing: 15,
                  children: [
                    indicatorCard(Icons.import_contacts,
                        snapshot.data.tripsNumber, "voyages"),
                    indicatorCard(
                        Icons.flag, snapshot.data.stepsNumber, "étapes"),
                    indicatorCard(Icons.place, snapshot.data.countriesVisited,
                        "pays visités"),
                    indicatorCard(Icons.account_balance,
                        snapshot.data.citiesVisited, "villes visitées")
                  ],
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return Center(child: CircularProgressIndicator());
            }));
  }

  Widget indicatorCard(IconData icon, int value, String description) {
    return SizedBox(
        width: 150,
        child: Card(
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(children: [
                  Icon(icon, color: Theme.of(context).primaryColor),
                  SizedBox(height: 13),
                  Text(value.toString(),
                      style: Theme.of(context).textTheme.headline),
                  SizedBox(height: 2),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.subhead,
                  )
                ]))));
  }

  void _updateProfilePicture(BuildContext scaffoldContext) async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    final file = File(pickedFile.path);
    showUploadPhotoConfirmationDialog(scaffoldContext, file,
        () => _uploadProfilePicture(scaffoldContext, file));
  }

  void _uploadProfilePicture(BuildContext scaffoldContext, File pickedImage) {
    UserService.updateProfilePicture(_user.id, pickedImage).then((file) {
      Components.snackBar(scaffoldContext,
          'La photo de profil a bien été mise à jour', Colors.green);
      _user.picturePath = file.id;
      getCircleAvatar();
    }).catchError((error) {
      Components.snackBar(scaffoldContext, 'Une erreur est survenue',
          Theme.of(context).errorColor);
    });
    Navigator.of(context).pop();
  }
}
