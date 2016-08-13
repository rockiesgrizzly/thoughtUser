//
//  DataHandlerTests.swift
//  ThoughtUser
//
//  Created by Josh MacDonald on 8/12/16.
//  Copyright © 2016 floydhillcode. All rights reserved.
//

import XCTest
import OHHTTPStubs

@testable import ThoughtUser

class DataHandlerTests: XCTestCase {
    var sut: DataHandler!

    override func setUp() {
        super.setUp()
        
        sut = DataHandler()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testUserDict_updateFromFieldText() {
        //passwordVerfication isn't stored in model
        
        sut.updateModelWithFieldText(FieldNames.username, string: "Catherine")
        XCTAssertEqual(sut.userDict[FieldNames.username], "Catherine")
        
        sut.updateModelWithFieldText(FieldNames.email, string: "catherine.janeway@voyager.com")
        XCTAssertEqual(sut.userDict[FieldNames.email], "catherine.janeway@voyager.com")
        
        sut.updateModelWithFieldText(FieldNames.password, string: "g0ld3nb1rd")
        XCTAssertEqual(sut.userDict[FieldNames.password], "g0ld3nb1rd")
        
        sut.updateModelWithFieldText(FieldNames.display_name, string: "Goldenbird")
        XCTAssertEqual(sut.userDict[FieldNames.display_name], "Goldenbird")
        
    }
    
    func testUserDict_convertedToJSON() {
        let data = sut.convertDictionaryToJson()
        XCTAssertNotNil(data)
    }
    
    
    func testDataSubmission() {
    //TODO: set up stubs
    }


}
