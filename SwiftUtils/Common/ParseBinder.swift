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

    func saveObj(parseObj: PFObject, succFn: () -> Void, failFn: (NSError) -> Void) {
        log.warning("Saving ParseObject \(parseObj)")
        parseObj.saveInBackgroundWithBlock({
            (success: Bool, error: NSError?) -> Void in

            if error == nil {
                succFn()
            } else {
                log.warning("saveObj: saving \(parseObj) failed", userInfo: ["error": error!])
                failFn(error!)
            }
        })
    }

    func bindToParse(control: UITextField,
                     validators: [BaseValidator],
                     succFn: (UITextField) -> Void,
                     errFn: (UITextField, [String]) -> Void,
                     errAccumulator: ([String]) -> Void) {

        log.debug("BindToParse: control:\(control), validators: \(validators.count)")

        var status = true
        var errMsg = [String]()
        for validator in validators {
            let (s, err) = validator.validate(control)
            if (!s) {
                log.warning("BindToParse: control\(control) validation failed for \(validator.name())")
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

    func bindToUI(control: UIControl, parseObj: PFObject, key: String) {

        log.debug("Setting Value \(parseObj[key]) to \(control)")

        let parsevalue: AnyObject? = parseObj[key]

        if parsevalue == nil && control is UITextField {
            (control as! UITextField).text = ""
            return
        }
        if parsevalue is Int {

            (control as! UITextField).text = String(parsevalue as! Int)
        } else {
            (control as! UITextField).text = parseObj[key] as! String
        }

    }

    func bindToImage(control: UIImageView, parseObj: PFObject, key: String) {

        log.debug("Binding Image \(parseObj[key]) to \(control)")
        let parsevalue: AnyObject? = parseObj[key]

        if parsevalue is PFFile {

            let userImageFile = parsevalue as! PFFile
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if !(error != nil) {
                    let image = UIImage(data: imageData!)
                    control.image = image
                } else {
                    log.error("Binding Image \(parseObj[key]) to \(control) Failed", userInfo: ["error": error!])
                }
            }
        }

    }

    func noValidate(control: UITextField) -> (Bool, String?) {
        return (true, nil)
    }

    func requiredValidator(errMsg: String) -> BaseValidator {
        return RequiredValidator(errMsg: errMsg)
    }

    func regExValidator(regEx: String, errMsg: String) -> BaseValidator {
        return RegExValidator(errMsg: errMsg, regEx: regEx)
    }

    func redErrMsg(control: UITextField, errMsg: [String]) {
        control.layer.borderColor = UIColor.redColor().CGColor
        control.layer.borderWidth = 1.0
    }

    func setToParse(partObj: PFObject, key: String) -> (UITextField) -> Void {

        return {
            (control) in partObj[key] = control.text
        }
    }

    func convertAndSetToParse(partObj: PFObject, key: String) -> (UITextField) -> Void {

        return {
            (control) in partObj[key] = control.text.toInt()
        }
    }

}