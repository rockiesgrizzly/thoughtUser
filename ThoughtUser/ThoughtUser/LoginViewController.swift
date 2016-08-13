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
    
    var validatedFields = [FieldNames.username: false,
                           FieldNames.email: false,
                           FieldNames.password: false,
                           FieldNames.passwordVerification: false]
    
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegation()
        updateSubmitButtonInteraction()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidLoad()
        resetModelAndFields()
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        dataHandler?.resetModelToOriginalValues()
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    
    func setupDelegation() {
        userNameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        passwordVerificationField.delegate = self
        displayNameField.delegate = self
    }

    
    
    //MARK: TextField Handling
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        validateTextFromTextField(textField)
        return true
    }
    
    
    func validateTextFromTextField(textField: UITextField) {
        switch textField {
        case userNameField:
            if let text = textField.text
                where text.characters.count > 2 {
                
                updateValuesForValidateFields(true, textField: textField, fieldName: FieldNames.username, text: text)
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
            textField.backgroundColor = UIColor(red: 255 / 255, green: 216 / 255, blue: 219 / 255, alpha: 1.0)
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
        var alert: UIAlertController?
        submissionTriggered = true
        
        if let submissionResponseError = dataHandler?.submitDataToServer() {
            //error returned from response
            alert = UIAlertController(title: SubmitFailedMessages.submissionFailed,
                                      message: submissionResponseError,
                                      preferredStyle: .Alert)
        } else {
            resetModelAndFields()
            
            alert = UIAlertController(title: SubmitFailedMessages.submissionSuccessful,
                                      message: SubmitFailedMessages.submissionSuccessfulBody,
                                      preferredStyle: .Alert)
        }
        
        
        if let alert = alert {
            let dismissAction = UIAlertAction(title: SubmitFailedMessages.dismissTitle, style: .Cancel, handler: nil)
            alert.addAction(dismissAction)
            
            dispatch_async(dispatch_get_main_queue(), {
                self.showViewController(alert, sender: self)
            })
        }
    }
    
    
    func resetModelAndFields() {
        userNameField.text = ""
        emailField.text = ""
        passwordField.text = ""
        passwordVerificationField.text = ""
        displayNameField.text = ""
        
        
        userNameField.backgroundColor = UIColor.whiteColor()
        emailField.backgroundColor = UIColor.whiteColor()
        passwordField.backgroundColor = UIColor.whiteColor()
        displayNameField.backgroundColor = UIColor.whiteColor()
        
        readyToSubmit = false
        updateSubmitButtonInteraction()
        
        dataHandler?.resetModelToOriginalValues()
    }
    
    
    
}

