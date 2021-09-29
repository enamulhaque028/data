import 'dart:math';
import 'package:convertly/config/common_const.dart';
import 'package:convertly/model/dropdown_model.dart';
import 'package:flutter/material.dart';

class DropdownSettings extends StatefulWidget {
  final String defaultValue;
  final List<Value> values;
  const DropdownSettings({
    Key? key,
    required this.defaultValue,
    required this.values,
  }) : super(key: key);
  @override
  DropdownSettingsState createState() => new DropdownSettingsState();
}

class DropdownSettingsState extends State<DropdownSettings> {
  String dropDownValue = '';
  late int _key;

  _collapse() {
    int newKey = 1;
    do {
      _key = new Random().nextInt(10000);
    } while (newKey == _key);
  }

  @override
  void initState() {
    dropDownValue = widget.defaultValue;
    super.initState();
    _collapse();
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(color: Color(PrimaryColor));
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: new ExpansionTile(
            iconColor: Color(PrimaryColor),
            collapsedIconColor: Color(PrimaryColor),
            key: new Key(_key.toString()),
            initiallyExpanded: false,
            title: new Text(this.dropDownValue),
            //backgroundColor: Theme.of(context).accentColor.withOpacity(0.025),
            children: [
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.values.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(widget.values[index].name, style: textStyle),
                      onTap: () {
                        setState(() {
                          this.dropDownValue = widget.values[index].name;
                          _collapse();
                        });
                        print(widget.values[index].value);
                      },
                    );
                  }),
            ]),
      ),
    );
  }
}
