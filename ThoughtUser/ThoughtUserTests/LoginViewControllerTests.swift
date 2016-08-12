//
//  LoginViewControllerTests.swift
//  ThoughtUserTests
//
//  Created by Josh MacDonald on 8/11/16.
//  Copyright © 2016 floydhillcode. All rights reserved.
//

import XCTest
@testable import ThoughtUser

class LoginViewControllerTests: XCTestCase {
    
    var viewController: LoginViewController!
    var storyBoard: UIStoryboard!
    
    override func setUp() {
        super.setUp()
        
        storyBoard = UIStoryboard(name: VCNames.main, bundle: nil)
        viewController = storyBoard.instantiateInitialViewController() as? LoginViewController
        
        _ = viewController.view
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
}
