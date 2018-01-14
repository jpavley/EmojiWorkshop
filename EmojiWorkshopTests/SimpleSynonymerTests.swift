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
    
    func testCreateSynonymer() {
        let simpleSynonymer = SimpleSynonymer(synonymMap: synonymMap)
        XCTAssertNotNil(simpleSynonymer)
    }
    
    func testSynonymerSuccess() {
        let terms = ["tram", "metro", "rail", "monorail", "railway"]
        let simpleSynonymer = SimpleSynonymer(synonymMap: synonymMap)
        
        for term in terms {
            XCTAssertTrue(simpleSynonymer.getSynonym(for: term) == "train")
        }
    }
    
    func testSynonymerSuccessChaseChange() {
        let terms = ["Tram", "metro", "Rail", "monorail", "RAILWAY"]
        let simpleSynonymer = SimpleSynonymer(synonymMap: synonymMap)

        for term in terms {
            XCTAssertTrue(simpleSynonymer.getSynonym(for: term) == "train")
        }
    }

    
    
}
