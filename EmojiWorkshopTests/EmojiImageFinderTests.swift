//
//  EmojiImageFinderTests.swift
//  Emoji SpyTests
//
//  Created by John Pavley on 1/28/18.
//  Copyright © 2018 Epic Loot. All rights reserved.
//

import XCTest

class EmojiImageFinderTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetImageForEmojiIDSuccess() {
        // TODO: This is a test of the toy functionality, update when the real thing is written
        
        let supportedEmojiIDs = [1,2,3,4,5,6,7,8,9]
        let supportedEmojiImageName = "dv-dark-emoji-"
        
        for i in supportedEmojiIDs {
            let testName = EmojiImageFinder().getEmojiImageName(for: i)
            XCTAssertEqual(testName, "\(supportedEmojiImageName)\(i)")
        }
    }
    
    func testGetImageForEmojiIDFail() {
        // TODO: This is a test of the toy functionality, update when the real thing is written
        
        let unsupportedEmojiIDs = [0,10000]
        let unsupportedEmojiImageName = "dv-dark-emoji-1"
        
        for i in unsupportedEmojiIDs {
            let testName = EmojiImageFinder().getEmojiImageName(for: i)
            XCTAssertEqual(testName, "\(unsupportedEmojiImageName)")
        }
    }
    
}
