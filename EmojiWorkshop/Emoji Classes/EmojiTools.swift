//
//  EmojiTools.swift
//  EmojiWorkshop
//
//  Created by John Pavley on 12/30/17.
//  Copyright © 2017 Epic Loot. All rights reserved.
//

import Foundation

func printCVS(emojiGlyphs: [EmojiGlyph]) {
    print("priority, glyph, group, subgroup, tags")
    for emoji in emojiGlyphs {
        
        let tags = createMetadata(glyph: emoji)
        
        print("\(emoji.index),\(emoji.glyph),\(emoji.group),\(emoji.subgroup)", terminator: "")
        if tags.count != 0 {
            print(",", terminator: "")
            for tag in tags {
                print("\(tag)", terminator: "")
                if tag != tags.last! {
                    print(" ", terminator: "")
                }
            }
        }
        print("")
    }
}

func cleanWordList(glyph: EmojiGlyph) -> Set<String> {
    
    let wordList = glyph.description.lowercased().components(separatedBy: CharacterSet(charactersIn: " -"))
    let cleanWordList = wordList.map({$0.contains(":") ? String($0.dropLast()) : $0})
    let wordListSet = Set(cleanWordList) // conversion to set removes any dupes
    
    return wordListSet
}

func createMetadata(glyph: EmojiGlyph) -> [String] {
    
    var descriptionWords = glyph.description.lowercased().components(separatedBy: CharacterSet(charactersIn: " -"))
    descriptionWords = descriptionWords.map({$0.contains(":") ? String($0.dropLast()) : $0})
    descriptionWords = descriptionWords.map({$0.contains(",") ? String($0.dropLast()) : $0})
    descriptionWords = descriptionWords.map({$0.contains("(") ? String($0.dropFirst()) : $0})
    descriptionWords = descriptionWords.map({$0.contains(")") ? String($0.dropLast()) : $0})
    descriptionWords = descriptionWords.map({$0.contains("“") ? String($0.dropFirst()) : $0})
    descriptionWords = descriptionWords.map({$0.contains("”") ? String($0.dropLast()) : $0})
    descriptionWords = descriptionWords.filter({$0 != "&"})

    var groupWords = glyph.group.lowercased().components(separatedBy: CharacterSet(charactersIn: " -"))
    groupWords = groupWords.map({$0.contains(":") ? String($0.dropLast()) : $0})
    groupWords = groupWords.map({$0.contains(",") ? String($0.dropLast()) : $0})
    groupWords = groupWords.filter({$0 != "&"})

    var subgroupWords = glyph.subgroup.lowercased().components(separatedBy: CharacterSet(charactersIn: " -"))
    subgroupWords = subgroupWords.map({$0.contains(":") ? String($0.dropLast()) : $0})
    subgroupWords = subgroupWords.map({$0.contains(",") ? String($0.dropLast()) : $0})
    subgroupWords = subgroupWords.filter({$0 != "&"})

    let results1 = descriptionWords + groupWords + subgroupWords
    
    let results1a = stemmedTermsFrom(results1)
    
    let results2 = Set(results1a) // de-dupe
    let results3 = Array(results2)
    let results4 = results3.sorted()
    
    return results4
}

func stemmedTermsFrom(_ terms: [String]) -> [String] {
    var stemedTerms = [String]()
    let simpleStemmer = SimpleStemmer()
    for term in terms {
        
        if term == "tech" {
            print(term)
        }
        
        stemedTerms.append(simpleStemmer?.getStem(for: term) ?? term)
    }
    return stemedTerms
}

