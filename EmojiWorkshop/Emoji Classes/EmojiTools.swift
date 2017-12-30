//
//  EmojiTools.swift
//  EmojiWorkshop
//
//  Created by John Pavley on 12/30/17.
//  Copyright © 2017 Epic Loot. All rights reserved.
//

import Foundation

func printCVS(emojiGlyphs: [EmojiGlyph]) {
    print("priority, glyph, group, subgroup, description, tags")
    for emoji in emojiGlyphs {
        print("\(emoji.priority),\(emoji.glyph),\(emoji.group),\(emoji.subgroup),\(emoji.description)", terminator: "")
        if emoji.tags.count != 0 {
            print(",", terminator: "")
            for tag in emoji.tags {
                print("\(tag)", terminator: "")
                if tag != emoji.tags.last! {
                    print(",", terminator: "")
                }
            }
        }
        print("")
    }
}

func cleanWordList(glyph: EmojiGlyph) -> Set<String> {
    
    let wordList = glyph.description.lowercased().components(separatedBy: " ")
    let cleanWordList = wordList.map({$0.contains(":") ? String($0.dropLast()) : $0})
    let wordListSet = Set(cleanWordList) // conversion to set removes any dupes
    
    return wordListSet
}

