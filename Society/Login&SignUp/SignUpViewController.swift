//
//  SIgnUpViewController.swift
//  Society
//
//  Created by Simon Tekeste on 1/17/20.
//  Copyright © 2020 Simon Tekeste. All rights reserved.
//

import UIKit
import AudioToolbox

class SignUpViewController: UIViewController {
    
    //MARK:IBoutlets
    @IBOutlet weak var userNameSignUp: UITextField!
    @IBOutlet weak var passwordSignUp: UITextField!
    @IBOutlet weak var confirmPassordSignUp: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupToHideKeyboardOnTapOnView()
        
        userNameSignUp.attributedPlaceholder = "Username".textPlaceHolder()
        userNameSignUp.addBottomBorder(borderWidth: 2, colorSwitch: nil)
        passwordSignUp.attributedPlaceholder = "Password".textPlaceHolder()
        passwordSignUp.addBottomBorder(borderWidth: 2, colorSwitch: nil)
        confirmPassordSignUp.attributedPlaceholder = "Confirm Password".textPlaceHolder()
        confirmPassordSignUp.addBottomBorder(borderWidth: 2, colorSwitch: nil)
    }
    
    fileprivate func passwordMatchCheck() -> Bool {
        //Making sure no whitespaces exist
        self.passwordSignUp.text = self.passwordSignUp!.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        self.confirmPassordSignUp.text = self.confirmPassordSignUp!.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if passwordSignUp.text != confirmPassordSignUp.text {
            //vibrates and changes the bottom border red to alert user wrong password
            badCredentials()
            return false
        }
        //Checking to make sure password and confirmation match and reset bottom border
       passwordSignUp.addBottomBorder(borderWidth: 2, colorSwitch: 0)
       confirmPassordSignUp.addBottomBorder(borderWidth: 2, colorSwitch: 0)
       return true
    }
    
    //Can be reusable -> change later
    func badCredentials() {
       AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
       passwordSignUp.addBottomBorder(borderWidth: 2, colorSwitch: 2)
       confirmPassordSignUp.addBottomBorder(borderWidth: 2, colorSwitch: 2)
    }
    
    
    //MARK: IBActions
    @IBAction func submitSigningUp(_ sender: Any) {
        //removes whitespace from username
        self.userNameSignUp.text = self.userNameSignUp.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //add the push to the db on success dismiss
        _ =  SignUpModel(username: userNameSignUp.text!, password: passwordMatchCheck() ? passwordSignUp.text!: "", viewController:self)
        
//        dismiss(animated: true)
    }
    
}


