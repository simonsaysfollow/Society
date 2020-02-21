//
//  ViewController.swift
//  Society
//
//  Created by Simon Tekeste on 1/17/20.
//  Copyright © 2020 Simon Tekeste. All rights reserved.
//

import UIKit
import Firebase
import AudioToolbox

class ViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userName.attributedPlaceholder = "Username".textPlaceHolder()
        userName.addBottomBorder(borderWidth: 2, colorSwitch: nil)
        password.attributedPlaceholder = "Password".textPlaceHolder()
        password.addBottomBorder(borderWidth: 2, colorSwitch: nil)
        
        self.setupToHideKeyboardOnTapOnView()
    }
    

    @IBAction func loginBtn(_ sender: Any) {
        
        guard var usernameString = userName.text else {
            userName.addBottomBorder(borderWidth: 2, colorSwitch: 2)
            return
        }
        guard var passwordString = password.text else {
           password.addBottomBorder(borderWidth: 2, colorSwitch: 2)
           return
        }
        
        usernameString = Resuable().trimTheWhiteSpace(text: usernameString)
        usernameString = Resuable().appendingEmailFormat(text: usernameString)
        passwordString = Resuable().trimTheWhiteSpace(text: passwordString)

        Auth.auth().signIn(withEmail: usernameString, password: passwordString) { (success, error) in
            if (error != nil) {
                print(error?.localizedDescription ?? "Error signing in")
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                self.userName.addBottomBorder(borderWidth: 2, colorSwitch: 2)
                self.password.addBottomBorder(borderWidth: 2, colorSwitch: 2)
                return
            }
           self.present(categoryHome,animated: true)
        }
    }
}


