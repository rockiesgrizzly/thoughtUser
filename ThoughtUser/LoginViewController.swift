//
//  LoginViewController.swift
//  ThoughtUser
//
//  Created by Josh MacDonald on 8/11/16.
//  Copyright © 2016 floydhillcode. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var userNameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var passwordVerificationField: UITextField!
    @IBOutlet var displayNameField: UITextField!
    
    @IBOutlet var submitButton: UIButton!
    
    var readyToSubmit = false
    var submissionTriggered = false
    
    var dataHandler: DataHandler? = DataHandler()
    
    let localNotifier = NSNotificationCenter.defaultCenter()
    
    var validatedFields = [FieldNames.username: false,
                           FieldNames.email: false,
                           FieldNames.password: false,
                           FieldNames.passwordVerification: false]
    
    var allTextFields: [UITextField]!
    
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allTextFields = [userNameField, emailField, passwordField, passwordVerificationField, displayNameField]
        setupDelegation()
        updateSubmitButtonInteraction()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidLoad()
        resetModelAndFields()
        
        localNotifier.addObserver(self, selector: #selector(respondToPostSuccess), name: Notifications.postSuccess, object: dataHandler)
        localNotifier.addObserver(self, selector: #selector(respondToPost400), name: Notifications.postFailure400, object: dataHandler)
        localNotifier.addObserver(self, selector: #selector(respondToPost401), name: Notifications.postFailure401, object: dataHandler)
        localNotifier.addObserver(self, selector: #selector(respondToPost403), name: Notifications.postFailure403, object: dataHandler)
        localNotifier.addObserver(self, selector: #selector(respondToPost409), name: Notifications.postFailure409, object: dataHandler)
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        dataHandler?.resetModelToOriginalValues()
    }
    
    
    deinit {
        localNotifier.removeObserver(self)
        
        for field in allTextFields {
            field.removeTarget(self, action: #selector(textFieldDidChange), forControlEvents: .EditingChanged)
        }
    }
    
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    func setupDelegation() {
        for field in allTextFields {
            field.delegate = self
        }
    }
    
    
    //MARK: TextField Handling
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.addTarget(self, action: #selector(textFieldDidChange), forControlEvents: .EditingChanged)
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        validateTextFromTextField(textField)
    }
    
    
    func textFieldDidChange(textField: UITextField) {
        validateTextFromTextField(textField)
    }
    
    
    func validateTextFromTextField(textField: UITextField) {
        switch textField {
        case userNameField:
            if let text = textField.text
                where text.characters.count > 2 {
                
                updateValuesForValidateFields(true, textField: textField, fieldName: FieldNames.username, text: text)
                
                //set username as display name if no display name
                if dataHandler?.userDict[FieldNames.display_name] == nil {
                    dataHandler?.updateModelWithFieldText(FieldNames.display_name, string: text)
                }
                
            } else {
                updateValuesForValidateFields(false, textField: textField, fieldName: FieldNames.username, text: nil)
            }
            
        case emailField:
            if let text = textField.text where
                text.characters.count > 7
                    && textField.text?.containsString("@") == true
                    && textField.text?.containsString(".") == true {
                
                updateValuesForValidateFields(true, textField: textField, fieldName: FieldNames.email, text: text)
            } else {
                updateValuesForValidateFields(false, textField: textField, fieldName: FieldNames.email, text: nil)
            }
            
        case passwordField:
            let decimalCharacters = NSCharacterSet.decimalDigitCharacterSet()
            
            if let text = textField.text
                where text.characters.count > 7
                    && text.rangeOfCharacterFromSet(decimalCharacters) != nil {
                
                updateValuesForValidateFields(true, textField: textField, fieldName: FieldNames.password, text: text)
                
            } else {
                updateValuesForValidateFields(false, textField: textField, fieldName: FieldNames.password, text: nil)
                
            }
            
        case passwordVerificationField:
            let decimalCharacters = NSCharacterSet.decimalDigitCharacterSet()
            
            if let text = textField.text
                where text.characters.count > 7
                    && text.rangeOfCharacterFromSet(decimalCharacters) != nil {
                
                showFieldAsValidated(textField, validated: true)
                validatedFields.updateValue(true, forKey: FieldNames.passwordVerification)
            } else {
                showFieldAsValidated(textField, validated: false)
                validatedFields.updateValue(false, forKey: FieldNames.passwordVerification)
            }
            
        case displayNameField:
            //Field is optional
            if let text = textField.text where text != "" {
                updateValuesForValidateFields(true, textField: textField, fieldName: FieldNames.display_name, text: text)
            } else {
                displayNameField.backgroundColor = UIColor.whiteColor()
            }
            
        default:
            break
        }
        
        if validatedFields.values.contains(false) {
            readyToSubmit = false
        } else {
            readyToSubmit = true
        }
        
        updateSubmitButtonInteraction()
    }
    
    
    func updateValuesForValidateFields(bool: Bool, textField: UITextField, fieldName: String, text: String?) {
        if bool == true, let text = text {
            validatedFields.updateValue(true, forKey: fieldName)
            dataHandler?.updateModelWithFieldText(fieldName, string: text)
            showFieldAsValidated(textField, validated: true)
        } else {
            validatedFields.updateValue(false, forKey: fieldName)
            dataHandler?.updateModelWithFieldText(fieldName, string: "")
            showFieldAsValidated(textField, validated: false)
        }
        
    }
    
    
    func showFieldAsValidated(textField: UITextField, validated: Bool) {
        if validated == true {
            textField.backgroundColor = UIColor(red: 214 / 255, green: 255 / 255, blue: 218 / 255, alpha: 1.0)
        } else if textField.text != "" {
            textField.backgroundColor = UIColor(red: 230 / 255, green: 230 / 255, blue: 230 / 255, alpha: 1.0)
        } else {
            textField.backgroundColor = UIColor.whiteColor()
        }
    }
    
    
    func updateSubmitButtonInteraction() {
        if readyToSubmit == true {
            submitButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        } else {
            submitButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        }
    }
    
    
    @IBAction func submitButtonTapped(sender: UIButton) {
        var alert: UIAlertController?
        
        let passwordsIdentical = passwordVerificationField.text == passwordField.text
        let usernameEmailUnique = userNameField.text != emailField.text
        
        if readyToSubmit == true
            && passwordsIdentical
            && usernameEmailUnique {
            
            triggerSubmission()
            
        } else {
            submissionTriggered = false
            
            let body = generateFailedFieldsBodyText()
            
            alert = UIAlertController(title: SubmitFailedMessages.fieldsNeeded,
                                      message: body,
                                      preferredStyle: .Alert)
            
            if let alert = alert {
                let dismissAction = UIAlertAction(title: SubmitFailedMessages.dismissTitle, style: .Cancel, handler: nil)
                alert.addAction(dismissAction)
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.showViewController(alert, sender: self)
                })
            }
        }
    }
    
    
    func generateFailedFieldsBodyText() -> String {
        var returnText = ""
        
        if validatedFields[FieldNames.username] == false {
            returnText += SubmitFailedMessages.username
        }
        
        if userNameField.text == emailField.text {
            returnText += SubmitFailedMessages.userNameEmailUnique
        }
        
        if validatedFields[FieldNames.email] == false {
            returnText += SubmitFailedMessages.email
        }
        
        if validatedFields[FieldNames.password] == false {
            returnText += SubmitFailedMessages.password
        }
        
        if passwordVerificationField.text != passwordField.text {
            returnText += SubmitFailedMessages.passwordsIdentical
        }
    
        return returnText
    }
    
    
    func triggerSubmission() {
        submissionTriggered = true
        
        dataHandler?.submitDataToServer()
    }
    
    
    func respondToPostSuccess() {
        resetModelAndFields()
        
        var alert: UIAlertController?
        
        alert = UIAlertController(title: SubmitFailedMessages.submissionSuccessful,
                                  message: SubmitFailedMessages.submissionSuccessfulBody,
                                  preferredStyle: .Alert)
        
        if let alert = alert {
            let dismissAction = UIAlertAction(title: SubmitFailedMessages.dismissTitle, style: .Cancel, handler: nil)
            alert.addAction(dismissAction)
            
            dispatch_async(dispatch_get_main_queue(), {
                self.showViewController(alert, sender: self)
            })
        }
        
    }
    
    //MARK: Failure Responses
    func respondToPost400() {
        respondToPostFailure(.failed400)
    }
    
    
    func respondToPost401() {
        respondToPostFailure(.failed401)
    }
    
    
    func respondToPost403() {
        respondToPostFailure(.failed403)
    }

    
    func respondToPost409() {
        respondToPostFailure(.failed409)
    }
    
    
    func respondToPostFailure(code: SubmitErrorMessages) {
        var alert: UIAlertController?
        alert = UIAlertController(title: SubmitFailedMessages.submissionFailed,
                                  message: code.rawValue,
                                  preferredStyle: .Alert)
        
        if let alert = alert {
            let dismissAction = UIAlertAction(title: SubmitFailedMessages.dismissTitle, style: .Cancel, handler: nil)
            alert.addAction(dismissAction)
            
            dispatch_async(dispatch_get_main_queue(), {
                self.showViewController(alert, sender: self)
            })
        }
    }
    
    
    func resetModelAndFields() {
        for field in allTextFields {
            field.text = ""
            field.backgroundColor = UIColor.whiteColor()
        }

        
        userNameField.becomeFirstResponder()
        
        readyToSubmit = false
        updateSubmitButtonInteraction()
        
        dataHandler?.resetModelToOriginalValues()
    }    
}

