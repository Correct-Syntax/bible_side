// This code is from https://github.com/ftognetto/alphanum_comparator/
//
// Licensed under the Apache License, Version 2.0 (the "License"); you
// may not use this file except in compliance with the License. You may
// obtain a copy of the License at

// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
// implied. See the License for the specific language governing permissions
// and limitations under the License.

class AlphanumComparator {
  static bool _isDigit(String ch) {
    return (ch.codeUnitAt(0) >= 48) && (ch.codeUnitAt(0) <= 57);
  }

  /// Length of string is passed in for improved efficiency (only need to calculate it once)
  static String _getChunk(String s, int slength, int marker) {
    final StringBuffer chunk = StringBuffer();
    int c = s.codeUnitAt(marker);
    chunk.write(c);
    marker++;
    if (_isDigit(s)) {
      while (marker < slength) {
        c = s.codeUnitAt(marker);
        if (!_isDigit(s)) break;
        chunk.write(c);
        marker++;
      }
    } else {
      while (marker < slength) {
        c = s.codeUnitAt(marker);
        if (_isDigit(s)) break;
        chunk.write(c);
        marker++;
      }
    }
    return chunk.toString();
  }

  /// Compare using alphanum algorithm
  static int compare(String s1, String s2) {
    int thisMarker = 0;
    int thatMarker = 0;
    final int s1Length = s1.length;
    final int s2Length = s2.length;

    while (thisMarker < s1Length && thatMarker < s2Length) {
      final String thisChunk = _getChunk(s1, s1Length, thisMarker);
      thisMarker += thisChunk.length;

      final String thatChunk = _getChunk(s2, s2Length, thatMarker);
      thatMarker += thatChunk.length;

      // If both chunks contain numeric characters, sort them numerically
      int result = 0;
      if (_isDigit(thisChunk) && _isDigit(thatChunk)) {
        // Simple chunk comparison by length.
        final int thisChunkLength = thisChunk.length;
        result = thisChunkLength - thatChunk.length;
        // If equal, the first different number counts
        if (result == 0) {
          for (int i = 0; i < thisChunkLength; i++) {
            result = thisChunk.codeUnitAt(i) - thatChunk.codeUnitAt(i);
            if (result != 0) {
              return result;
            }
          }
        }
      } else {
        result = thisChunk.compareTo(thatChunk);
      }

      if (result != 0) return result;
    }

    return s1Length - s2Length;
  }

  /// Compare using alphanum algorithm, but sort strings starting with a number firsts
  static int compareNumFirsts(String s1, String s2) {
    RegExp numberRegEx = RegExp(r'[0-9]');
    bool isS1startWithNumber = s1.startsWith(numberRegEx);
    bool isS2startWithNumber = s2.startsWith(numberRegEx);

    if (isS1startWithNumber && !isS2startWithNumber) {
      return -1;
    } else if (isS2startWithNumber && !isS1startWithNumber) {
      return 1;
    }
    return compare(s1, s2);
  }
}
