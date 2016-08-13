//
//  LoginViewControllerTests.swift
//  ThoughtUserTests
//
//  Created by Josh MacDonald on 8/11/16.
//  Copyright © 2016 floydhillcode. All rights reserved.
//

import XCTest
import OHHTTPStubs

@testable import ThoughtUser

class LoginViewControllerTests: XCTestCase {
    
    var sut: LoginViewController!
    var storyBoard: UIStoryboard!
    
    override func setUp() {
        super.setUp()
        
        storyBoard = UIStoryboard(name: VCNames.main, bundle: nil)
        sut = storyBoard.instantiateInitialViewController() as? LoginViewController
        
        _ = sut.view
        
//        stub(isHost(URLs.base) && isPath(URLs.post)) { _ in
//            guard let path = OHPathForFile("success_resource_response.json", self.dynamicType) else {
//                preconditionFailure("Could not find expected file in test bundle")
//            }
//            
//            return OHHTTPStubsResponse(
//                fileAtPath: path,
//                statusCode: 200,
//                headers: [ "Content-Type": "application/json" ]
//            )
//        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    func testFieldDelegation_setupAfterViewDidLoad() {
        let userDelegate = sut.userNameField.delegate
        XCTAssertNotNil(userDelegate)
        
        let emailDelegate = sut.emailField.delegate
        XCTAssertNotNil(emailDelegate)
        
        let passwordDelegate = sut.passwordField.delegate
        XCTAssertNotNil(passwordDelegate)
        
        let passwordVerifDelegate = sut.passwordVerificationField.delegate
        XCTAssertNotNil(passwordVerifDelegate)
        
        let displayDelegate = sut.displayNameField.delegate
        XCTAssertNotNil(displayDelegate)
    }
    
    
    func testFieldText_Validation() {
//        //TODO: test color change?
//        let greenValidatedColor = UIColor(red: 214 / 255, green: 255 / 255, blue: 218 / 255, alpha: 1.0)
//        let redValidatedColor = UIColor(red: 255 / 255, green: 216 / 255, blue: 219 / 255, alpha: 1.0)
        
        let username = UITextField()
        username.text = "J" //invalid text
        sut.validateTextFromTextField(username)
        XCTAssertEqual(sut.validatedFields[FieldNames.username], false)
        
        username.text = "Joe" //valid text
        sut.validateTextFromTextField(username)
        XCTAssertEqual(sut.validatedFields[FieldNames.username], false)
        
        //TODO: expand to all fields & readyToSubmit
    }
    
    
    func testSubmitButton_SubmitPossible(){
        sut.readyToSubmit = true
        sut.passwordField.text = "plutonium8"
        sut.passwordVerificationField.text = "plutonium8"
        sut.userNameField.text = "Pluto"
        sut.emailField.text = "pluto@pluto.com"
        let button = UIButton()
        sut.submitButtonTapped(button)
        
        XCTAssertEqual(sut.submissionTriggered, true)
        
        //tests password identical
        sut.readyToSubmit = true
        sut.passwordField.text = "plutonium88"
        sut.passwordVerificationField.text = "plutonium8"
        sut.userNameField.text = "Pluto"
        sut.emailField.text = "pluto@pluto.com"
        let newbutton = UIButton()
        sut.submitButtonTapped(newbutton)
        
        XCTAssertNotEqual(sut.submissionTriggered, true)
        
        //TODO: find better solution thatn submissionTriggered value
    }
    
    
    func testModelAndField_Reset() {
        sut.resetModelAndFields()
        
        //two of the resets
        XCTAssertEqual(sut.passwordVerificationField.text, "")
        XCTAssertEqual(sut.emailField.backgroundColor, UIColor.whiteColor())
    }
    
    
    

    
}
