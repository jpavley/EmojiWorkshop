//
//  EmojiGlyph.swift
//  Emoji Tac Toe
//
//  Created by John Pavley on 12/9/17.
//  Copyright © 2017 Epic Loot. All rights reserved.
//

import Foundation

// Internal constants
fileprivate let nonFullyQualifed = "non-fully-qualified"
fileprivate let poundChar:Character = "#"
fileprivate let poundStr:String = "#"
fileprivate let glyphOffset = 2
fileprivate let descriptionOffset = 4

struct EmojiGlyph {
    
    // properties
    var glyph: String
    var description: String
    var index: Int
    var group: String
    var subgroup: String
    var tags: [String]
    
    /// Init an EmojiGlyph from a line of text in emoji-text.text from the W3C.
    /// Ignore the comment lines in the file (where index of "#" == 0).
    /// Ignore emoji that are non-fully-qualified
    /// Grab the emoji character and the string description.
    init?(textLine: String, index: Int, group: String, subgroup: String) {
        
        if textLine.contains(nonFullyQualifed) {
            return nil
        }
        
        let pounds = textLine.filter { $0 == "#" }
        if pounds.count > 1 {
            return nil
        }
        
        if let poundIndex = textLine.index(of: poundChar) {
            
            if poundIndex != poundStr.index(of: poundChar) {
                glyph = String(textLine[textLine.index(poundIndex, offsetBy: glyphOffset)])
                description = String(textLine[textLine.index(poundIndex, offsetBy: descriptionOffset)...])
                self.index = index
                self.group = group
                self.subgroup = subgroup
                self.tags = [String]()
                return
            }
        }
        
        return nil
    }
}
