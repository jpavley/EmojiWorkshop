# Emoji Workshop

## In a Nutshell

EmojiWorkshop is a demo app that parses emoji-test.txt and displays the results in a UITableView with custom UITableViewCell controls.

## TODOs

Moved to GitHub Issues: https://github.com/jpavley/EmojiWorkshop/issues

## Backstory

Emoji are awesome. But there are too many of them, some with many varients, some that combine together to create new emoji, some that
don't show up on everyone's device, and often they are interpreted differently on different platforms such that the *feeling* you send is
not always the feeling your friends recieve.

There are several good websites with tons of info about emoji! Here is a good starting point: https://unicode.org/emoji/index.html

One of the best places on the internet to data mine emoji is this directory: https://unicode.org/Public/emoji/

One of the best files to grab meaningful and up-to-date data about the emoji from the platform platform providers is https://unicode.org/Public/emoji/5.0/emoji-test.txt

The motivation for this app is to discover and explore all the emoji and meta data and display in all in your pocket 😀

## Tech Specs

- Xcode 9.2
- iOS 11.2
- Swift 4.0.03

## Design Notes
- The iOS keyboard is amazing but imited in space. I want to keep it super easy for users to type and search for emoji and use characters to signal search modes. The initial keyboard that pops up with the searchbar contains the alphabetical keys a through z. To signal a search mode the user has to tap into the numeric keyoboard.  In addition to the numbers 1 thorugh 0 the numeric keyboard contains the symbols -/:;()$&@".,?!'. I'm going to restrict the seach mode signal characters to these symbols so the user doesn't have to tap yet again to symbol keyboard.

## Sticker Emojis

### Sizing

View | @1x | @2x | @3x
---|---|---|---
Detail View | 200 | 400 | 600
Toolbar Item | 25 | 50 | 75
Table Cell | 60 | 120 | 180




## License

- MIT


