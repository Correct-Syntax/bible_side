# Script to automatically update the OET .json files from the ESFM sources on GitHub
# Requirements: npm, Python 3, and the Python Requests package

import os
import subprocess
from pathlib import Path 
import requests


RV_source_url = "https://raw.githubusercontent.com/Freely-Given-org/OpenEnglishTranslation--OET/main/translatedTexts/ReadersVersion/"
LV_source_url = "https://raw.githubusercontent.com/Freely-Given-org/OpenEnglishTranslation--OET/main/intermediateTexts/auto_edited_VLT_ESFM/"

download_dir = "/.temp"

RV_local_path = "/OET-RV/"
LV_local_path = "/OET-LV/"

# Currently only includes the NT
RV_file_mapping = {
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

LV_file_mapping = {
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


def convert_esfm_to_json(esfm_source_url, local_path, file_mapping):
    # Download the ESFM file
    download_url = esfm_source_url + filename
    print("Downloading ESFM source from", download_url)

    response = requests.get(download_url)

    if response.ok:
      path = Path(os.getcwd() + f'/{download_dir}/{filename}')
      path.touch() # Create file if it doesn't exist

      with path.open('wb') as file:
        file.write(response.content)

      json_filepath = f'{os.getcwd()}{local_path}{file_mapping[filename]}'

      abs_path = path.absolute()

      # Convert to json
      with open(json_filepath, 'wb') as file:
        output = subprocess.run(["usfm-grammar", str(abs_path), "--level", "relaxed"], 
                                shell=True, stdout=file, stderr=subprocess.PIPE, text=True)

      if output.returncode == 1:
        print("Error converting ESFM to json!")
      else:
        print("Converted ESFM to json.")
    else:
      print("Something went wrong. The request status code is ", response.status_code)


if __name__ == "__main__":
  print("Installing usfm to json converter...")
  output = os.system("npm install -g usfm-grammar")

  if output == 1:
    print(("Couldn't run ``npm install -g usfm-grammar`` to install the usfm to json converter.",
          ("Please check that you have npm installed.")))
  else:
    print("Successfully installed usfm to json converter.")

    print("\nConverting Reader's version")
    for filename in RV_file_mapping.keys():
      convert_esfm_to_json(RV_source_url, RV_local_path, RV_file_mapping)

    print("\nConverting Literal version")
    for filename in LV_file_mapping.keys():
      convert_esfm_to_json(LV_source_url, LV_local_path, LV_file_mapping)

    print("\nDone! The converted .json files are in the /RV/ and /LV/ folders.")