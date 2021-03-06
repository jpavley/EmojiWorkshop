//
//  SimpleSynonymerTests.swift
//  Emoji SpyTests
//
//  Created by John Pavley on 1/14/18.
//  Copyright © 2018 Epic Loot. All rights reserved.
//

import XCTest

class SimpleSynonymerTests: XCTestCase {
    
    var synonymMap = [String: String]()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        synonymMap = ["tram": "train",
                      "metro": "train",
                      "rail": "train",
                      "monorail": "train",
                      "railway": "train",
                      "trollybus": "bus"]
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateSynonymmer() {
        let simpleSynonymer = SimpleSynonymmer(synonymMap: synonymMap)
        XCTAssertNotNil(simpleSynonymer)
    }
    
    func testSynonymmerSuccess() {
        let terms = ["tram", "metro", "rail", "monorail", "railway"]
        let synonymmer = SimpleSynonymmer(synonymMap: synonymMap)
        
        for term in terms {
            let synonyms = synonymmer.getSynonyms(for: term)
            XCTAssertTrue(synonyms!.count == 1)
            XCTAssertTrue(synonyms?.first == "train")
        }
    }
    
    func testSynonymmerSuccessChaseChange() {
        let terms = ["Tram", "metro", "Rail", "monorail", "RAILWAY"]
        let synonymmer = SimpleSynonymmer(synonymMap: synonymMap)
        
        for term in terms {
            let synonyms = synonymmer.getSynonyms(for: term)
            XCTAssertTrue(synonyms!.count == 1)
            XCTAssertTrue(synonyms?.first == "train")
        }
    }

    func testSynonymmerFail() {
        let terms = ["xxx", "yyy", "zzz"]
        let simpleSynonymer = SimpleSynonymmer(synonymMap: synonymMap)

        for term in terms {
            XCTAssertNil(simpleSynonymer.getSynonyms(for: term))
        }
    }
    
    func testSynonymmerFromFile() {
        let simpleSynonymer = SimpleSynonymmer(sourceFileName: "EmojiSynonyms")
        XCTAssertNotNil(simpleSynonymer)
    }
    
    func testSynonymmerFromFileSuccess() {
        let simpleSynonymer = SimpleSynonymmer(sourceFileName: "EmojiSynonyms")
        let correctSynonyms = "tech coder tester dev software developer engineer analyst".components(separatedBy: " ")

        let testSynonyms = simpleSynonymer?.getSynonyms(for: "technologist")
        
        XCTAssertTrue(testSynonyms!.count == correctSynonyms.count)
        
        for i in 0..<testSynonyms!.count {
            XCTAssertTrue(testSynonyms![i] == correctSynonyms[i])
        }
    }
}
