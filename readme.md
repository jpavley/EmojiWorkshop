# Emoji Workshop

## In a Nutshell

EmojiWorkshop is a demo add that parses emoji-test.txt and displays the results in a UITableView with custom UITableViewCell controls.

## TODOs

### Search Improvements

- Search on emoji ID numbers: Use $ as a signal and return specific and ranges of emoji based on ID. For example: "$132" returns 😽. "#131-135" returns 😼😽🙀😿😾. "$-135" returns all emoji before 135 and "$135=" returns all emoji after 135. "$135 2121 3185" returns 😿🐱🈸.
- Search on emoji groups and subgroups: Use @ as a signal and return all emoji in a category whose group or subgroup contains the search terms. For emaple: "@ monkey" returns emoji in any group or subgroup that contains the word monkey (monkey-face). "@monkey fantasy" would return both monkey-face emoji and person-fantasy emoji.
- Seach with substrings: Use . as signal and return all emoji whose desciptions contain the contigious string of characters in the seachbar. For example: ".cat" returns "cat" and "application"
- Seach with stemming: "eye" should return "eye" and "eyes"
- Search with CoreML. Feed the emoji images into Apple's machine learning engine and use it to generate new text metadata. Emoji descriptions are often metaphorical and not descriptive. Person Frowning is a yellow woman with blond hair and a purple shirt. Seaching "woman" or "yellow" will not find her.

### UX Improvements
- Dismiss the seach keyboard when the user touches the table
- Move the tool bar functionality to the top as it's covered by the each keyboard.
- Add sound effects.
- Revert to a clean state when the user shakes the phone.
- Add a detail view with a much larger emoji.
- Popup a share sheet instead of just copying to the clipboard
- Add AR where the emojis are projected onto a users face and can be screen shotted.
- Add favoriting of emoji
- Add

## Done
### Search Improvements

- Search on whole words. So "cat" only returns  cats and not "application" as well.
- Exclude emoji with descriptions containing exclude search terms: "!blue" means no emoji described as blue.


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

## License

- MIT


