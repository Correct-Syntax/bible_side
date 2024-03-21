import 'dart:developer';

String text = """
So¦106620 there's no excuse for anyone who judges others because¦106639 you're; condemning¦106637 yourselves¦106636 if you're doing¦106641 those same things that you're judging other for.

unintelligent¦106589, untrustworthy¦106590, unloving¦106591,

and so they were filled¦106563 with disobedience, wickedness¦106568, greediness¦106570, and malice, and full of envy, murder¦106574, strife¦106575, and deceit¦106577,

Here begins¦21749 the good¦21751 message¦21751 about Yeshua¦21752 the messiah¦21754—the son of God¦21757:

And he also announced¦21944, “There's a greater man coming¦21954 soon—in fact I'm not even good enough to bend¦21968 down and untie¦21969 his¦21976 sandals¦21974.”

to¦113944_the¦113944 assembly¦113945 of¦113947_

Yaʸsous¦113971 chosen¦113972_one¦113972/messiah¦113972
""";

String text1 = 'unintelligent¦106589, untrustworthy¦106590, unloving¦106591,';

String text2 =
    'to¦113944_the¦113944 assembly¦113945 of¦113947_ _ god¦113947, having¦113952_been¦113952_sanctified¦113952 in¦113953 chosen¦113954_one¦113954/messiah¦113954 Yaʸsous¦113955, being¦113957 in¦113958 Korinthos¦113959, called¦113960 holy¦113961>ones¦113961, with¦113962 all¦113963 the¦113964>ones¦113964 calling¦113965 on¦113966_the¦113966 name¦113967 of¦113968_the¦113968 master¦113969 of¦113970_us¦113970, Yaʸsous¦113971 chosen¦113972_one¦113972/messiah¦113972, in¦113973 every¦113974 place¦113975, of¦113976_them¦113976 and¦113978 of¦113979_us¦113979:';

String text3 = 'holy¦113961>ones¦113961,  the¦113964>ones¦113964';

/// [Tokenizer.tokenize] converts [text] into a list of tokens.
///
/// Each token represents:
/// 1. A single word with punctuation.
/// 2. A numerical value (e.g: 113960). It can be assumed that wherever there is
/// a numerical token, it "belongs" to the preceding token.
/// 3. If it contains special symbols, a string of words with punctuation.
///
/// Special symbols >, _, / and all punctuation marks are preserved within the tokens.
///
/// Processing the given text:
/// ```“There's a greater man coming¦21954 soon—in fact
/// Yaʸsous¦113971 chosen¦113972_one¦113972/messiah¦113972```
///
/// will result in:
/// ```[[“There's], [a], [greater], [man], [coming, 21954], [soon], [—in], [fact],
/// [Yaʸsous, 113971], [chosen_one/messiah, 113972]]```
///
/// Implementation:
///
/// 1. First we split the verse contents by spaces to get chunks of the text.
/// 2. Next we tokenize the verse contents and group any connected words.
/// 3. We further tokenize the punctuation from the numerical parts.
class Tokenizer {
  static List<List<String>> tokenize(String text) {
    List<String> textChunks = text.split(RegExp(r'\s'));

    List<String> rawTokens = [];
    for (String chunk in textChunks) {
      /// Check for instances of _ or /, and group them.
      /// All except for the last numeric value will be removed.
      ///
      /// chosen¦113972_one¦113972/messiah¦113972
      /// will become:
      /// [chosen_one/messiah, 113972]
      if (chunk.contains('_') || chunk.contains('/')) {
        String end = '';
        final replacedToken = chunk.replaceAllMapped(RegExp(r'(¦[0-9]*)'), (match) {
          end = '${match.group(0)}';
          return '';
        });

        rawTokens.add('$replacedToken$end');
      } else {
        /// Handle dashes
        ///
        /// messiah¦21754—the
        /// will become:
        /// [messiah, 21754] [—the]
        if (chunk.contains('—')) {
          List<String> splitDashToken = chunk.split(RegExp(r'(—)'));

          rawTokens.add(splitDashToken[0]);
          rawTokens.add('—${splitDashToken[1]}');

          /// Handle arrows (greater than less than symbol)
          ///
          /// holy¦113961>ones¦113961,  the¦113964>ones¦113964
          /// will become:
          /// [holy, 113961] [>ones, 113961,, ,],
        } else if (chunk.contains('>')) {
          List<String> splitArrowToken = chunk.split(RegExp(r'(>)'));

          rawTokens.add(splitArrowToken[0]);
          rawTokens.add('>${splitArrowToken[1]}');
        } else {
          rawTokens.add(chunk);
        }
      }
    }
    return tokenizeFromRaw(rawTokens);
  }

  static List<List<String>> tokenizeFromRaw(List<String> rawTokens) {
    List<List<String>> finalTokens = [];
    for (String token in rawTokens) {
      List<String> splitToken = token.split('¦');
      if (splitToken.length > 1) {
        List<String> tokenList = [];
        List<String> punctuation = tokenizeLeftoverPunctuation(splitToken.last);
        tokenList.add(splitToken.first);

        // Remove punctuation from the numerical token
        tokenList.add(splitToken.last.replaceAll(RegExp(r'([!?.,:;“”‘’)])'), ''));
        // Then re-add the punctuation as individual tokens
        tokenList.addAll(punctuation);

        finalTokens.add(tokenList);
      } else {
        finalTokens.add([token]);
      }
    }
    return finalTokens;
  }

  static List<String> tokenizeLeftoverPunctuation(String numberText) {
    List<String> tokens = [];
    if (numberText.contains(RegExp(r'([.,:;“”])'))) {
      List<String> splitNumberText = numberText.split(RegExp(r'([0-9]*)'));
      tokens.addAll(splitNumberText);
    }
    tokens.removeWhere((item) => item == ''); // Remove spaces
    return tokens;
  }
}

/// For testing
// void main() {
//   List<List<String>> tokens = Tokenizer.tokenize(text2);
//   log(tokens.toString());

//   for (var tokenList in tokens) {
//     log(tokenList.toString());
//   }
// }
