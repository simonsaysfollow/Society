//
//  Reusable.swift
//  Society
//
//  Created by Simon Tekeste on 2/1/20.
//  Copyright © 2020 Simon Tekeste. All rights reserved.
//

import UIKit

public class Resuable {
    func removeEmailString(username:String) -> String {
        return username.replacingOccurrences(of: emailString, with: "")
    }
}
