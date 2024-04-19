/// Mapping book codes to the full book name
Map<String, dynamic> booksMapping = {
  'TORAH': {
    'name': 'Torah',
    'books': {
      'GEN': 'Genesis',
      'EXO': 'Exodus',
      'LEV': 'Leviticus',
      'NUM': 'Numbers',
      'DEU': 'Deuteronomy',
    }
  },
  'HISTORY': {
    'name': 'History',
    'books': {
      'JOS': 'Joshua',
      'JDG': 'Judges',
      'RUT': 'Ruth',
      'SA1': '1 Samuel',
      'SA2': '2 Samuel',
      'KI1': '1 Kings',
      'KI2': '2 Kings',
      'CH1': '1 Chronicles',
      'CH2': '2 Chronicles',
      'EZR': 'Ezra',
      'NEH': 'Nehemiah',
      'EST': 'Esther',
    }
  },
  'POETRY_WISDOM': {
    'name': 'Poetry/Wisdom',
    'books': {
      'JOB': 'Job',
      'PSA': 'Psalms',
      'PRO': 'Proverbs',
      'ECC': 'Ecclesiastes',
      'SNG': 'Song of Solomon',
    }
  },
  'MAJOR_PROPHETS': {
    'name': 'Major Prophets',
    'books': {
      'ISA': 'Isaiah',
      'JER': 'Jeremiah',
      'LAM': 'Lamentations',
      'EZE': 'Ezekiel',
      'DAN': 'Daniel',
    }
  },
  'MINOR_PROPHETS': {
    'name': 'Minor Prophets',
    'books': {
      'HOS': 'Hosea',
      'JOL': 'Joel',
      'AMO': 'Amos',
      'OBA': 'Obadiah',
      'JNA': 'Jonah',
      'MIC': 'Micah',
      'NAH': 'Nahum',
      'HAB': 'Habakkuk',
      'ZEP': 'Zephaniah',
      'HAG': 'Haggai',
      'ZEC': 'Zechariah',
      'MAL': 'Malachi',
    }
  },
  'GOSPELS': {
    'name': 'Gospels',
    'books': {
      'JHN': 'John',
      'MRK': 'Mark',
      'MAT': 'Matthew',
      'LUK': 'Luke',
    }
  },
  'ACTS': {
    'name': 'Acts',
    'books': {
      'ACT': 'Acts',
    }
  },
  'PAULS_EPISTLES': {
    'name': "Paul's Epistles",
    'books': {
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
    }
  },
  'GENERAL_EPISTLES': {
    'name': 'General Epistles',
    'books': {
      'HEB': 'Hebrews',
      'JAM': 'James',
      'PE1': '1 Peter',
      'PE2': '2 Peter',
      'JN1': '1 John',
      'JN2': '2 John',
      'JN3': '3 John',
      'JDE': 'Jude',
    }
  },
  'REVELATION': {
    'name': 'Revelation',
    'books': {
      'REV': 'Revelation',
    }
  }
};

/// Mapping bookCodes to the number of chapters in each book
Map<String, int> bookNumOfChaptersMapping = {
  'GEN': 50,
  'EXO': 40,
  'LEV': 27,
  'NUM': 36,
  'DEU': 34,
  'JOS': 24,
  'JDG': 21,
  'RUT': 4,
  'SA1': 31,
  'SA2': 24,
  'KI1': 22,
  'KI2': 25,
  'CH1': 29,
  'CH2': 36,
  'EZR': 10,
  'NEH': 13,
  'EST': 16,
  'JOB': 42,
  'PSA': 150,
  'PRO': 31,
  'ECC': 12,
  'SNG': 8,
  'ISA': 66,
  'JER': 52,
  'LAM': 5,
  'EZE': 48,
  'DAN': 12,
  'HOS': 14,
  'JOL': 4,
  'AMO': 9,
  'OBA': 1,
  'JNA': 4,
  'MIC': 7,
  'NAH': 3,
  'HAB': 3,
  'ZEP': 3,
  'HAG': 2,
  'ZEC': 14,
  'MAL': 3,
  'JHN': 21,
  'MAT': 28,
  'MRK': 16,
  'LUK': 24,
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
