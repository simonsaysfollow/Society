//
//  SignUpModel.swift
//  Society
//
//  Created by Simon Tekeste on 1/28/20.
//  Copyright © 2020 Simon Tekeste. All rights reserved.
//

import UIKit
import Firebase

class UserInfo {
    var userid:String?
    var deviceid:String?
    
    init(userid:String, deviceid:String) {
        if userid.isEmpty || deviceid.isEmpty {
            return
        }
        self.userid = userid
        self.deviceid = deviceid
    }
}

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
        sendToDB()
        
    }
        
    func sendToDB() {
        let userNameAppended = Resuable().appendingEmailFormat(text: username!)
        Auth.auth().createUser(withEmail: userNameAppended, password: password!) { (success, error) in
            if (error != nil) {
                print(error?.localizedDescription ?? "An error has occured when attempting to register user")
                return
            }
            let obj = UserInfo(userid:(success?.user.uid)! , deviceid:  UIDevice.current.name)
            firebaseRef.child("deviceID").childByAutoId().setValue(["userid":obj.userid,"deviceid": obj.deviceid])

            print(success?.user.uid ?? "Empty userID")
            self.viewController?.dismiss(animated: true)
        }
        
    }
}
