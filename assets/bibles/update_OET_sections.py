# Script to automatically generate a dart file mapping the OET sections from the OET json files
# Requirements: Python 3

# The resulting dart file is formatted like so:
#
# Map<String, List<List<String>>> bookSectionNameMapping = {
#   'JHN': [
#     [
#       '1:1 First section',
#     ],
#     [
#       '1:21 Second section',
#     ],
#   ],
# };


import os
import json
from pathlib import Path 

RV_local_path = "./OET-RV/"
RV_output_path = "../../lib/common/oet_rv_sections.dart"

dart_file_template = """
// GENERATED FILE. DO NOT EDIT DIRECTLY

Map<String, List<List<String>>> bookSectionNameMapping = {};
"""


def read_json_file(path):
  with open(path, "r") as json_file:
    data = json.load(json_file)

    return data
  

def format_section(chapterNumber, verseNumber, section):
  return (f'{chapterNumber}:{verseNumber} {section}').replace('/s1', '') 


def generate_mappings_file():
  file_list = os.listdir(RV_local_path)

  sectionsMapping = {}

  for file in file_list:
    chapterSectionsList = []
    book_code = file.split('.')[0]
    data = read_json_file(f'{RV_local_path}{file}')

    for chapter in data['chapters']:
      sectionsList = []
      verseNumber = '1'
      chapterNumber = chapter['chapterNumber']
      chapterContents = chapter['contents']

      for item in chapterContents:

        if 'verseNumber' in item:
          verseNumber = item['verseNumber']

        if 's1' in item:
          s1 = item['s1']
          sectionsList.append(format_section(chapterNumber, verseNumber, s1))

        if 'rem' in item:
          rem = item['rem']
          sectionsList.append(format_section(chapterNumber, verseNumber, rem))

        if 'contents' in item:
          for innerItem in item['contents']:
            if type(innerItem) == dict:

              if 's1' in innerItem:
                if sectionsList == []:
                  sectionsList.append('-')
                chapterSectionsList.append(sectionsList)
                sectionsList = []

                s1 = innerItem['s1']
                sectionsList.append(format_section(chapterNumber, verseNumber, s1))

              if 'rem' in innerItem:
                rem = innerItem['rem']
                sectionsList.append(format_section(chapterNumber, verseNumber, rem))

      if sectionsList == []:
        sectionsList.append('-')
      chapterSectionsList.append(sectionsList)
    
    sectionsMapping[book_code] = chapterSectionsList

  contents = dart_file_template.format(str(sectionsMapping))

  with open(RV_output_path, "w") as file:
    file.write(contents)



if __name__ == "__main__":
  print("Generating...")
  generate_mappings_file()
  print("Generating complete.")

