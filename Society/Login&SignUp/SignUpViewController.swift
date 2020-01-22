//
//  SIgnUpViewController.swift
//  Society
//
//  Created by Simon Tekeste on 1/17/20.
//  Copyright © 2020 Simon Tekeste. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    //MARK:IBoutlets
    @IBOutlet weak var userNameSignUp: UITextField!
    @IBOutlet weak var passwordSignUp: UITextField!
    @IBOutlet weak var confirmPassordSignUp: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameSignUp.attributedPlaceholder = "Username".textPlaceHolder()
        userNameSignUp.addBottomBorder(borderWidth: 2)
        passwordSignUp.attributedPlaceholder = "Password".textPlaceHolder()
        passwordSignUp.addBottomBorder(borderWidth: 2)
        confirmPassordSignUp.attributedPlaceholder = "Confirm Password".textPlaceHolder()
        confirmPassordSignUp.addBottomBorder(borderWidth: 2)
    }
    
    
    //MARK: IBActions
    @IBAction func submitSigningUp(_ sender: Any) {
        //add the push to the db on success dismiss
        dismiss(animated: true)
    }
    
}


