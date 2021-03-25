import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import 'components/profile_photo.dart';
import '../../provider/user.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = "/profile-details";
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();

  @override
  void initState() => super.initState();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return new Scaffold(
        appBar: AppBar(
          title: const Text("Informacion Personal"),
        ),
        body: new ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  height: 180,
                  child: ProfilePhoto(),
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      'Informacion Personal',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    _status ? _getEditIcon() : Container(),
                                  ],
                                )
                              ],
                            )),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: TextFormField(
                              initialValue: user.userData.name,
                              decoration: InputDecoration(
                                hintText: "Ingresa tu Nombre",
                                labelText: 'Nombre',
                                labelStyle: defaultTextStyle(),
                              ),
                              enabled: !_status,
                              autofocus: !_status,
                              onChanged: (newValue) =>
                                  user.userData.name = newValue),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: TextFormField(
                              initialValue: user.userData.surname,
                              decoration: InputDecoration(
                                hintText: "Ingresa tu Apellido",
                                labelText: 'Apellido',
                                labelStyle: defaultTextStyle(),
                              ),
                              enabled: !_status,
                              autofocus: !_status,
                              onChanged: (newValue) =>
                                  user.userData.surname = newValue),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: TextFormField(
                              initialValue: user.userData.mail,
                              decoration: InputDecoration(
                                hintText: "Ingresa tu Correo",
                                labelText: 'Correo',
                                labelStyle: defaultTextStyle(),
                              ),
                              enabled: !_status,
                              autofocus: !_status,
                              onChanged: (newValue) =>
                                  user.userData.mail = newValue),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: TextFormField(
                              initialValue: user.userData.userName,
                              decoration: InputDecoration(
                                hintText: "Ingresa se usuario",
                                labelText: 'Usuario',
                                labelStyle: defaultTextStyle(),
                              ),
                              enabled: !_status,
                              autofocus: !_status,
                              onChanged: (newValue) =>
                                  user.userData.userName = newValue),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: TextFormField(
                              initialValue: user.userData.birthDate.toString(),
                              decoration: InputDecoration(
                                hintText: "Ingresa tu fecha de nacimiento",
                                labelText: 'Fecha de nacimiento',
                                labelStyle: defaultTextStyle(),
                              ),
                              enabled: !_status,
                              autofocus: !_status,
                              onChanged: (newValue) =>
                                  user.userData.birthDate = newValue),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: TextFormField(
                            initialValue: user.userData.city.toString(),
                            decoration: InputDecoration(
                              hintText: "Ingresa tu Ciudad",
                              labelText: 'Ciudad',
                              labelStyle: defaultTextStyle(),
                            ),
                            enabled: !_status,
                            autofocus: !_status,
                            onChanged: (newValue) =>
                                user.userData.city = int.parse(newValue),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: DropdownButtonFormField(
                            items: user
                                .getDocumentTypeOptions()
                                .map(
                                  (type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type),
                                  ),
                                )
                                .toList(),
                            value: user.userData.documentType,
                            autofocus: !_status,
                            onChanged: (newValue) =>
                                user.userData.documentType = newValue,
                            hint: const Text("Tipo de documento"),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: TextFormField(
                            initialValue: user.userData.document,
                            decoration: InputDecoration(
                              hintText: "Ingresa su documento",
                              labelText: 'Documento de identidad',
                              labelStyle: defaultTextStyle(),
                            ),
                            enabled: !_status,
                            autofocus: !_status,
                            onChanged: (newValue) =>
                                user.userData.document = newValue,
                          ),
                        ),
                        !_status ? _getActionButtons() : Container(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  TextStyle defaultTextStyle() {
    return TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: RaisedButton(
                child: const Text("Save"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(FocusNode());
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: RaisedButton(
                child: const Text("Cancel"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(FocusNode());
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return GestureDetector(
      child: CircleAvatar(
        backgroundColor: kPrimaryColor,
        radius: 20.0,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}
