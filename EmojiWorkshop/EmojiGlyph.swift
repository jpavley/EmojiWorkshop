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
    
    init(textLine: String) {
        // Example text line from emoji-text.txt
        // 1F476                                      ; fully-qualified     # 👶 baby
        
        glyph = "👶"
        description = "baby"
    }
}
