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
    var filteredEmojiGlyphs: [EmojiGlyph]
    var glyphsIDsInSections: [[Int]]
    var sections: [String]
    
    struct UnsupportedEmojiIDs {
        static let unitedNationsFlag = 3473
    }
    
    /// Organizes emoji glyph IDs into sections based on group and subgroup.
    /// Throws away any sections without associated emoji.
    fileprivate func createGlyphsInSections() {
        
        // TODO: Use map() to map section to list of associated emoji
        
        var glyphIDs: [Int]
        var cleanedUpSections = [String]()
        var glyphSectionName = ""
        
        for section in sections {
            
            glyphIDs = [Int]()
            
            for glyph in emojiGlyphs {
                glyphSectionName = "\(glyph.group): \(glyph.subgroup)"
                if section == glyphSectionName {
                    glyphIDs.append(glyph.index)
                }
            }
            
            if glyphIDs.count > 0 {
                glyphsIDsInSections.append(glyphIDs)
                cleanedUpSections.append(section)
            }
        }
        
        sections = cleanedUpSections
    }
    
    /// Initializes EmojiCollection from a source file. The file has to be a W3C
    /// emoji test file stored locally. 
    init?(sourceFileName: String) {
        
        emojiGlyphs = [EmojiGlyph]()
        filteredEmojiGlyphs = [EmojiGlyph]()
        glyphsIDsInSections = [[Int]]()
        sections = [String]()
        
        if let txtPath = Bundle.main.path(forResource: sourceFileName, ofType: "txt") {
            do {

                let emojiTestText = try String(contentsOfFile: txtPath, encoding: .utf8)
                let emojiTestLines = emojiTestText.split(separator: "\n")
                
                var group = ""
                var subgroup = ""
                for (i, line) in emojiTestLines.enumerated() {
                    
                    if i == UnsupportedEmojiIDs.unitedNationsFlag {
                        // iOS 11.2 does not support the UN Flag Emoji
                        continue
                    }
                    
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
                    
                    if var emojiGlyph = EmojiGlyph(textLine: String(line), index: i, group: group, subgroup: subgroup) {
                        // print(emojiGlyph)
                        emojiGlyph.tags = createMetadata(glyph: emojiGlyph)
                        emojiGlyphs.append(emojiGlyph)
                    }
                }
            } catch {
                
                print("emoji-test.txt file not found")
                return nil
            }
        }
        
        createGlyphsInSections()
        
//        for i in 0..<sections.count {
//            print("\(sections[i]) \(glyphsIDsInSections[i])")
//        }
        
    }
}
