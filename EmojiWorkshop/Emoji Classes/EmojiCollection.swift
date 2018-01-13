//
//  EmojiCollection.swift
//  EmojiWorkshop
//
//  Created by John Pavley on 12/12/17.
//  Copyright © 2017 Epic Loot. All rights reserved.
//

import Foundation

typealias GlyphIDList = [Int]

class EmojiCollection {
    
    var emojiGlyphs: [EmojiGlyph]
    var filteredEmojiGlyphs: [EmojiGlyph]
    var searchSuggestions: TagAndCountsList
    var glyphsIDsInSections: [GlyphIDList]
    var sectionNames: [String]
    
    struct UnsupportedEmoji {
        static let unitedNationsFlag = " 🇺🇳"
    }
    
    fileprivate func isEmojiInSection(glyph: EmojiGlyph, section: String) -> Bool {
        let glyphSectionName = "\(glyph.group): \(glyph.subgroup)"
        return section == glyphSectionName
    }
    
    /// Organizes emoji glyph IDs into sections based on group and subgroup.
    /// Throws away any sections without associated emoji.
    fileprivate func createGlyphsInSections() {
                
        var glyphIDs: GlyphIDList
        var cleanedUpSections = [String]()
        
        for section in sectionNames {
            
            glyphIDs = emojiGlyphs.filter { isEmojiInSection(glyph: $0, section: section) }.map { $0.index }
            
            if glyphIDs.count > 0 {
                glyphsIDsInSections.append(glyphIDs)
                cleanedUpSections.append(section)
            }
        }
        
        sectionNames = cleanedUpSections
    }
    
    /// Initializes EmojiCollection from a source file. The file has to be a W3C
    /// emoji test file stored locally. 
    init?(sourceFileName: String) {
        
        emojiGlyphs = [EmojiGlyph]()
        filteredEmojiGlyphs = [EmojiGlyph]()
        searchSuggestions = TagAndCountsList()
        glyphsIDsInSections = [[Int]]()
        sectionNames = [String]()
        
        if let txtPath = Bundle.main.path(forResource: sourceFileName, ofType: "txt") {
            do {

                let emojiTestText = try String(contentsOfFile: txtPath, encoding: .utf8)
                let emojiTestLines = emojiTestText.split(separator: "\n")
                
                var group = ""
                var subgroup = ""
                var emojiIndex = 0
                
                for line in emojiTestLines {
                    
                    if line.contains(UnsupportedEmoji.unitedNationsFlag) {
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
                    
                    if !sectionNames.contains(sectionName) {
                        sectionNames.append(sectionName)
                    }
                    
                    if var emojiGlyph = EmojiGlyph(textLine: String(line), index: 0, group: group, subgroup: subgroup) {
                        // print(emojiGlyph)
                        emojiIndex += 1
                        emojiGlyph.index = emojiIndex
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
        let emojiSearch = EmojiSearch()
        searchSuggestions = emojiSearch.getSuggestions(emojiGlyphs: emojiGlyphs)

        
//        print("emojiGlyphs.count \(emojiGlyphs.count)")
        
//        for i in 0..<sections.count {
//            print("\(sections[i]) \(glyphsIDsInSections[i])")
//        }
        
        print("searchSuggestions.count \(searchSuggestions.count)")
        
    }
}
