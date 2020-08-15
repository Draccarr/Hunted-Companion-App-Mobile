import 'package:flutter/material.dart';

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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Character _character = Character([], [], [], [], [], 0, 0, 0);
  TextEditingController _terminal = TextEditingController();

  void _importData() {
    setState(() {
      _character.items.clear();
      _character.skills.clear();
      _character.statuses.clear();
      _character.notes.clear();
      _character.names.clear();

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
                String s = GetFirstNumbers(details[1]);
                if (int.tryParse(s) != null) i.quantity = int.tryParse(s);
              } else if (line1[1].toLowerCase().contains("x")) {
                List<String> details = line1[1].toLowerCase().split('x');
                int q = 0;
                String number = details.firstWhere((x) =>
                    GetFirstNumbers(x) != null && GetFirstNumbers(x) != "");
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
                s = GetFirstNumbers(s);
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
          }
        } catch (ex) {
          print(ex);
        }
      });
    });
  }

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
            TextField(
              controller: _terminal,
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
            ListView.builder(
              itemCount: _character.skills.length,
              itemBuilder: (context, index) =>
                  Text(_character.skills[index].name),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _importData,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}

class Item {
  String name;
  int quantity;
  Item(this.name, this.quantity);
}

class Skill {
  String name;
  int level;
  Skill(this.name, this.level);
}

class Status {
  String name;
  String description;
  Status(this.name, this.description);
}

class Note {
  String name;
  String description;
  Note(this.name, this.description);
}

class Character {
  List<String> names;
  List<Item> items;
  List<Skill> skills;
  List<Status> statuses;
  List<Note> notes;
  int gold;
  int silver;
  int copper;
  Character(this.names, this.items, this.skills, this.statuses, this.notes,
      this.silver, this.copper, this.gold);
}

String GetFirstNumbers(String details) {
  String s = "";
  for (var i = 0; i < details.runes.length; i++) {
    if (int.tryParse(details.runes.elementAt(i).toString()) != null) {
      s += details.runes.elementAt(i).toString();
    }
  }

  return s;
}
