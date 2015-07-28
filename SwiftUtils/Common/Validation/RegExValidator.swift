//
// Created by Akash K on 22/07/15.
// Copyright (c) 2015 pepper square. All rights reserved.
//

import Foundation
import UIKit

class RegExValidator: BaseValidator {
    var regEx: String;
    public init(errMsg: String, regEx: String) {
        self.regEx = regEx
        super.init(errMsg: errMsg)
    }

    override func validate(control: UITextField) -> (Bool, String?) {
        let test = NSPredicate(format: "SELF MATCHES %@", regEx)
        let status =  test.evaluateWithObject(control.text)
        return status ? (true, nil) : (false, errMsg)
    }
    override func name() -> String {
        return "RegExValidator\(regEx)"
    }
}
