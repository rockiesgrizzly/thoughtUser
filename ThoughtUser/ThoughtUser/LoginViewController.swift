//
//  LoginViewController.swift
//  ThoughtUser
//
//  Created by Josh MacDonald on 8/11/16.
//  Copyright © 2016 floydhillcode. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showResultVCSegue" {
            _ = segue.destinationViewController as! ResultViewController
        }
    }

}

