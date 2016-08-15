//
//  StringsAndEnums.swift
//  ThoughtUser
//
//  Created by Josh MacDonald on 8/11/16.
//  Copyright © 2016 floydhillcode. All rights reserved.
//

struct JSONText {
    static let jsonValue = "application/json; charset=utf-8"
    static let headerField = "Content-Type"
}

struct FieldNames {
    static let username = "username"
    static let email = "email"
    static let password = "password"
    static let passwordVerification = "passwordVerification"
    static let display_name = "display_name"
}

struct HTTPMethods {
    static let post = "POST"
}

struct Notifications {
    static let postSuccess = "postSuccess"
//    static let postFailure400 = "postFailure400"
//    static let postFailure401 = "postFailure401"
//    static let postFailure403 = "postFailure403"
//    static let postFailure409 = "postFailure409"
}

struct SegueNames {
    static let showResultVCSegue = "showResultVCSegue"
}

struct SubmitFailedMessages {
    static let dismissTitle = "Dismiss"
    static let email = "Email must be have at least 7 characters and contain a valid email address. "
    static let fieldsNeeded = "The form isn't quite ready..."
    static let password = "Password must have at least 8 characters and contain a number. "
    static let passwordsIdentical = "Passwords must match."
    static let submissionFailed = "My apologies. Your Submission Failed."
    static let submissionSuccessful = "Success!"
    static let submissionSuccessfulBody = "Submission successful. User Created."
    static let username = "Username must have atleast two characters. "
    static let userNameEmailUnique = "Username and Email Must be unique. "
}

struct URLs {
    static let base = "joshmac.com"
    static let post = "/api/1/new-user"
}

struct LocalURLs {
    static let post = "new-user"
}

struct VCNames {
    static let loginViewController = "LoginViewController"
    static let main = "Main"
    static let resultViewController = "ResultViewController"
}

//MARK: Enums
//enum SubmitErrorMessages: String {
//    case failed400 = "Your submission was rejected by the server due to a bad request."
//    case failed401 = "Your submission was rejected by the server due to an unauthorized request."
//    case failed403 = "Your submission was rejected by the server due to a forbidden request."
//    case failed409 = "Your submission was rejected by the server because there's an existing record that matches yours."
//}





