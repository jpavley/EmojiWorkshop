//
//  SimpleTaggerTests.swift
//  Emoji SpyTests
//
//  Created by John Pavley on 1/15/18.
//  Copyright © 2018 Epic Loot. All rights reserved.
//

import XCTest

class SimpleTaggerTests: XCTestCase {
    
    var tagMap = [Int: String]()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        tagMap = [
            1:"one two three four",
            2:"mouse man cat",
            3:"car"
        ]
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateTagger() {
        let tagger = SimpleTagger(tagMap: tagMap)
        XCTAssertNotNil(tagger)
    }
    
    func testTaggerSuccess() {
        let tagger = SimpleTagger(tagMap: tagMap)
        XCTAssertTrue(tagger.getTags(for: 1)! == ["one", "two", "three", "four"])
    }
    
    func testTaggerFailure() {
        let tagger = SimpleTagger(tagMap: tagMap)
        XCTAssertNil(tagger.getTags(for: 99))
    }
    
    func testTaggerFromFile() {
        let tagger = SimpleTagger()
        XCTAssertTrue(tagger!.getTags(for: 1)! == ["yellow", "happy"])
        XCTAssertTrue(tagger!.getTags(for: 95)! == ["poop"])
        XCTAssertTrue(tagger!.getTags(for: 999)! == [""])
    }
    
}
