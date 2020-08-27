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