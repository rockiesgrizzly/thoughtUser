//
//  ResultViewController.swift
//  ThoughtUser
//
//  Created by Josh MacDonald on 8/11/16.
//  Copyright © 2016 floydhillcode. All rights reserved.
//

import XCTest
@testable import ThoughtUser

class ResultViewController: XCTestCase {
    
    var viewController: ResultViewController!
    var storyBoard: UIStoryboard!
    
    override func setUp() {
        super.setUp()
        
        storyBoard = UIStoryboard(name: VCNames.main, bundle: nil)
        viewController = storyBoard.instantiateViewControllerWithIdentifier(VCNames.resultViewController) as? ResultViewController
        
        _ = viewController.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    
}
