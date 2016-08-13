//
//  User+CoreDataProperties.swift
//  ThoughtUser
//
//  Created by Josh MacDonald on 8/12/16.
//  Copyright © 2016 floydhillcode. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {
    @NSManaged var username: String?
    @NSManaged var email: String?
    @NSManaged var password: String?
    @NSManaged var display_name: String?
}
