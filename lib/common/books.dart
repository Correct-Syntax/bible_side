import 'enums.dart';

/// Mapping book codes to the full book name
///
/// [traditionalOrder] If true, use the traditional order and names.
Map<String, String> getBookMapping(BookMapping mapping) {
  // Traditional ordering and names
  Map<String, String> traditionalBookMapping = {
    'MAT': 'Matthew',
    'MRK': 'Mark',
    'LUK': 'Luke',
    'JHN': 'John',
    'ACT': 'Acts',
    'ROM': 'Romans',
    'CO1': '1 Corinthians',
    'CO2': '2 Corinthians',
    'GAL': 'Galatians',
    'EPH': 'Ephesians',
    'PHP': 'Philippians',
    'COL': 'Colossians',
    'TH1': '1 Thessalonians',
    'TH2': '2 Thessalonians',
    'TI1': '1 Timothy',
    'TI2': '2 Timothy',
    'TIT': 'Titus',
    'PHM': 'Philemon',
    'HEB': 'Hebrews',
    'JAM': 'James',
    'PE1': '1 Peter',
    'PE2': '2 Peter',
    'JN1': '1 John',
    'JN2': '2 John',
    'JN3': '3 John',
    'JDE': 'Jude',
    'REV': 'Revelation',
  };

  // OET ordering and names
  // TODO
  Map<String, String> theOETBookMapping = {
    'JHN': 'John',
    'MRK': 'Mark',
    'MAT': 'Matthew',
    'LUK': 'Luke',
    'ACT': 'Acts',
    'ROM': 'Romans',
    'CO1': '1 Corinthians',
    'CO2': '2 Corinthians',
    'GAL': 'Galatians',
    'EPH': 'Ephesians',
    'PHP': 'Philippians',
    'COL': 'Colossians',
    'TH1': '1 Thessalonians',
    'TH2': '2 Thessalonians',
    'TI1': '1 Timothy',
    'TI2': '2 Timothy',
    'TIT': 'Titus',
    'PHM': 'Philemon',
    'HEB': 'Hebrews',
    'JAM': 'James',
    'PE1': '1 Peter',
    'PE2': '2 Peter',
    'JN1': '1 John',
    'JN2': '2 John',
    'JN3': '3 John',
    'JDE': 'Jude',
    'REV': 'Revelation',
  };

  if (mapping == BookMapping.traditional) {
    return traditionalBookMapping;
  } else {
    return theOETBookMapping;
  }
}

/// Mapping bookCodes to the number of chapters in each book
Map<String, int> bookNumOfChaptersMapping = {
  'MAT': 28,
  'MRK': 16,
  'LUK': 24,
  'JHN': 21,
  'ACT': 28,
  'ROM': 16,
  'CO1': 16,
  'CO2': 13,
  'GAL': 6,
  'EPH': 6,
  'PHP': 4,
  'COL': 4,
  'TH1': 5,
  'TH2': 3,
  'TI1': 6,
  'TI2': 4,
  'TIT': 3,
  'PHM': 1,
  'HEB': 13,
  'JAM': 5,
  'PE1': 5,
  'PE2': 3,
  'JN1': 5,
  'JN2': 1,
  'JN3': 1,
  'JDE': 1,
  'REV': 22,
};
