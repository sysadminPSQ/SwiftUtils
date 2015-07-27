//
// Created by Akash K on 22/07/15.
// Copyright (c) 2015 pepper square. All rights reserved.
//

import Foundation
import UIKit

class BaseValidator {
    var errMsg: String;

    init(errMsg: String) {
        self.errMsg = errMsg
    }

    func validate(control: UITextField) -> (Bool, String?) {
        preconditionFailure("This method must be overridden")
    }
    func name() -> String {
        preconditionFailure("This method must be overridden")
    }
}
