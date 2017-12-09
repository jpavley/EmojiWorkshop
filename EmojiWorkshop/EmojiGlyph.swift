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
    var priority: Int
    
    /// Init an EmojiGlyph from a line of text in emoji-text.text from the W3C.
    /// Ignore the comment lines in the file (where index of "#" == 0).
    /// Ignore emoji that are non-fully-qualified
    /// Grab the emoji character and the string description.
    init?(textLine: String, priority: Int) {
        
        if textLine.contains(nonFullyQualifed) {
            return nil
        }
        
        if let poundIndex = textLine.index(of: poundChar) {
            
            if poundIndex != poundStr.index(of: poundChar) {
                glyph = String(textLine[textLine.index(poundIndex, offsetBy: glyphOffset)])
                description = String(textLine[textLine.index(poundIndex, offsetBy: descriptionOffset)...])
                self.priority = priority
                return
            }
        }
        
        return nil
    }
}
