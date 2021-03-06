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
        
        //TODO: Change to Swift 2.0
        //print("Assign Role \(role) to User \(newUser.username)", terminator: "")
        //        let roleQuery = PFRole.query()
        //        roleQuery?.whereKey("name", equalTo: role)
        //        roleQuery?.findObjectsInBackgroundWithBlock {
        //            (objects: [AnyObject]?, error: NSError?) -> Void in
        //
        //            if let usersToAddToRole = objects {
        //                for users in usersToAddToRole {
        //
        //                    users.users.addObject(newUser)
        //                    users.saveInBackground()
        //                }
        //            }
        //        }
    }
    
    public func createEntityForUser(hotelName: String) {
        
        let hotel = PFObject(className: "Hotel")
        hotel["name"] = hotelName
        hotel["owner"] = PFUser.currentUser()!
        hotel.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            
            if success {
                
                print("Entity created successfully", terminator: "")
                
                let updateUser = PFUser.currentUser()
                updateUser?.setObject(updateUser!, forKey: "createdBy")
                updateUser?.setObject(hotel, forKey: "hotelID")
                updateUser?.saveInBackground()
                
            } else {
                print("\(error?.userInfo)", terminator: "")
            }
        }
        
    }
    
    public func revertUser(sessionToken: String) {
        
        PFUser.becomeInBackground(sessionToken, block: {
            (user: PFUser?, error: NSError?) -> Void in
            if error != nil {
                // The token could not be validated.
            } else {
                print("\(error?.userInfo)", terminator: "")
            }
        })
    }
}