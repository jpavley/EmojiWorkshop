//
//  EmojiGlyph.swift
//  Emoji Tac Toe
//
//  Created by John Pavley on 12/9/17.
//  Copyright © 2017 Epic Loot. All rights reserved.
//

import Foundation

struct EmojiGlyph {
    var glyph: String
    var description: String
    
    
    /// Init an EmojiGlyph from a line of text in emoji-text.text from the W3C.
    /// Ignore the comment lines in the file (where index of "#" == 0).
    /// Grab the emoji character and the string description.
    init?(textLine: String) {
        
        // Example text lines from emoji-text.txt
        // # Emoji Keyboard/Display Test Data for UTR #51
        // 1F476                                      ; fully-qualified     # 👶 baby
        
        if let poundIndex = textLine.index(of: "#") {
            if poundIndex != "#".index(of: "#") {
                glyph = String(textLine[textLine.index(poundIndex, offsetBy: 2)])
                description = String(textLine[textLine.index(poundIndex, offsetBy: 4)...])
                return
            }
        }
        // return an empty glyph
        return nil
    }
}
