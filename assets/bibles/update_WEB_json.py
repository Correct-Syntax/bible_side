# Script to update the WEB translation json files.
# Since the WEB is complete, updating would only be to fix typos, etc.
# Requirements: Python 3.10+ and the usfm_grammar package.
#
# Instructions:
# 1. Download the source USFM files from https://ebible.org/find/show.php?id=eng-web
# 2. Unzip the folder.
# 3. Rename the folder to "WEB" and place it in ``/assets/bibles/.temp/``.
# 4. Run this script to convert the USFM to JSON.

import re
import os
import json
from usfm_grammar import USFMParser, Filter

FILE_MAPPING = {
  "02-GENeng-web.usfm": "GEN.json",
  "03-EXOeng-web.usfm": "EXO.json",
  "04-LEVeng-web.usfm": "LEV.json",
  "05-NUMeng-web.usfm": "NUM.json",
  "06-DEUeng-web.usfm": "DEU.json",
  "07-JOSeng-web.usfm": "JOS.json",
  "08-JDGeng-web.usfm": "JDG.json",
  "09-RUTeng-web.usfm": "RUT.json",
  "10-1SAeng-web.usfm": "SA1.json",
  "11-2SAeng-web.usfm": "SA2.json",
  "12-1KIeng-web.usfm": "KI1.json",
  "13-2KIeng-web.usfm": "KI2.json",
  "14-1CHeng-web.usfm": "CH1.json",
  "15-2CHeng-web.usfm": "CH2.json",
  "16-EZReng-web.usfm": "EZR.json",
  "17-NEHeng-web.usfm": "NEH.json",
  "18-ESTeng-web.usfm": "EST.json",
  "19-JOBeng-web.usfm": "JOB.json",
  "20-PSAeng-web.usfm": "PSA.json",
  "21-PROeng-web.usfm": "PRO.json",
  "22-ECCeng-web.usfm": "ECC.json",
  "23-SNGeng-web.usfm": "SNG.json",
  "24-ISAeng-web.usfm": "ISA.json",
  "25-JEReng-web.usfm": "JER.json",
  "26-LAMeng-web.usfm": "LAM.json",
  "27-EZKeng-web.usfm": "EZE.json",
  "28-DANeng-web.usfm": "DAN.json",
  "29-HOSeng-web.usfm": "HOS.json",
  "30-JOLeng-web.usfm": "JOL.json",
  "31-AMOeng-web.usfm": "AMO.json",
  "32-OBAeng-web.usfm": "OBA.json",
  "33-JONeng-web.usfm": "JNA.json",
  "34-MICeng-web.usfm": "MIC.json",
  "35-NAMeng-web.usfm": "NAH.json",
  "36-HABeng-web.usfm": "HAB.json",
  "37-ZEPeng-web.usfm": "ZEP.json",
  "38-HAGeng-web.usfm": "HAG.json",
  "39-ZECeng-web.usfm": "ZEC.json",
  "40-MALeng-web.usfm": "MAL.json",

  "70-MATeng-web.usfm": "MAT.json",
  "71-MRKeng-web.usfm": "MRK.json",
  "72-LUKeng-web.usfm": "LUK.json",
  "73-JHNeng-web.usfm": "JHN.json",
  "74-ACTeng-web.usfm": "ACT.json",
  "75-ROMeng-web.usfm": "ROM.json",
  "76-1COeng-web.usfm": "CO1.json",
  "77-2COeng-web.usfm": "CO2.json",
  "78-GALeng-web.usfm": "GAL.json",
  "79-EPHeng-web.usfm": "EPH.json",
  "80-PHPeng-web.usfm": "PHP.json",
  "81-COLeng-web.usfm": "COL.json",
  "82-1THeng-web.usfm": "TH1.json",
  "83-2THeng-web.usfm": "TH2.json",
  "84-1TIeng-web.usfm": "TI1.json",
  "85-2TIeng-web.usfm": "TI2.json",
  "86-TITeng-web.usfm": "TIT.json",
  "87-PHMeng-web.usfm": "PHM.json",
  "88-HEBeng-web.usfm": "HEB.json",
  "89-JASeng-web.usfm": "JAM.json",
  "90-1PEeng-web.usfm": "PE1.json",
  "91-2PEeng-web.usfm": "PE2.json",
  "92-1JNeng-web.usfm": "JN1.json",
  "93-2JNeng-web.usfm": "JN2.json",
  "94-3JNeng-web.usfm": "JN3.json",
  "95-JUDeng-web.usfm": "JDE.json",
  "96-REVeng-web.usfm": "REV.json",
}

SOURCE_PATH = "/.temp/WEB/"
LOCAL_PATH = "/WEB/"


def convert_usfm_to_json(filename, source_path, local_path):
  usfm_filepath = f"{os.getcwd()}{source_path}{filename}"
  with open(usfm_filepath, "r", encoding="utf-8") as file:
    input_usfm = file.read()
    file.close()

  # To avoid enormous file sizes, we cleanup the text.
  input_usfm = collapse_strong_numbers(clean_text(input_usfm))

  # Convert to (USJ) JSON.
  parser = USFMParser(input_usfm)
  converted_json = parser.to_usj()

  errors = parser.errors
  if errors != []:
    print(f"The following errors were encountered when converting the USFM to JSON:\n {errors}")

  json_filepath = f"{os.getcwd()}{local_path}{FILE_MAPPING[filename]}"
  with open(json_filepath, "w", encoding="utf-8") as file:
    json.dump(converted_json, file, indent=1, ensure_ascii=False)
    file.close()
  
  print("Converted USFM to JSON.")

def clean_text(text):
  # - remove all \w markers
  # - convert all | to a pipe: ¦
  return text.replace("\\w*", "").replace("\\+w*", "").replace("\\w", "").replace("\\+w", "").replace("|", "¦")

def collapse_strong_numbers(text):
  # - remove all escaped quotes
  # - remove redundant "strong=" (we use the pipe ¦ as a separator)
  # - strip out all extra spaces
  #
  # Given a string like:
  # In¦strong=\"H8064\"  the¦strong=\"H1254\"  beginning¦strong=\"H7225\",  God¦strong=\"H8064\"
  # this method will produce:
  # In¦H8064 the¦H1254 beginning¦H7225, God¦H8064
  return re.sub(r'\s+', ' ', text.replace('\"', "").replace("strong=", ""))


if __name__ == "__main__":
  print("\nConverting the World English Bible...")
  for filename in FILE_MAPPING.keys():
    print(f"\nConverting {filename} to JSON...")
    convert_usfm_to_json(filename,  SOURCE_PATH, LOCAL_PATH)
  print("\nDone! The converted JSON files are in the /WEB/ folder.")