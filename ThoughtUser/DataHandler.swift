//
//  DataHandler.swift
//  ThoughtUser
//
//  Created by Josh MacDonald on 8/12/16.
//  Copyright © 2016 floydhillcode. All rights reserved.
//
import Foundation

class DataHandler {
    var userDict = [FieldNames.username: "",
                    FieldNames.email: "",
                    FieldNames.password: "",
                    FieldNames.display_name: ""] {
        didSet {
            NSLog("userDict: \(userDict)")
        }
    }
    
    
    func resetModelToOriginalValues() {
        userDict = [FieldNames.username: "",
                    FieldNames.email: "",
                    FieldNames.password: "",
                    FieldNames.display_name: ""]
    }
    
    
    func updateModelWithFieldText(fieldName: String, string: String) {
        if fieldName != FieldNames.passwordVerification {
            userDict[fieldName] = string
        }
    }
    
    //TODO: testing
    func submitDataToServer() -> String? {
        var returnedError: String? = nil
        
        if let data = convertDictionaryToJson(),
            let url = NSURL(string: URLs.post) {
            let request = NSMutableURLRequest(URL: url)
            
            request.HTTPMethod = HTTPMethods.post
            request.setValue(JSONText.jsonValue, forHTTPHeaderField: JSONText.headerField)
            request.HTTPBody = data
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) in
                if error != nil {
                    returnedError = error?.localizedDescription
                }
            })
            
            task.resume()
        }
        
        return returnedError
    }
    
    
    func convertDictionaryToJson() -> NSData? {
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(userDict, options: .PrettyPrinted)
            return jsonData
        } catch let conversionError as NSError {
            print("conversionError: \(conversionError)")
            return nil
        }
    }
}
