//
//  EmojiCollection.swift
//  EmojiWorkshop
//
//  Created by John Pavley on 12/12/17.
//  Copyright © 2017 Epic Loot. All rights reserved.
//

import Foundation

class EmojiCollection {
    
    var emojiGlyphs: [EmojiGlyph]
    var sections: [String]
    
    init(sourceFileName: String) {
        emojiGlyphs = [EmojiGlyph]()
        sections = [String]()
        
        if let txtPath = Bundle.main.path(forResource: sourceFileName, ofType: "txt") {
            do {

                let emojiTestText = try String(contentsOfFile: txtPath, encoding: .utf8)
                let emojiTestLines = emojiTestText.split(separator: "\n")
                
                var group = ""
                var subgroup = ""
                for (i, line) in emojiTestLines.enumerated() {
                    
                    if line.contains("# group: ") {
                        group = String(line[line.index(line.startIndex, offsetBy: "# group: ".count)...])
                    }
                    
                    if line.contains("# subgroup: ") {
                        subgroup = String(line[line.index(line.startIndex, offsetBy: "# subgroup: ".count)...])
                    }
                    
                    let sectionName = "\(group): \(subgroup)"
                    
                    if !sections.contains(sectionName) {
                        sections.append(sectionName)
                    }
                    
                    if let emojiGlyph = EmojiGlyph(textLine: String(line), priority: i, group: group, subgroup: subgroup) {
                        // print(emojiGlyph)
                        emojiGlyphs.append(emojiGlyph)
                    }
                }
            } catch {
                
                print("emoji-test.txt file not found")
            }
        }
        print(sections.count)
    }
    
}
