//
// Created by Akash K on 22/07/15.
// Copyright (c) 2015 pepper square. All rights reserved.
//

import Foundation
import UIKit

public class RequiredValidator : BaseValidator {

    override func validate(control: UITextField) -> (Bool, String?){
        return control.text.isEmpty ? (false, errMsg) : (true, nil)
    }
    override func name() -> String{
        return "RequiredValidator"
    }
}
