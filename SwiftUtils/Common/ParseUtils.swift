//
//  ParseUtils.swift
//  RoomAdvantage
//
//  Created by Akash K on 20/07/15.
//  Copyright (c) 2015 pepper square. All rights reserved.
//

import Foundation
import UIKit
import Parse
import Bolts

public class ParseUtils {
    
    public init() {
        
    }
    public func assignUserToRole(newUser: PFUser, role: String) {
        
        print("Assign Role \(role) to User \(newUser.username)")
        let roleQuery = PFRole.query()
        roleQuery?.whereKey("name", equalTo: role)
        roleQuery?.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if let usersToAddToRole = objects {
                for users in usersToAddToRole {
                    
                    users.users.addObject(newUser)
                    users.saveInBackground()
                }
            }
        }
    }
    
    public func createEntityForUser(company: String) {
        
        let entity = PFObject(className: "Entity")
        entity["entityName"] = company
        entity["createdBy"] = PFUser.currentUser()!
        entity.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            
            if success {
                
                print("Entity created successfully")
                
                let updateUser = PFUser.currentUser()
                updateUser?.setObject(updateUser!, forKey: "createdBy")
                updateUser?.setObject(entity, forKey: "entityId")
                updateUser?.saveInBackground()
                
            } else {
                print("\(error?.userInfo)")
            }
        }
        
    }
    
    public func revertUser(sessionToken: String) {
        
        PFUser.becomeInBackground(sessionToken, block: {
            (user: PFUser?, error: NSError?) -> Void in
            if error != nil {
                // The token could not be validated.
            } else {
                print("\(error?.userInfo)")
            }
        })
    }
}