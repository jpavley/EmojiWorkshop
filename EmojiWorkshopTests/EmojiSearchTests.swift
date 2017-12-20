//
//  EmojiSearchTests.swift
//  EmojiWorkshopTests
//
//  Created by John Pavley on 12/16/17.
//  Copyright © 2017 Epic Loot. All rights reserved.
//

import XCTest

class EmojiSearchTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEmojiSearchInstance() {
        let testEmojiSearch = EmojiSearch()
        XCTAssertNotNil(testEmojiSearch)
    }
    
    func testFilterEmojiNoFilter() {
        let testEmojiCollection = EmojiCollection(sourceFileName: "emoji-test-5.0")
        let testEmojiSearch = EmojiSearch()
        
        if let testSearchResults = testEmojiSearch.search(emojiGlyphs: testEmojiCollection.emojiGlyphs, filter: .noFilter, searchString: "") {
        
            XCTAssertTrue(testEmojiCollection.emojiGlyphs.count == testSearchResults.count)
            XCTAssertTrue(testEmojiCollection.emojiGlyphs.first!.priority == testSearchResults.first!.priority)
            XCTAssertTrue(testEmojiCollection.emojiGlyphs.last!.priority == testSearchResults.last!.priority)
        }
    }
    
    func testFilterEmojiByDescriptionSingleTerm() {
        let testEmojiCollection = EmojiCollection(sourceFileName: "emoji-test-5.0")
        let testEmojiSearch = EmojiSearch()
        
        let testSearchResults = testEmojiSearch.search(emojiGlyphs: testEmojiCollection.emojiGlyphs, filter: .byDescription, searchString: "Cat")
        
        XCTAssertNotNil(testSearchResults)
        XCTAssertEqual(testSearchResults!.count, 11)
        XCTAssertTrue(testSearchResults!.first!.priority == 127)
        XCTAssertTrue(testSearchResults!.last!.priority == 2122)
    }
    
    func testFilterEmojiByDescriptionMultipleTerms() {
        let testEmojiCollection = EmojiCollection(sourceFileName: "emoji-test-5.0")
        let testEmojiSearch = EmojiSearch()
        
        let testSearchResults = testEmojiSearch.search(emojiGlyphs: testEmojiCollection.emojiGlyphs, filter: .byDescription, searchString: "Book house")
        
        XCTAssertNotNil(testSearchResults)
        XCTAssertEqual(testSearchResults!.count, 0)
    }
    
    func testFilterEmojiByDescriptionWithEmptyExclusion() {
        let testEmojiCollection = EmojiCollection(sourceFileName: "emoji-test-5.0")
        let testEmojiSearch = EmojiSearch()
        
        let testSearchResults = testEmojiSearch.search(emojiGlyphs: testEmojiCollection.emojiGlyphs, filter: .byDescription, searchString: "Cat !")
        
        XCTAssertNotNil(testSearchResults)
        XCTAssertEqual(testSearchResults!.count, 11)
        XCTAssertTrue(testSearchResults!.first!.priority == 127)
        XCTAssertTrue(testSearchResults!.last!.priority == 2122)
    }
    
    func testFilterEmojiByDescriptionWithExclusion() {
        let testEmojiCollection = EmojiCollection(sourceFileName: "emoji-test-5.0")
        let testEmojiSearch = EmojiSearch()
        
        let testSearchResults = testEmojiSearch.search(emojiGlyphs: testEmojiCollection.emojiGlyphs, filter: .byDescription, searchString: "Book !blue")
        
        XCTAssertNotNil(testSearchResults)
        XCTAssertEqual(testSearchResults!.count, 4)
        XCTAssertTrue(testSearchResults!.first!.priority == 2782)
        XCTAssertTrue(testSearchResults!.last!.priority == 2786)
        XCTAssertFalse(testSearchResults![3].priority == 2785)
    }
    
    func testFilterEmojiByDescriptionOnlyExclusion() {
        let testEmojiCollection = EmojiCollection(sourceFileName: "emoji-test-5.0")
        let testEmojiSearch = EmojiSearch()
        
        let testSearchResults = testEmojiSearch.search(emojiGlyphs: testEmojiCollection.emojiGlyphs, filter: .byDescription, searchString: "!blue")
        
        XCTAssertNotNil(testSearchResults)
        XCTAssertNotEqual(testSearchResults!.count, 2617)
    }
    
    func testFilterEmojiByDescriptionRemoveColons() {
        let testEmojiCollection = EmojiCollection(sourceFileName: "emoji-test-5.0")
        let testEmojiSearch = EmojiSearch()
        
        let testSearchResults = testEmojiSearch.search(emojiGlyphs: testEmojiCollection.emojiGlyphs, filter: .byDescription, searchString: "baby")
        
        XCTAssertNotNil(testSearchResults)
        XCTAssertEqual(testSearchResults!.count, 16)
        XCTAssertTrue(testSearchResults![1].priority == 142)
    }
    
    func testFilterEmojiByDescriptionWithMultipleExclusion() {
        let testEmojiCollection = EmojiCollection(sourceFileName: "emoji-test-5.0")
        let testEmojiSearch = EmojiSearch()
        
        let testSearchResults = testEmojiSearch.search(emojiGlyphs: testEmojiCollection.emojiGlyphs, filter: .byDescription, searchString: "Cat !kissing !joy !crying !grinning")
        
        XCTAssertNotNil(testSearchResults)
        XCTAssertEqual(testSearchResults!.count, 6)
        XCTAssertTrue(testSearchResults!.first!.priority == 130)
        XCTAssertTrue(testSearchResults!.last!.priority == 2122)
        XCTAssertTrue(testSearchResults![3].priority == 135)
    }
    
    func testFilterEmojiByDescriptionWithSingleCharacterAtEnd() {
        let testEmojiCollection = EmojiCollection(sourceFileName: "emoji-test-5.0")
        let testEmojiSearch = EmojiSearch()
        
        let testSearchResults = testEmojiSearch.search(emojiGlyphs: testEmojiCollection.emojiGlyphs, filter: .byDescription, searchString: "Cat !face !n")
        
        XCTAssertNotNil(testSearchResults)
        XCTAssertEqual(testSearchResults!.count, 0)
    }




}
