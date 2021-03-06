//
//  ParseBinder.swift
//  RoomAdvantage
//
//  Created by Akash K on 17/07/15.
//  Copyright (c) 2015 pepper square. All rights reserved.
//

import Foundation
import UIKit
import Parse
import Bolts

public class ParseBinder {
    
    public init() {
        
    }
    public func saveObj(parseObj: PFObject, succFn: () -> Void, failFn: (NSError) -> Void) {
        
        print("Saving ParseObject \(parseObj)", terminator: "")
        parseObj.saveInBackgroundWithBlock({
            (success: Bool, error: NSError?) -> Void in
            
            if error == nil {
                succFn()
            } else {
                print("saveObj: saving \(parseObj) failed, userInfo: \([error!])", terminator: "")
                failFn(error!)
            }
        })
    }
    
    public func bindToParse(control: UITextField,
        validators: [BaseValidator],
        succFn: (UITextField) -> Void,
        errFn: (UITextField, [String]) -> Void,
        errAccumulator: ([String]) -> Void) {
            
            // println("BindToParse: control:\(control), validators: \(validators.count)")
            
            var status = true
            var errMsg = [String]()
            for validator in validators {
                let (s, err) = validator.validate(control)
                if (!s) {
                    print("BindToParse: control\(control) validation failed for \(validator.name())", terminator: "")
                    status = false
                    errMsg.append(err!)
                    break
                }
            }
            if (status) {
                succFn(control)
                
            } else {
                errFn(control, errMsg)
                errAccumulator(errMsg)
            }
            
    }
    
    public func bindToUI(control: UIControl, parseObj: PFObject, key: String) {
        
        print("Setting Value \(parseObj[key]) to \(control)", terminator: "")
        
        let parsevalue: AnyObject? = parseObj[key]
        
        if parsevalue == nil && control is UITextField {
            (control as! UITextField).text = ""
            return
        }
        if parsevalue is Int {
            
            (control as! UITextField).text = String(parsevalue as! Int)
        } else {
            (control as! UITextField).text = parseObj[key] as? String
        }
        
    }
    
    public func bindToImage(control: UIImageView, parseObj: PFObject, key: String) {
        
        print("Binding Image \(parseObj[key]) to \(control)", terminator: "")
        let parsevalue: AnyObject? = parseObj[key]
        
        if parsevalue is PFFile {
            
            let userImageFile = parsevalue as! PFFile
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if !(error != nil) {
                    let image = UIImage(data: imageData!)
                    control.image = image
                } else {
                    print("Binding Image \(parseObj[key]) to \(control) Failed, userInfo:  \([error!])", terminator: "")
                }
            }
        }
        
    }
    
    public func noValidate(control: UITextField) -> (Bool, String?) {
        return (true, nil)
    }
    
    public func requiredValidator(errMsg: String) -> BaseValidator {
        return RequiredValidator(errMsg: errMsg)
    }
    
    public func regExValidator(regEx: String, errMsg: String) -> BaseValidator {
        return RegExValidator(errMsg: errMsg, regEx: regEx)
    }
    
    public func redErrMsg(control: UITextField, errMsg: [String]) {
        
        //Shake animation if wrong values are entered in the textfields
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(control.center.x - 10, control.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(control.center.x + 10, control.center.y))
        control.layer.addAnimation(animation, forKey: "position")
        
        control.layer.borderColor = UIColor.redColor().CGColor
        control.layer.borderWidth = 1.0
        control.layer.cornerRadius = 5.0
    }
    
    public func setToParse(partObj: PFObject, key: String) -> (UITextField) -> Void {
        
        return {
            (control) in partObj[key] = control.text
            print("The value recieved during bindToParse is : \(control.text)", terminator: "")
            control.layer.borderColor = UIColor.clearColor().CGColor
            control.layer.borderWidth = 0.0
            control.layer.cornerRadius = 0.0
        }
    }
    
    public func convertAndSetToParse(partObj: PFObject, key: String) -> (UITextField) -> Void {
        
        return {
            (control) in partObj[key] = Int(control.text!)
            control.layer.borderColor = UIColor.clearColor().CGColor
            control.layer.borderWidth = 0.0
            control.layer.cornerRadius = 0.0
        }
    }
    
    public func convertToArray(partObj: PFObject, key: String) -> (UITextField) -> Void {
        
        return {
            
            (control) in
            
            (partObj as! SubClassedPFObjects).addValue(key, value: control.text)
            print("The value recieved during convertToArray is : \(control.text) and the parse Object is \(partObj)", terminator: "" )
            control.layer.borderColor = UIColor.clearColor().CGColor
            control.layer.borderWidth = 0.0
            control.layer.cornerRadius = 0.0
        }
    }
    
}

public class SubClassedPFObjects: PFObject {
    
    public func addValue(key: String, value: Any){
        
    }
    public func hasErrors() -> Bool {
        return false
    }
}
