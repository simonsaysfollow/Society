//
//  SignUpModel.swift
//  Society
//
//  Created by Simon Tekeste on 1/28/20.
//  Copyright © 2020 Simon Tekeste. All rights reserved.
//

import UIKit
import Firebase

class SignUpModel {
    var username:String?
    var password:String?
    var viewController:UIViewController?
    
    init(username:String, password:String, viewController:UIViewController) {
        if username.isEmpty || password.isEmpty {
            return
        }
        self.username = username
        self.password = password
        self.viewController = viewController
        appendingEmailFormat()
    }
    
    fileprivate func appendingEmailFormat() {
        self.username?.append("@society.com")
        sendToDB()
    }
    
    func sendToDB() {
        Auth.auth().createUser(withEmail: username!, password: password!) { (success, error) in
            if (error != nil) {
                print(error?.localizedDescription)
                return
            }
            print(success?.user.uid ?? "Empty userID")
            self.viewController?.dismiss(animated: true)
        }
        
    }
}
