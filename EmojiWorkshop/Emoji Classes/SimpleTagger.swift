//
//  SimpleTagger.swift
//  Emoji Spy
//
//  Created by John Pavley on 1/15/18.
//  Copyright © 2018 Epic Loot. All rights reserved.
//

import Foundation

class SimpleTagger: SimpleSubstituter {
    
    init(tagMap: [Int: String]) {
        
        var subMap = [String: String]()
        
        for (key, val) in tagMap {
            subMap["\(key)"] = val
        }
        
        super.init(substituteMap: subMap)
    }
    
    
    override init?(sourceFileName: String = "CustomTags") {
        super.init(sourceFileName: sourceFileName)
    }
    
    func getTags(for indexNumber: Int) -> [String]? {
        let term = "\(indexNumber)"
        return super.getSubstitutes(for: term)
    }
    
    /// Emoji groups and subgroups are not well named and/or are overbroad.
    /// When creating tags from group and subgroup name hundreds of emoji
    /// are inproperly tagged. Smileys are also tagged people and people are
    /// are also tagged smileys. Plants are tagged animals. Foods are tagged
    /// drinks and drinks are tagged food. Places and Travel are also
    /// oddly tagged.
    func tagAdjustment(emojiGlyphs: [EmojiGlyph]) -> [EmojiGlyph] {
        var adjustedEmojiGlyphs = emojiGlyphs
        
        // TODO: Integrate into CustomTags.txt (this is compact but will break with future emoji sets
        
        adjustedEmojiGlyphs = remove(badTag: "person", start: 0, end: 106, emojiGlyphs: adjustedEmojiGlyphs)
        adjustedEmojiGlyphs = remove(badTag: "smileys", start: 107, end: 1506, emojiGlyphs: adjustedEmojiGlyphs)
        adjustedEmojiGlyphs = remove(badTag: "person", start: 1443, end: 1506, emojiGlyphs: adjustedEmojiGlyphs)
        adjustedEmojiGlyphs = remove(badTag: "animal", start: 1598, end: 1629, emojiGlyphs: adjustedEmojiGlyphs)
        adjustedEmojiGlyphs = remove(badTag: "drink", start: 1620, end: 1702, emojiGlyphs: adjustedEmojiGlyphs)
        adjustedEmojiGlyphs = remove(badTag: "food", start: 1702, end: 1715, emojiGlyphs: adjustedEmojiGlyphs)
        adjustedEmojiGlyphs = remove(badTag: "drink", start: 1716, end: 1720, emojiGlyphs: adjustedEmojiGlyphs)
        adjustedEmojiGlyphs = remove(badTag: "food", start: 1721, end: 1722, emojiGlyphs: adjustedEmojiGlyphs)
        adjustedEmojiGlyphs = remove(badTag: "place", start: 1786, end: 1928, emojiGlyphs: adjustedEmojiGlyphs)
        return adjustedEmojiGlyphs
    }
    
    fileprivate func remove(badTag: String, start: Int, end: Int, emojiGlyphs: [EmojiGlyph]) -> [EmojiGlyph] {
        var cleanedEmojiGlyphs = emojiGlyphs
        let tagRange = Int(start)...Int(end)
        for i in tagRange {
            cleanedEmojiGlyphs[i].tags = cleanedEmojiGlyphs[i].tags.filter({$0 != badTag})
        }
        return cleanedEmojiGlyphs
    }
}
