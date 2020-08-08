import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Constants {
  static int key;
  static double width;
  static double height;

  // This is the actual db filename: that is saved in the docs dir
  static final dbName = "MaroziDatabase.db";

  // Increment this version when you need to change the schema
  static final dbVersion = 1;

  static double _halfPlayerWidth = 32.5;

  static double _landscapeW(double per) {
    return height * per / 100 - _halfPlayerWidth;
  }

  static double _landscapeH(double per) {
    return width * per / 100;
  }

  static Map<String, Offset> offsetLandscape = {
    'Martial': Offset(_landscapeW(41.45), _landscapeH(0.2)),
    'Bruno': Offset(_landscapeW(41.45), _landscapeH(21.5)),
    'Rashford': Offset(_landscapeW(21.5), _landscapeH(21.5)),
    'Greenwood': Offset(_landscapeW(61.5), _landscapeH(21.5)),
    'Pogba': Offset(_landscapeW(31.5), _landscapeH(39.5)),
    'McTominay': Offset(_landscapeW(51.5), _landscapeH(39.5)),
    'Wan-bisaka': Offset(_landscapeW(73), _landscapeH(61)),
    'Shaw': Offset(_landscapeW(10), _landscapeH(61)),
    'Bailly': Offset(_landscapeW(58), _landscapeH(61)),
    'Maguire': Offset(_landscapeW(24.7), _landscapeH(61)),
    'De Gea': Offset(_landscapeW(41.45), _landscapeH(63.3)),
    'LS': Offset(_landscapeW(11.5), _landscapeH(0.2)),
    'RS': Offset(_landscapeW(71.5), _landscapeH(0.2)),
    'LDM': Offset(_landscapeW(10.5), _landscapeH(39.5)),
    'RDM': Offset(_landscapeW(72.5), _landscapeH(39.5)),
  };

  static List<String> formations = [
    '4-2-3-1',
    '4-3-3',
    '4-4-2',
    '4-1-2-1-2',
    '4-1-4-1',
    '3-4-3',
    '3-2-2-3',
    '3-3-3-1',
    '5-4-1',
    '5-3-2',
  ];

  static List<String> listExport = [
    'Braven',
    'Glory Red',
    'B&W',
    'The Bleu',
    'Royal White',
    'Red Devils'
  ];

  static List<String> playersName() {
    return [
      "Landon Donovan",
      " Mia Hamm",
      "Abby Wambach",
      "Alfredo Di Stéfano",
      "Diego Maradona",
      "Lionel Messi",
      "José Manuel Moreno",
      "Omar Sivori",
      "Didi",
      "Artur Friedenreich",
      "Garrincha",
      "Kaká",
      "Leônidas",
      "Marta",
      "Neymar",
      "Pelé",
      "Rivaldo",
      "Romário",
      "Ronaldo",
      "Sócrates",
      "Vavá",
      "Ivor John Allchurch",
      "Viv Anderson",
      "Kenneth George Aston",
      "Alan James Ball",
      "David Beckham",
      "George Best",
      "Billy Bremner",
      "Matthew Busby",
      "Tommy Burns",
      "Matthew Busby",
      "Bobby Charlton",
      "Brian Howard Clough",
      "Denis Charles Scott Compton",
      "Stanley Cullis",
      "Dixie Dean",
      "Justin Fashanu",
      "Alex Ferguson",
      "Steven Gerrard",
      "Johnny Haynes",
      "Emlyn Walter Hughes",
      "Thomas Lawton",
      "Stanley Matthews",
      "Jackie Milburn",
      "Arthur Milton",
      "Bobby Moore",
      "Peter Leslie Osgood",
      "Alfred Ernest Ramsey",
      "Bobby Robson",
      "Wayne Rooney",
      "George Hedley Swindin",
      "William Ambrose Wright",
      "Hristo Stoichkov",
      "Samuel Eto’o",
      "Roger Milla",
      'Paul Pogba',
      'Marcus Rashford',
      'Bruno Fernandes',
      'Odion Ighalo',
      'Anthony Martial',
      'Bournemouth',
      'Mason Greenwood',
      'Daniel James',
      'Angel Gomes',
      'Harry Maguire',
      'Fred',
      'David De Gea',
      'Jesse Lingard',
      'Brandon Williams',
      'Juan Mata',
      'Aaron Wan-Bissaka',
      'Scott McTominay',
      'Andreas Pereira',
      'Tahith Chong',
      'Nemanja Matić',
      'Diogo Dalot',
      'Eric Bertrand Bailly',
      'Luke Shaw',
      'Phil Jones',
      'Victor Lindelöf',
      'Teden Mengi',
      'Sergio Romero',
      'James Garner',
      'Axel Tuanzebe',
      'Largie Ramazani',
      'Lee Grant',
      'Timothy Fosu-Mensah',
      'Joel Castro Pereira',
      'Ethan Laird',
      'Dylan Levitt',
      'Cameron Borthwick-Jackson',
      'Ethan Galbraith',
      'Matej Kovar',
      'Di\'Shon Bernard',
      'D\'Mani Mellor',
      'Arnau Puigmal',
      'Ethan Hamilton',
      'Max Dunne',
      'Joan Gamper ',
      'Carles Comamala',
      'Paulino Alcántara',
      'Ramón Torralba',
      'Josep Samitier',
      'Vicenc Piera',
      'Ferenc Plattkó',
      'Juan José Nogués',
      'Alejandro Morera Soto',
      'Martí Ventolrà',
      'Josep Raich',
      'Josep Escolà',
      'Mariano Martín',
      'Francisco Calvet',
      'José Bravo',
      'César Rodrìguez',
      'José Puig Puig',
      'Marià Gonzalvo',
      'Jaume Elías',
      'Juan Velasco',
      'Josep Seguer',
      'Josep Gonzalvo',
      'Estanislao Basora',
      'Antoni Ramallets',
      'Joan Segarra',
      'László Kubala',
      'Eduardo Manchón',
      'Gustau Biosca',
      'Sígfrid Gràcia',
      'Justo Tejada',
      'Luis Suárez',
      'Ramón Villaverde',
      'Eulogio Martínez',
      'Enric Gensana',
      'Martí Vergés',
      'Ferran Olivella',
      'Evaristo de Macedo',
      'Sándor Kocsis',
      'José Manuel Pesudo',
      'Pedro Zaballa',
      'Julio César Benítez',
      'Jesús María Pereda',
      'Salvador Sadurní',
      'José Antonio Zaldúa',
      'Cayetano Ré',
      'Josep Maria Fusté',
      'Eladio Silvestre',
      'Joaquim Rifé',
      'Antoni Torres',
      'Gallego',
      'Carles Rexach',
      'Miguel Reina',
      'Pedro María Zabalza',
      'Juan Carlos Pérez',
      'Marcial Pina',
      'Juan Manuel Asensi',
      'Quique Costas',
      'Antonio de la Cruz',
      'Hugo Sotil',
      'Migueli',
      'Johan Neeskens',
      'Pedro María Artola',
      'José Vicente Sánchez',
      'José Antonio Ramos Huete',
      'Antonio Olmo',
      'Esteban Vigo',
      'Francisco José Carrasco',
      'Hans Krankl',
      'Allan Simonsen',
      'José Ramón Alexanko',
      'Quini',
      'Bernd Schuster',
      'Josep Moratalla',
      'Javier Urruticoechea',
      'Gerardo Miranda',
      'Víctor Muñoz',
      'Diego Maradona',
      'Marcos Alonso Peña',
      'ulio Alberto Moreno',
      'Urbano Ortega',
      'Ramón Calderé',
      'Gary Lineker',
      'Mark Hughes',
      'Roberto Fernández',
      'Andoni Zubizarreta',
      'Guillermo Amor',
      'Txiki Begiristain',
      'Ricardo Serna',
      'Andoni Goikoetxea',
      'Julio Salinas',
      'Eusebio Sacristán',
      'José Mari Bakero',
      'Michael Laudrup',
      'Ronald Koeman',
      'Albert Ferrer',
      'Hristo Stoichkov',
      'Pep Guardiola',
      'Miguel Ángel Nadal',
      'Sergi',
      'Romário',
      'Gheorghe Hagi',
      'Abelardo',
      'Gheorghe Popescu',
      'Luís Figo',
      'Luis Enrique',
      'Michael Reiziger',
      'Rivaldo',
      'Frank de Boer',
      'Phillip Cocu',
      'Patrick Kluivert',
      'Xavi',
      'Gabri',
      'Carles Puyol',
      'Thiago Motta',
      'Javier Saviola',
      'Oleguer',
      'Víctor Valdés',
      'Andrés Iniesta',
      'Ronaldinho',
      'Giovanni van Bronckhorst',
      'Rafael Márquez',
      'Deco',
      'Gianluca Zambrotta',
      'Bojan',
      'Yaya Touré',
      'Eric Abidal',
      'Dani Alves',
      'Seydou Keita',
      'Sergio Busquets',
      'Gerard Piqué',
      'Pedro',
      'Adriano',
      'David Villa',
      'Javier Mascherano',
      'Jordi Alba',
      'Neymar ',
      'Luis Suárez ',
      'Ivan Rakitić ',
    ];
  }
}
