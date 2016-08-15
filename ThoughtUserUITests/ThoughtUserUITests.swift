//
//  ThoughtUserUITests.swift
//  ThoughtUserUITests
//
//  Created by Josh MacDonald on 8/11/16.
//  Copyright © 2016 floydhillcode. All rights reserved.
//

import XCTest

class ThoughtUserUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_elementsExist() {
        let app = XCUIApplication()

        XCTAssert(app.staticTexts["ThoughtUser"].exists)
        XCTAssert(app.textFields["Username"].exists)
        XCTAssert(app.textFields["Email"].exists)
        XCTAssert(app.secureTextFields["Password"].exists)
        XCTAssert(app.secureTextFields["Verify Password"].exists)
        XCTAssert(app.textFields["Display Name (Optional)"].exists)
        XCTAssert(app.buttons["Submit"].exists)
    }
    
    
    func testValidatedText_ShouldAllowSubmit() {
        let app = XCUIApplication()
        app.textFields["Username"].tap()
        app.textFields["Username"].typeText("Bono")

        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("bono@u2.com")
        
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("achtungBaby3")
        
        app.secureTextFields["Verify Password"].tap()
        app.secureTextFields["Verify Password"].typeText("achtungBaby3")
        
        app.buttons["Submit"].tap()
        
        let successAlert = XCUIApplication().alerts["Success!"]
            //.staticTexts["Success!"]
        
        XCTAssert(successAlert.exists)
        
        
//        XCTAssert(app.alerts["Success"].exists)
//        let dismissButton = app.alerts["Not Success!"].collectionViews.buttons["Dismiss"]
    }
    
    func testInvalidatedText_ShouldNotAllowSubmit() {
        let app = XCUIApplication()
        app.textFields["Username"].tap()
        app.textFields["Username"].typeText("B")
        
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("b")
        
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("a")
        
        app.secureTextFields["Verify Password"].tap()
        app.secureTextFields["Verify Password"].typeText("a")

        app.buttons["Submit"].tap()
        
        let failureAlert = XCUIApplication().alerts["The form isn't quite ready..."]
            //.collectionViews.buttons["Dismiss"].tap()
        
        XCTAssert(failureAlert.exists)
    }
    
    
    func testPassWordsDontMatchText_ShouldNotAllowSubmit() {
        let app = XCUIApplication()
        app.textFields["Username"].tap()
        app.textFields["Username"].typeText("Bono")
        
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("bono@u2.com")
        
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("achtungBaby4")
        
        app.secureTextFields["Verify Password"].tap()
        app.secureTextFields["Verify Password"].typeText("achtungBaby3")

        app.buttons["Submit"].tap()
        
        let failureAlert = XCUIApplication().alerts["The form isn't quite ready..."]
        //.collectionViews.buttons["Dismiss"].tap()
        
        XCTAssert(failureAlert.exists)
        
    }
    
    func testUserEmailIdenticalText_ShouldNotAllowSubmit() {
        let app = XCUIApplication()
        app.textFields["Username"].tap()
        app.textFields["Username"].typeText("bono@u2.com")
        
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("bono@u2.com")
        
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("achtungBaby4")
        
        app.secureTextFields["Verify Password"].tap()
        app.secureTextFields["Verify Password"].typeText("achtungBaby3")
        
        app.buttons["Submit"].tap()
        
        let failureAlert = XCUIApplication().alerts["The form isn't quite ready..."]
        //.collectionViews.buttons["Dismiss"].tap()
        
        XCTAssert(failureAlert.exists)
        
    }
    
    
}
