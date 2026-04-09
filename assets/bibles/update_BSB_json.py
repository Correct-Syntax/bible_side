# File: update_BSB_json.py
#
# Script to update the BSB (Berean Standard Bible)  translation json files.
#
# Because the BSB site provides fully json-ified files, right now it just a matter of
# downloading the zip file and using this script to rename the files.
# Script patterned after update_WEB_json.py
# Since the BSB is complete, updating would only be to fix typos, etc. or to move to a new
# release.
# Date: March 2026
# Author: stbrandle@taylor.edu
#
# Instructions:
# 1. Download the source JSON files from https://bereanbible.com/bsb_usj.zip
# 2. Unzip the folder.
# 3. Rename the folder to "BSB" and place it in ``/assets/bibles/BSB``.
# 4. Run this script to rename the BSB json files to the canonical names for this project.

import os

FILE_MAPPING = {
  "GEN.json": "GEN.json",
  "EXO.json": "EXO.json",
  "LEV.json": "LEV.json",
  "NUM.json": "NUM.json",
  "DEU.json": "DEU.json",
  "JOS.json": "JOS.json",
  "JDG.json": "JDG.json",
  "RUT.json": "RUT.json",
  "1SA.json": "SA1.json",
  "2SA.json": "SA2.json",
  "1KI.json": "KI1.json",
  "2KI.json": "KI2.json",
  "1CH.json": "CH1.json",
  "2CH.json": "CH2.json",
  "EZR.json": "EZR.json",
  "NEH.json": "NEH.json",
  "EST.json": "EST.json",
  "JOB.json": "JOB.json",
  "PSA.json": "PSA.json",
  "PRO.json": "PRO.json",
  "ECC.json": "ECC.json",
  "SNG.json": "SNG.json",
  "ISA.json": "ISA.json",
  "JER.json": "JER.json",
  "LAM.json": "LAM.json",
  "EZK.json": "EZE.json",
  "DAN.json": "DAN.json",
  "HOS.json": "HOS.json",
  "JOL.json": "JOL.json",
  "AMO.json": "AMO.json",
  "OBA.json": "OBA.json",
  "JON.json": "JNA.json",
  "MIC.json": "MIC.json",
  "NAM.json": "NAH.json",
  "HAB.json": "HAB.json",
  "ZEP.json": "ZEP.json",
  "HAG.json": "HAG.json",
  "ZEC.json": "ZEC.json",
  "MAL.json": "MAL.json",

  "MAT.json": "MAT.json",
  "MRK.json": "MRK.json",
  "LUK.json": "LUK.json",
  "JHN.json": "JHN.json",
  "ACT.json": "ACT.json",
  "ROM.json": "ROM.json",
  "1CO.json": "CO1.json",
  "2CO.json": "CO2.json",
  "GAL.json": "GAL.json",
  "EPH.json": "EPH.json",
  "PHP.json": "PHP.json",
  "COL.json": "COL.json",
  "1TH.json": "TH1.json",
  "2TH.json": "TH2.json",
  "1TI.json": "TI1.json",
  "2TI.json": "TI2.json",
  "TIT.json": "TIT.json",
  "PHM.json": "PHM.json",
  "HEB.json": "HEB.json",
  "JAS.json": "JAM.json",
  "1PE.json": "PE1.json",
  "2PE.json": "PE2.json",
  "1JN.json": "JN1.json",
  "2JN.json": "JN2.json",
  "3JN.json": "JN3.json",
  "JUD.json": "JDE.json",
  "REV.json": "REV.json",
}


if __name__ == "__main__":
  print("\nRenaming the files...")
  for filename in FILE_MAPPING.keys():
    os.rename(filename, FILE_MAPPING[filename])
  print("\nDone!")

