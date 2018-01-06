//
//  EmojiWorkshopTests.swift
//  EmojiWorkshopTests
//
//  Created by John Pavley on 12/13/17.
//  Copyright © 2017 Epic Loot. All rights reserved.
//

import XCTest

class EmojiGlyphsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateEmojiGlyphNil() {
        let testEmojiGlyph = EmojiGlyph(textLine: "", index: 0, group: "", subgroup: "")
        XCTAssertNil(testEmojiGlyph)
    }
    
    func testCreateEmojiGlyphNFQInput() {
        let testTextLine = "2620                                       ; non-fully-qualified # ☠ skull and crossbones"
        let testEmojiGlyph = EmojiGlyph(textLine: testTextLine, index: 0, group: "", subgroup: "")
        XCTAssertNil(testEmojiGlyph)
    }
    
    func testCreateEmojiGlyphGoodInput() {
        let testTextLine = "1F476 1F3FB                                ; fully-qualified     # 👶🏻 baby: light skin tone"
        let testEmojiGlyph = EmojiGlyph(textLine: testTextLine, index: 0, group: "g", subgroup: "s")
        XCTAssertNotNil(testEmojiGlyph)
        XCTAssertTrue(testEmojiGlyph?.glyph == "👶🏻")
        XCTAssertTrue(testEmojiGlyph?.index == 0)
        XCTAssertTrue(testEmojiGlyph?.description == "baby: light skin tone")
        XCTAssertTrue(testEmojiGlyph?.group == "g")
        XCTAssertTrue(testEmojiGlyph?.subgroup == "s")
    }
    
    func testCreateEmojiGlyphBadInputMissingPound() {
        let testTextLine = "1F476 1F3FB                                ; fully-qualified      👶🏻 baby: light skin tone"
        let testEmojiGlyph = EmojiGlyph(textLine: testTextLine, index: 0, group: "", subgroup: "")
        XCTAssertNil(testEmojiGlyph)
    }
    
    func testCreateEmojiGlyphBadInputExtraPound() {
        let testTextLine = "1F476 1F3FB                                ; fully-qualified     # # 👶🏻 baby: light skin tone"
        let testEmojiGlyph = EmojiGlyph(textLine: testTextLine, index: 0, group: "", subgroup: "")
        XCTAssertNil(testEmojiGlyph)
    }

    
    
}
