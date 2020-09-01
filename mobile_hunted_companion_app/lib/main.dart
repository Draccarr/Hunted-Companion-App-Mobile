import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_hunted_companion_app/save-and-load.dart';
import 'package:path_provider/path_provider.dart';
import 'character.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(
        title: 'Hunted Companion',
        storage: SaveAndLoad(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, @required this.storage}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final SaveAndLoad storage;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Character _character = Character("", [], [], [], [], [], 0, 0, 0);
  TextEditingController _terminal = TextEditingController();
  int index = 0;
  String jayCommand;

  @override
  void initState() {
    super.initState();
    widget.storage.readText().then((String _value) {
      setState(() {
        jayCommand = _value;
        _terminal.text = _value;
        _saveClicked();
        log(_value);
      });
    });
  }

  void _saveClicked() {
    index == 0 ? _importData() : _exportData();
    //ToDo: Save the data locally here.
    jayCommand = _terminal.text;
    widget.storage.writeText(jayCommand);
    widget.storage.readText().then((String _value) {
      setState(() {
        jayCommand = _value;
        _terminal.text = _value;
      });
    });
  }

  void _exportData() {
    _terminal.text = "";
    _character.name = _character.name
        .replaceAll('\r', "")
        .replaceAll(';', "")
        .replaceAll('\n', "");
    _terminal.text += ":Jay: UC " + _character.name + " \n";
    ExportItems();
    ExportSkills();
    ExportStatuses();
    ExportNotes();
    ExportNames();
    _terminal.text += " Currency: " + _character.gold.toString() + " gold;\n";
    _terminal.text +=
        " Currency: " + _character.silver.toString() + " silver;\n";
    _terminal.text +=
        " Currency: " + _character.copper.toString() + " copper;\n";
  }

  void ExportNames() {
    _character.names.forEach((element) {
      _terminal.text += " Name: " + element.trim() + ";\n";
    });
  }

  void ExportNotes() {
    _character.notes.forEach((note) {
      if (!["", null, false, 0].contains(note.description)) {
        note.description = note.description
            .replaceAll('\r', "")
            .replaceAll(';', "")
            .replaceAll('\n', "");
        _terminal.text += " Note: " + note.description.trim() + ";\n";
      }
    });
  }

  void ExportStatuses() {
    _character.statuses.forEach((status) {
      if (!["", null, false, 0].contains(status.name)) {
        status.name = status.name
            .replaceAll('\r', "")
            .replaceAll(';', "")
            .replaceAll('\n', "");
        _terminal.text += " Status: " + status.name.trim() + ";\n";
      }
    });
  }

  void ExportSkills() {
    _character.skills.forEach((skill) {
      if (!["", null, false, 0].contains(skill.name)) {
        skill.name = skill.name
            .replaceAll('\r', "")
            .replaceAll(';', "")
            .replaceAll('\n', "");
        _terminal.text += " Skill: " +
            skill.name.trim() +
            " lvl " +
            skill.level.toString() +
            ";\n";
      }
    });
  }

  void ExportItems() {
    _character.items.forEach((item) {
      if (!["", null, false, 0].contains(item.name)) {
        item.name = item.name
            .replaceAll('\r', "")
            .replaceAll(';', "")
            .replaceAll('\n', "");
        _terminal.text += " Item: " +
            item.name.trim() +
            "(x " +
            item.quantity.toString() +
            ");\n";
      }
    });
  }

  void _importData() {
    setState(() {
      _character.items.clear();
      _character.skills.clear();
      _character.statuses.clear();
      _character.notes.clear();
      _character.names.clear();
      _character.copper = 0;
      _character.silver = 0;
      _character.gold = 0;

      //@Alek, why remove :Jay: and UC? The players need them if they are to
      //paste their commands back into Discord. What I was asking before was for
      //all the text in the terminal to be cleared after the save button had been pressed
      //so the player could quickly add another profile to another character sheet.
      //However, this is something that can be done in a future update/Next milestone.
      //
      //In short, I'm asking if you are good with removing these two lines.
      _terminal.text = _terminal.text.replaceAll(":Jay: ", "");
      _terminal.text = _terminal.text.replaceAll("UC ", "");

      String text = _terminal.text;
      List<String> parsedText = text.split('\n');
      parsedText.forEach((line) {
        try {
          if (line.contains(";")) {
            List<String> line1 = line.split(':');
            line1[1] = line1[1].replaceAll(";", "");
            if (line1[0].toLowerCase().contains("item")) {
              Item i = Item("", 0);
              line1[1] = line1[1].replaceAll(';', '');
              line1[1] = line1[1].replaceAll('\r', '');
              line1[1] = line1[1].trim();
              if (line1[1].toLowerCase().contains("(x")) {
                List<String> details = line1[1].toLowerCase().split("(x");
                i.name = details[0];
                String s = getFirstNumber(details[1]);
                if (int.tryParse(s) != null) i.quantity = int.tryParse(s);
              } else if (line1[1].toLowerCase().contains("x")) {
                List<String> details = line1[1].toLowerCase().split('x');
                int q = 0;
                String number = details.firstWhere((x) =>
                    getFirstNumber(x) != null && getFirstNumber(x) != "");
                if (number != null && number != "") {
                  i.name = line1[1]
                      .replaceAll(number, "")
                      .replaceAll('x', "")
                      .trim();
                  i.quantity = q;
                } else {
                  i.name = line1[1];
                  i.quantity = 1;
                }
              } else {
                i.name = line1[1];
                i.quantity = 1;
              }
              _character.items.add(i);
            } else if (line1[0].toLowerCase().contains("status")) {
              Status status = new Status("", "");
              status.name = line1[1].trim();
              _character.statuses.add(status);
            } else if (line1[0].toLowerCase().contains("skill")) {
              Skill skill = new Skill("", 0);
              if (line1[1].toLowerCase().contains("lv")) {
                skill.name = line1[1].split("lv")[0].trim();
                String s = line1[1].substring(
                    line1[1].toLowerCase().indexOf("lv"),
                    line1[1].toLowerCase().indexOf("lv") + 5);
                print(s);
                s = s.replaceAll("lv", "");
                s = s.replaceAll("l ", "").trim();
                s = getFirstNumber(s);
                skill.level = int.parse(s);
              } else {
                skill.name = line1[1];
                skill.level = 1;
              }
              _character.skills.add(skill);
            } else if (line1[0].toLowerCase().contains("note")) {
              Note note = new Note("", "");
              note.description = line1[1];
              _character.notes.add(note);
            } else if (line1[0].toLowerCase().contains("currency")) {
              if (line1[1].toLowerCase().contains("gold")) {
                String gold = "";
                for (int i = 0; i < line1[1].length; i++) {
                  if (int.tryParse(line1[1][i]) != null) {
                    gold += line1[1][i];
                  }
                }
                _character.gold = int.tryParse(gold);
              } else if (line1[1].toLowerCase().contains("silver")) {
                String silver = "";
                for (int i = 0; i < line1[1].length; i++) {
                  if (int.tryParse(line1[1][i]) != null) {
                    silver += line1[1][i];
                  }
                }
                _character.silver = int.tryParse(silver);
              } else if (line1[1].toLowerCase().contains("copper")) {
                String copper = "";
                for (int i = 0; i < line1[1].length; i++) {
                  if (int.tryParse(line1[1][i]) != null) {
                    copper += line1[1][i];
                  }
                }
                _character.copper = int.tryParse(copper);
              }
            } else if (line1[0].toLowerCase().contains("name")) {
              _character.names.add(line1[1].trim());
            }
          } else if (!["", null, false, 0].contains(line.trim())) {
            _character.name = line.trim();
          }
        } catch (ex) {
          print(ex);
        }
      });
    });
  }

  // I know your not supposed to null a string but... it won't work otherwise soo... I'll look into it later.
  String dropdownValue;
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            onTap: (index) {
              this.index = index;
            },
            tabs: [
              Tab(
                icon: Icon(Icons.airplay),
              ),
              Tab(
                icon: Icon(Icons.account_circle),
              )
            ],
          ),
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: TabBarView(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(25),
                child: TextField(
                    textAlignVertical: TextAlignVertical.top,
                    controller: _terminal,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    expands: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Paste character data here',
                    )),
              ),
            ),
            ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: DropdownButton<String>(
                          hint: Text(_character != null
                              ? _character.names.length > 0
                                  ? _character.names[0]
                                  : 'Empty...'
                              : 'Empty...'),
                          value: dropdownValue,
                          items: _character.names
                              .map((String _dropDownStringItem) {
                            return DropdownMenuItem<String>(
                              value: _dropDownStringItem,
                              child: Text(_dropDownStringItem),
                            );
                          }).toList(),
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownValue = newValue;
                            });
                          },
                        ),
                      ),
                      // Expanded(
                      //     child: DropdownButton(
                      //   value: dropdownValue,
                      //   icon: Icon(Icons.arrow_downward),
                      //   iconSize: 20,
                      //   elevation: 16,
                      //   style: TextStyle(color: Colors.black),
                      //   onChanged: (String newValue) {
                      //     setState(() {
                      //       dropdownValue = newValue;
                      //     });
                      //   },
                      //   items: <String>['A', 'B', 'C', 'D'].map((String value) {
                      //     return new DropdownMenuItem<String>(
                      //       value: value,
                      //       child: new Text(value),
                      //     );
                      //   }).toList(),
                      // )),
                      SizedBox(
                        width: 50,
                        child: TextFormField(
                          initialValue: _character.gold.toString(),
                          textAlign: TextAlign.end,
                          decoration: InputDecoration(
                            labelText: 'Gold',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: SizedBox(
                          width: 50,
                          child: TextFormField(
                            initialValue: _character.silver.toString(),
                            textAlign: TextAlign.end,
                            decoration: InputDecoration(
                              labelText: 'Silver',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        child: TextFormField(
                          initialValue: _character.copper.toString(),
                          textAlign: TextAlign.end,
                          decoration: InputDecoration(
                            labelText: 'Copper',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ExpansionTile(
                    title: Text('Items'),
                    expandedAlignment: Alignment.topLeft,
                    children: <Widget>[
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _character.items.length,
                        itemBuilder: (context, index) => ListTile(
                          trailing: Text('(x' +
                              _character.items[index].quantity.toString() +
                              ')'),
                          title: TextFormField(
                            initialValue: _character.items[index].name,
                            onChanged: (value) =>
                                _character.items[index].name = value,
                          ),
                        ),
                      ),
                    ]),
                ExpansionTile(
                    title: Text('Skills'),
                    expandedAlignment: Alignment.topLeft,
                    children: <Widget>[
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _character.skills.length,
                        itemBuilder: (context, index) => ListTile(
                          trailing: Text('Lv. ' +
                              _character.skills[index].level.toString()),
                          title: TextFormField(
                            initialValue: _character.skills[index].name,
                            onChanged: (value) =>
                                _character.skills[index].name = value,
                          ),
                        ),
                      ),
                    ]),
                ExpansionTile(
                    title: Text('Status'),
                    expandedAlignment: Alignment.topLeft,
                    children: <Widget>[
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _character.statuses.length,
                        itemBuilder: (context, index) => ListTile(
                          title: TextFormField(
                            initialValue: _character.statuses[index].name,
                            onChanged: (value) =>
                                _character.statuses[index].name = value,
                          ),
                        ),
                      ),
                    ]),
                ExpansionTile(
                    title: Text('Notes'),
                    expandedAlignment: Alignment.topLeft,
                    children: <Widget>[
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _character.notes.length,
                        itemBuilder: (context, index) => ListTile(
                          title: TextFormField(
                            initialValue: _character.notes[index].description,
                            onChanged: (value) =>
                                _character.notes[index].name = value,
                          ),
                        ),
                      ),
                    ]),
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _saveClicked,
          tooltip: 'Increment',
          child: Icon(Icons.save),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}

String getFirstNumber(String details) {
  String s = "";
  for (var i = 0; i < details.length; i++) {
    if (int.tryParse(details.substring(i, i + 1)) != null) {
      s += details.substring(i, i + 1);
    }
  }

  return s;
}
