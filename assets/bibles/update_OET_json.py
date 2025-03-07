# Script to automatically update the OET .json files from the ESFM sources on GitHub.
# Requirements: Python 3.10+, usfm_grammar, and the Requests package.

import re
import os
import json
import subprocess
from pathlib import Path 
import requests
from usfm_grammar import USFMParser, Filter


RV_SOURCE_URL = "https://raw.githubusercontent.com/Freely-Given-org/OpenEnglishTranslation--OET/main/translatedTexts/ReadersVersion/"
LV_SOURCE_URL = "https://raw.githubusercontent.com/Freely-Given-org/OpenEnglishTranslation--OET/main/intermediateTexts/auto_edited_VLT_ESFM/"

DOWNLOAD_DIR = "/.temp"
TEMP_FILEPATH = "/.temp/.temp"

RV_LOCAL_PATH = "/OET-RV/"
LV_LOCAL_PATH = "/OET-LV/"

RV_FILE_MAPPING = {
  # "OET-RV_GEN.ESFM": "GEN.json",
  # "OET-RV_EXO.ESFM": "EXO.json",
  # "OET-RV_LEV.ESFM": "LEV.json",
  # "OET-RV_NUM.ESFM": "NUM.json",
  # "OET-RV_DEU.ESFM": "DEU.json",
  # "OET-RV_JOS.ESFM": "JOS.json",
  # "OET-RV_JDG.ESFM": "JDG.json",
  # "OET-RV_RUT.ESFM": "RUT.json",
  # "OET-RV_SA1.ESFM": "SA1.json",
  # "OET-RV_SA2.ESFM": "SA2.json",
  # "OET-RV_KI1.ESFM": "KI1.json",
  # "OET-RV_KI2.ESFM": "KI2.json",
  # "OET-RV_CH1.ESFM": "CH1.json",
  # "OET-RV_CH2.ESFM": "CH2.json",
  # "OET-RV_EZR.ESFM": "EZR.json",
  # "OET-RV_NEH.ESFM": "NEH.json",
  # "OET-RV_EST.ESFM": "EST.json",
  # "OET-RV_JOB.ESFM": "JOB.json",
  # "OET-RV_PSA.ESFM": "PSA.json",
  # "OET-RV_PRO.ESFM": "PRO.json",
  # "OET-RV_ECC.ESFM": "ECC.json",
  # "OET-RV_SNG.ESFM": "SNG.json",
  # "OET-RV_ISA.ESFM": "ISA.json",
  # "OET-RV_JER.ESFM": "JER.json",
  # "OET-RV_LAM.ESFM": "LAM.json",
  # "OET-RV_EZE.ESFM": "EZE.json",
  # "OET-RV_DAN.ESFM": "DAN.json",
  # "OET-RV_HOS.ESFM": "HOS.json",
  # "OET-RV_JOL.ESFM": "JOL.json",
  # "OET-RV_AMO.ESFM": "AMO.json",
  # "OET-RV_OBA.ESFM": "OBA.json",
  # "OET-RV_JNA.ESFM": "JNA.json",
  # "OET-RV_MIC.ESFM": "MIC.json",
  # "OET-RV_RUT.ESFM": "RUT.json",
  # "OET-RV_NAH.ESFM": "NAH.json",
  # "OET-RV_HAB.ESFM": "HAB.json",
  # "OET-RV_ZEP.ESFM": "ZEP.json",
  # "OET-RV_HAG.ESFM": "HAG.json",
  # "OET-RV_ZEC.ESFM": "ZEC.json",
  # "OET-RV_MAL.ESFM": "MAL.json",

  "OET-RV_MAT.ESFM": "MAT.json",
  "OET-RV_MRK.ESFM": "MRK.json",
  "OET-RV_LUK.ESFM": "LUK.json",
  "OET-RV_JHN.ESFM": "JHN.json",
  "OET-RV_ACT.ESFM": "ACT.json",
  "OET-RV_ROM.ESFM": "ROM.json",
  "OET-RV_CO1.ESFM": "CO1.json",
  "OET-RV_CO2.ESFM": "CO2.json",
  "OET-RV_GAL.ESFM": "GAL.json",
  "OET-RV_EPH.ESFM": "EPH.json",
  "OET-RV_PHP.ESFM": "PHP.json",
  "OET-RV_COL.ESFM": "COL.json",
  "OET-RV_TH1.ESFM": "TH1.json",
  "OET-RV_TH2.ESFM": "TH2.json",
  "OET-RV_TI1.ESFM": "TI1.json",
  "OET-RV_TI2.ESFM": "TI2.json",
  "OET-RV_TIT.ESFM": "TIT.json",
  "OET-RV_PHM.ESFM": "PHM.json",
  "OET-RV_HEB.ESFM": "HEB.json",
  "OET-RV_JAM.ESFM": "JAM.json",
  "OET-RV_PE1.ESFM": "PE1.json",
  "OET-RV_PE2.ESFM": "PE2.json",
  "OET-RV_JN1.ESFM": "JN1.json",
  "OET-RV_JN2.ESFM": "JN2.json",
  "OET-RV_JN3.ESFM": "JN3.json",
  "OET-RV_JDE.ESFM": "JDE.json",
  "OET-RV_REV.ESFM": "REV.json",
}

LV_FILE_MAPPING = {
  # "OET-LV_GEN.ESFM": "GEN.json",
  # "OET-LV_EXO.ESFM": "EXO.json",
  # "OET-LV_LEV.ESFM": "LEV.json",
  # "OET-LV_NUM.ESFM": "NUM.json",
  # "OET-LV_DEU.ESFM": "DEU.json",
  # "OET-LV_JOS.ESFM": "JOS.json",
  # "OET-LV_JDG.ESFM": "JDG.json",
  # "OET-LV_RUT.ESFM": "RUT.json",
  # "OET-LV_SA1.ESFM": "SA1.json",
  # "OET-LV_SA2.ESFM": "SA2.json",
  # "OET-LV_KI1.ESFM": "KI1.json",
  # "OET-LV_KI2.ESFM": "KI2.json",
  # "OET-LV_CH1.ESFM": "CH1.json",
  # "OET-LV_CH2.ESFM": "CH2.json",
  # "OET-LV_EZR.ESFM": "EZR.json",
  # "OET-LV_NEH.ESFM": "NEH.json",
  # "OET-LV_EST.ESFM": "EST.json",
  # "OET-LV_JOB.ESFM": "JOB.json",
  # "OET-LV_PSA.ESFM": "PSA.json",
  # "OET-LV_PRO.ESFM": "PRO.json",
  # "OET-LV_ECC.ESFM": "ECC.json",
  # "OET-LV_SNG.ESFM": "SNG.json",
  # "OET-LV_ISA.ESFM": "ISA.json",
  # "OET-LV_JER.ESFM": "JER.json",
  # "OET-LV_LAM.ESFM": "LAM.json",
  # "OET-LV_EZE.ESFM": "EZE.json",
  # "OET-LV_DAN.ESFM": "DAN.json",
  # "OET-LV_HOS.ESFM": "HOS.json",
  # "OET-LV_JOL.ESFM": "JOL.json",
  # "OET-LV_AMO.ESFM": "AMO.json",
  # "OET-LV_OBA.ESFM": "OBA.json",
  # "OET-LV_JNA.ESFM": "JNA.json",
  # "OET-LV_MIC.ESFM": "MIC.json",
  # "OET-LV_RUT.ESFM": "RUT.json",
  # "OET-LV_NAH.ESFM": "NAH.json",
  # "OET-LV_HAB.ESFM": "HAB.json",
  # "OET-LV_ZEP.ESFM": "ZEP.json",
  # "OET-LV_HAG.ESFM": "HAG.json",
  # "OET-LV_ZEC.ESFM": "ZEC.json",
  # "OET-LV_MAL.ESFM": "MAL.json",

  "OET-LV_MAT.ESFM": "MAT.json",
  "OET-LV_MRK.ESFM": "MRK.json",
  "OET-LV_LUK.ESFM": "LUK.json",
  "OET-LV_JHN.ESFM": "JHN.json",
  "OET-LV_ACT.ESFM": "ACT.json",
  "OET-LV_ROM.ESFM": "ROM.json",
  "OET-LV_CO1.ESFM": "CO1.json",
  "OET-LV_CO2.ESFM": "CO2.json",
  "OET-LV_GAL.ESFM": "GAL.json",
  "OET-LV_EPH.ESFM": "EPH.json",
  "OET-LV_PHP.ESFM": "PHP.json",
  "OET-LV_COL.ESFM": "COL.json",
  "OET-LV_TH1.ESFM": "TH1.json",
  "OET-LV_TH2.ESFM": "TH2.json",
  "OET-LV_TI1.ESFM": "TI1.json",
  "OET-LV_TI2.ESFM": "TI2.json",
  "OET-LV_TIT.ESFM": "TIT.json",
  "OET-LV_PHM.ESFM": "PHM.json",
  "OET-LV_HEB.ESFM": "HEB.json",
  "OET-LV_JAM.ESFM": "JAM.json",
  "OET-LV_PE1.ESFM": "PE1.json",
  "OET-LV_PE2.ESFM": "PE2.json",
  "OET-LV_JN1.ESFM": "JN1.json",
  "OET-LV_JN2.ESFM": "JN2.json",
  "OET-LV_JN3.ESFM": "JN3.json",
  "OET-LV_JDE.ESFM": "JDE.json",
  "OET-LV_REV.ESFM": "REV.json",
}

# Download the ESFM file.
def download_esfm_file(download_url) -> str:
  print("Downloading ESFM source file from", download_url)

  response = requests.get(download_url)

  if response.ok:
    # Save the ESFM file to the download directory
    path = Path(os.getcwd() + f'/{DOWNLOAD_DIR}/{filename}')
    path.touch() # Create file if it doesn't exist

    with open(path, "w", encoding="utf-8") as file:
      file.write(response.text)
      file.close()
    return path
  else:
    print(f"Failed to download the ESFM source file. The request status code is {response.status_code}.")
    return ""


# Download and convert the ESFM contents to (USJ) json.
# ESFM for the OET-LV has the \untr marker which is not in USFM, 
# so we temporarily substitute \untr with \no so that it converts.
# In the resulting (USJ) json, the \untr is replaced with untr (no backslash).
def convert_esfm_to_json(filename, esfm_source_url, local_path, FILE_MAPPING, esfm_workaround=False):
  download_url = f"{esfm_source_url}{filename}"
  download_path = download_esfm_file(download_url)

  print(f"Converting {filename} to json...")
  if download_path != "":
    with open(download_path, "r", encoding="utf-8") as file:
      input_esfm = file.read()
      file.close()

    # Swap \untr with \no so that the USFM parser is happy.
    if esfm_workaround == True:
      input_esfm = replace_untr_with_no(str(input_esfm))
    
    # Convert to (USJ) JSON.
    parser = USFMParser(input_esfm)
    converted_json = parser.to_usj()

    errors = parser.errors
    if errors != []:
      print(f"The following errors were encountered when converting the ESFM to json:\n {errors}")

    # Change all \no markers back to \untr.
    if esfm_workaround == True:
      # Save converted json to a temporary file
      path = Path(os.getcwd() + f'/{TEMP_FILEPATH}')
      path.touch() # Create file if it doesn't exist
      with open(path, "w", encoding="utf-8") as temp_file:
        json.dump(converted_json, temp_file, ensure_ascii=False)
        temp_file.close()

      with open (path, "r", encoding="utf-8") as temp_file:
        temp_file_contents = temp_file.read()
        temp_file.close()

      # Replace all \no markers with untr.
      converted_json = json.loads(replace_no_with_untr(str(temp_file_contents)))

    json_filepath = f"{os.getcwd()}{local_path}{FILE_MAPPING[filename]}"
    with open(json_filepath, "w", encoding="utf-8") as file:
      json.dump(converted_json, file, indent=1, ensure_ascii=False)
      file.close()

    print("Converted ESFM to json.")
  else:
    print("Converting ESFM to json failed.")


def replace_untr_with_no(input_esfm):
  return re.sub(r"(\\untr)", "\\no", input_esfm)

def replace_no_with_untr(input_usj):
  return re.sub(r"(\\no)", re.escape(r"untr"), input_usj)


if __name__ == "__main__":
  print("\nConverting the Reader's version...")
  for filename in RV_FILE_MAPPING.keys():
    convert_esfm_to_json(filename, RV_SOURCE_URL, RV_LOCAL_PATH, RV_FILE_MAPPING)

  print("\nConverting the Literal version...")
  for filename in LV_FILE_MAPPING.keys():
    convert_esfm_to_json(filename, LV_SOURCE_URL, LV_LOCAL_PATH, LV_FILE_MAPPING, esfm_workaround=True)

  print("\nDone! The converted .json files are in the /RV/ and /LV/ folders.")