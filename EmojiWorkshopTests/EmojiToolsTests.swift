//
//  EmojiToolsTests.swift
//  EmojiWorkshopTests
//
//  Created by John Pavley on 12/30/17.
//  Copyright © 2017 Epic Loot. All rights reserved.
//

import XCTest

class EmojiToolsTests: XCTestCase {
    
    var testTextLines = [String]()
    var testEmojiGlyphs = [EmojiGlyph]()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        testTextLines = ["1F476                                      ; fully-qualified     # 👶 baby",
                         "1F476 1F3FB                                ; fully-qualified     # 👶🏻 baby: light skin tone",
                         "1F476 1F3FC                                ; fully-qualified     # 👶🏼 baby: medium-light skin tone",
                         "1F476 1F3FD                                ; fully-qualified     # 👶🏽 baby: medium skin tone",
                         "1F476 1F3FE                                ; fully-qualified     # 👶🏾 baby: medium-dark skin tone",
                         "1F476 1F3FF                                ; fully-qualified     # 👶🏿 baby: dark skin tone",
                         "1F47C                                      ; fully-qualified     # 👼 baby angel",
                         "1F47C 1F3FB                                ; fully-qualified     # 👼🏻 baby angel: light skin tone",
                         "1F47C 1F3FC                                ; fully-qualified     # 👼🏼 baby angel: medium-light skin tone",
                         "1F47C 1F3FD                                ; fully-qualified     # 👼🏽 baby angel: medium skin tone",
                         "1F47C 1F3FE                                ; fully-qualified     # 👼🏾 baby angel: medium-dark skin tone",
                         "1F47C 1F3FF                                ; fully-qualified     # 👼🏿 baby angel: dark skin tone",
                         "1F424                                      ; fully-qualified     # 🐤 baby chick",
                         "1F425                                      ; fully-qualified     # 🐥 front-facing baby chick",
                         "1F37C                                      ; fully-qualified     # 🍼 baby bottle",
                         "1F6BC                                      ; fully-qualified     # 🚼 baby symbol"]
        
        for line in testTextLines {
            testEmojiGlyphs.append(EmojiGlyph(textLine: line, index: 0, group: "a", subgroup: "b")!)
        }

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCleanWordListDefault() {
        var cleanedResult: Set<String>
        print("== default")
        for glyph in testEmojiGlyphs {
            cleanedResult = cleanWordList(glyph: glyph)
            XCTAssertTrue(cleanedResult.contains("baby"))
        }
    }    
}
