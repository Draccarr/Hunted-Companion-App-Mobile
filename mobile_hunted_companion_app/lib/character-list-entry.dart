import 'package:flutter/material.dart';
import 'character.dart';

class CharacterListEntry {
  final String title;
  final List<CharacterListEntry> children;

  CharacterListEntry(this.title,
      [this.children = const <CharacterListEntry>[]]);
} //end CharacterListEntry class

final List<CharacterListEntry> data = <CharacterListEntry>[
  CharacterListEntry('Items', <CharacterListEntry>[
    CharacterListEntry('Staff'),
    CharacterListEntry('Pen'),
    CharacterListEntry('Ink'),
  ]),
  CharacterListEntry('Skills', <CharacterListEntry>[
    CharacterListEntry('Magic'),
    CharacterListEntry('Book Binding'),
    CharacterListEntry('Public speaking'),
  ]),
  CharacterListEntry('Statuses', <CharacterListEntry>[
    CharacterListEntry('Imortal'),
    CharacterListEntry('Speed Buff LV 5'),
    CharacterListEntry('Strength Buff LV 5'),
  ]),
  CharacterListEntry('Notes', <CharacterListEntry>[
    CharacterListEntry('Chasms hold secrets...'),
  ]),
];
