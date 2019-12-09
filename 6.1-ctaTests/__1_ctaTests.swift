//
//  __1_ctaTests.swift
//  6.1-ctaTests
//
//  Created by Levi Davis on 12/2/19.
//  Copyright © 2019 Levi Davis. All rights reserved.
//

import XCTest
@testable import __1_cta

class __1_ctaTests: XCTestCase {

    func testEventFromJSON() {
        
        let testBundle = Bundle(for: type(of: self))
        guard let pathToData = testBundle.path(forResource: "ticketmasterJSON", ofType: "json") else { XCTFail("Couldn't find json file")
            return}

        let url = URL(fileURLWithPath: pathToData)
        do {
            let data = try Data(contentsOf: url)
            let events = try Event.getEvents(from: data)

            XCTAssert(events != nil, "We couldn't get those events")
        } catch {
            XCTFail(error.localizedDescription)
            print(error)
        }
        
    }
    
    func testArtFromJSON() {
        
        let testBundle = Bundle(for: type(of: self))
        guard let pathToData = testBundle.path(forResource: "museumJSON", ofType: "json") else { XCTFail("Couldn't find json file")
            return}

        let url = URL(fileURLWithPath: pathToData)
        do {
            let data = try Data(contentsOf: url)
            let art = try Art.getArt(from: data)

            XCTAssert(art != nil, "We couldn't get those arts")
        } catch {
            XCTFail(error.localizedDescription)
            print(error)
        }
    }

}
