# Changes March-April 2026 by Taylor University

## reader_view.dart
* top_reader_appbar will auto-hide when scroll down

## reader_viewmodel.dart
* JS listening channels added
 * onScrollDirection - changes isTopBarVisible to true if scroll up, false if scroll down
 * onScrollEvent - changes chapterNumber and verseNumber to the verse at the top of the screen when scrolled
* sections of JS handleScroll funciton added
 * one that posts message to onScrollDirection - determines direction of scrolling ("up" or "down")
 * one that posts message to onScrollEvent - determines which verse is at the top (area scrolled and ID of element at top of area)

## top_reader_appbar.dart/top_reader_appbar_model.dart
* goal + what happens from other parts of code
 * similar to secondary_reader_appbar
 * will hide when scroll down, show when scroll up
 * updates the chapter number + verse as you scroll
* container in the center of the bar contains the chapter + verse
