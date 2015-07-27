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

class ParseUtils {

    func assignUserToRole(newUser: PFUser, role: String) {

        log.debug("Assign Role \(role) to User \(newUser.username)")
        var roleQuery = PFRole.query()
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

    func createEntityForUser(company: String) {

        var entity = PFObject(className: "Entity")
        entity["entityName"] = company
        entity["createdBy"] = PFUser.currentUser()
        entity.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in

            if success {

                println("Entity created successfully")

                var updateUser = PFUser.currentUser()
                updateUser?.setObject(updateUser!, forKey: "createdBy")
                updateUser?.setObject(entity, forKey: "entityId")
                updateUser?.saveInBackground()

            } else {
                println("\(error?.userInfo)")
            }
        }

    }

    func revertUser(sessionToken: String) {

        PFUser.becomeInBackground(sessionToken, block: {
            (user: PFUser?, error: NSError?) -> Void in
            if error != nil {
                // The token could not be validated.
            } else {
                println("\(error?.userInfo)")
            }
        })
    }
}