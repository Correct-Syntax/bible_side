# Changes March-April 2026 by Taylor University

## reader_view.dart
 Angela Victor - SuperPotato876gh
  * top_reader_appbar inserted in SafeArea
    * animation used to make it auto-hide when scroll down
 Grace Bolton - gboltono
  * Tablet and phone landscape/portrait conditionals added
    * still need testing for tablet, and more thorough testing needed for each combination of the 4
    * primary and secondary are moved around depending on tablet/phone/landscape/portrait. The 2 appbars are both at the bottom unless we are in phone portrait mode.
  * primary secondary appbar display changed- arrow is gone, the translation and book selection look like buttons now.
    * the area popups now have a list of recent translations, rather than only enabling RV or LV.
    * scroll linking button was moved to the bottom from the area popup. menu was moved to the right from the middle.

## reader_viewmodel.dart
 Angela Victor - SuperPotato876gh
  * JS listening channels added
    * onScrollDirection - changes isTopBarVisible to true if scroll up, false if scroll down
    * onScrollEvent - changes chapterNumber and verseNumber to the verse at the top of the screen when scrolled
  * sections of JS handleScroll funciton added
    * one that posts message to onScrollDirection - determines direction of scrolling ("up" or "down")
    * one that posts message to onScrollEvent - determines which verse is at the top (area scrolled and ID of element at top of area)

## top_reader_appbar.dart/top_reader_appbar_model.dart
 Angela Victor - SuperPotato876gh
 * goal + what happens from other parts of code
   * similar to secondary_reader_appbar
   * will hide when scroll down, show when scroll up
   * updates the chapter number + verse as you scroll
 * container in the center of the bar contains the chapter + verse
