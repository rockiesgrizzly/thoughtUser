//
//  DataHandler.swift
//  ThoughtUser
//
//  Created by Josh MacDonald on 8/12/16.
//  Copyright © 2016 floydhillcode. All rights reserved.
//
import Foundation

class DataHandler {
    let localNotifier = NSNotificationCenter.defaultCenter()
    
    var userDict = [FieldNames.username: "",
                    FieldNames.email: "",
                    FieldNames.password: "",
                    FieldNames.display_name: ""] {
        didSet {
            NSLog("userDict: \(userDict)")
        }
    }
    
    
    //MARK: Model handling
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
    

    func submitDataToServer() {
        
        //for local data
        let url = NSBundle.mainBundle().URLForResource(LocalURLs.post, withExtension: "json")
        
        //for web call
        //let url = NSURL(string: URLs.post)
        
        if let convertedData = convertDictionaryToJson(),
            let url = url {
            let request = NSMutableURLRequest(URL: url)
            
            request.HTTPMethod = HTTPMethods.post
            request.cachePolicy = .ReloadIgnoringCacheData
            request.timeoutInterval = 5
            request.setValue(JSONText.jsonValue, forHTTPHeaderField: JSONText.headerField)
            
            
            let task = NSURLSession.sharedSession().uploadTaskWithRequest(request, fromData: convertedData, completionHandler: { (data, response, error) in
                //TODO: 
                if let response = response as? NSHTTPURLResponse {
                    if response.statusCode == 400 {
                        self.localNotifier.postNotificationName(Notifications.postFailure400, object: self)
                        return
                    } else if response.statusCode == 401 {
                       //unauthorized
                        self.localNotifier.postNotificationName(Notifications.postFailure401, object: self)
                        return
                    } else if response.statusCode == 403 {
                        //forbidden
                        self.localNotifier.postNotificationName(Notifications.postFailure403, object: self)
                        return
                    } else if response.statusCode == 409 {
                        //conflict
                        self.localNotifier.postNotificationName(Notifications.postFailure409, object: self)
                        return
                    }
                }
                
                if error != nil {
                    self.localNotifier.postNotificationName(Notifications.postSuccess, object: self)
                }
                
                if let dataString = String(data: data!, encoding: NSUTF8StringEncoding) {
                    NSLog(dataString)
                }
            })
            
            task.resume()
        }
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
